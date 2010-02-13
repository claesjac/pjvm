package PJVM::Decompiler::ToText;

use strict;
use warnings;

use PJVM::Decompiler::Util;

use Object::Tiny qw(io buffer);

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
    
    my $refs = 0;
    for my $reference (@references) {
        my ($ref_pkg) = to_java_pkg_and_name($reference);
        next if $ref_pkg eq $my_pkg || $ref_pkg eq "java.lang";
        $self->io->print("import ", to_java_fqcn($reference), ";\n");
        $refs++;
    }
    
    $self->io->print("\n") if $refs;
}

sub do_class_open {
    my ($self, $class) = @_;
    
    my ($my_pkg, $name) = to_java_pkg_and_name($class->name);
    $self->io->print("class ", $name);
    

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

sub results {
    my $self = shift;
    return ${$self->buffer};
}

1;