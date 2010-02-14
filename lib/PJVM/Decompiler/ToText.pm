package PJVM::Decompiler::ToText;

use strict;
use warnings;

use PJVM::Decompiler::Util;
use PJVM::Access qw(:flags);

use Object::Tiny qw(io buffer imports);

sub new { 
    my ($class) = @_;
    
    my $buffer = "";
    open my $fh, ">", \$buffer or die $!;
    
    my $self = bless {
        buffer => \$buffer,
        io => $fh,
    }, $class;
    
    return $self;
}

sub DESTROY {
    my $self = shift;
    close $self->io;
}

sub do_package_decl {
    my ($self, $class) = @_;
    
    my ($package, $name) = to_java_pkg_and_name($class->name);
    
    $self->io->print("package ${package};\n\n") if $package;
}

sub do_imports {
    my ($self, $class) = @_;
    
    my @references = $class->all_references();
    my ($my_pkg) = to_java_pkg_and_name($class->name);
    
    @references = sort @references;
    
    my %imports;
    for my $reference (@references) {
        my ($ref_pkg) = to_java_pkg_and_name($reference);
        next if $ref_pkg eq $my_pkg || $ref_pkg eq "java.lang";
        $self->io->print("import ", to_java_fqcn($reference), ";\n");
        $imports{$reference} = 1;
    }

    $self->io->print("\n") if %imports;
    $self->{imports} = \%imports;
}

sub do_class_open {
    my ($self, $class) = @_;
    
    my $access = to_java_access($class->access_flags, qw(public final abstract));
    $access .= " " if $access;
    
    my ($my_pkg, $name) = to_java_pkg_and_name($class->name);
    $self->io->print($access, ($class->access_flags & ACC_INTERFACE ? "interface " : "class "), $name);
    

    my $extends = $class->super;
    unless($extends eq "java/lang/Object") {
        my ($ref_pkg, $name) = to_java_pkg_and_name($extends);
        
        if ($ref_pkg eq $my_pkg || $ref_pkg eq "java.lang") {
            $self->io->print(" extends ", $name);
        }
        else {
            $self->io->print(" extends ", $ref_pkg, ".", $name);
        }
    }
    
    $self->io->print(" {\n");
}

sub do_class_close {
    my ($self, $class) = @_;
    
    $self->io->print("}");
}

sub do_field {
    my ($self, $class, $field) = @_;
    
    my ($my_pkg, undef) = to_java_pkg_and_name($class->name);

    my $access = to_java_access($field->access_flags);
    $access .= " " if $access;

    my $type = (PJVM::Types->decode_signature($field->signature))[0];
    
    my ($ref_pkg, $name) = to_java_pkg_and_name($type->[0]);
    $name = fix_reserved_java_word($name);
    my $signature = 
        $my_pkg eq $ref_pkg || $ref_pkg eq "java.lang" ? 
        $name : "${ref_pkg}.${name}";
    $signature = $name if exists $self->imports->{$type->[0]};
    $signature .= "[]" x $type->[1];

    $self->io->print("\t", $access, $signature, " ", fix_reserved_java_word($field->name), ";\n");
}

sub do_fields_done {
    my $self = shift;
    $self->io->print("\n");
}

sub do_method {
    my ($self, $class, $method) = @_;
    
    my ($my_pkg, undef) = to_java_pkg_and_name($class->name);
    
    my $access = to_java_access($method->access_flags, qw(
        public protected private
        abstract static final
        synchronized native strictfp));

    $access .= " " if $access;
    
    my $name = $method->name;
    $name = $class->name if $name eq "<init>";
    $name = fix_reserved_java_word($name);
    $self->io->print("\t", $access, $name, "(");
    $self->io->print(")");
    $self->io->print(" {\n");
}

sub do_methods_done {
    my $self = shift;
    $self->io->print("\n");
}

sub results {
    my $self = shift;
    my $output = ${$self->buffer};
    $output =~ s/^(\t+)/"  " x length($1)/gme;
    return $output;
}

1;