package PJVM::Decompiler::Perl;

use 5.014;

use strict;
use warnings;

use PJVM::Access qw(:flags);
use PJVM::Bytecode::Reader;
use PJVM::Decompiler::Util;
use PJVM::InstructionSet qw(:all);
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

sub decompile {
    my $class = pop;
    my $self = __PACKAGE__->new();
    
    my $io = $self->io;
    
    $io->say("package ", _to_package_name($class->name), ";");
    $io->say("");
    $io->say("use warnings;");
    $io->say("use strict");
    $io->say("");
    
    # Imports of other classes
    my @references = sort $class->all_references();
    if (@references) {
        $io->say("# The classes I depend on");
        for my $reference (@references) {
            $io->say("use ", _to_package_name($reference), ";");
        }
    }

    # "Class fields"
    my @fields = sort grep $_->access_flags & ACC_STATIC,  @{$class->fields};
    if (@fields) {        
        $io->say("");
        $io->say("# Static fields");
        for my $field (@fields) {
            $io->say('our $', $field->name, ";");
        }
    }
    
    # Methods
    my @methods = sort { $a->name cmp $b->name } @{$class->methods};
    for my $method (@methods) {
        # Skip constructors and class initialisation methods
        next if $method->name =~ /^<(cl)?init>$/;
        $io->say("");
        $io->say("sub ", $method->name, " {");
        $self->_decompile_method_body($class, $method);
        $io->say("}");
    }
    
    # Run this
    my $clinit = $class->method("<clinit>", "()V");
    if ($clinit) {
        $io->say("");
        $io->say("{");
        $self->_decompile_method_body($class, $clinit);
        $io->say("}");
    }
    
    return $self->results;
}

sub _decompile_bytecode {
    my ($self, $class, $method, $stack, $bytecode) = @_;

    my $io = $self->io;

    my $pc = 0;
    while ($pc < @$bytecode) {
        my $next = $bytecode->[$pc++];
        next unless $next;
        my ($op, @data) = @$next;
        if ($op == JVM_OP_aload_0) {
            push $stack, '$this';
        }
        elsif ($op == JVM_OP_bipush) {
            push $stack, $data[0];
        }
        elsif ($op == JVM_OP_if_icmpne) {
            my $op2 = pop $stack;
            my $op1 = pop $stack;
            $io->say("if ($op1 != $op2) {");
        }
        elsif ($op == JVM_OP_if_icmple) {
            my $op2 = pop $stack;
            my $op1 = pop $stack;
            $io->say("if ($op1 <= $op2) {")            
        }
        elsif ($op == JVM_OP_new) {
            my $type = $class->cp->get($data[0]);
            my $target_class = $class->cp->get($type->name_index)->value;
            $io->say(_to_package_name($target_class), "->new()");
#            my $target_method = $class->cp->get($field->name_and_type_index);
 #           $var .= "::" . $class->cp->get($target_method->name_index)->value;
            
        }
        elsif ($op == JVM_OP_getfield) {
            my $field = $class->cp->get($data[0]);
            my $target_class = $class->cp->get($field->class_index);
            my $target_field = $class->cp->get($field->name_and_type_index);
            $stack->[-1] .= '->{' . $class->cp->get($target_field->name_index)->value . '}';
        }
        elsif ($op == JVM_OP_getstatic) {
            my $field = $class->cp->get($data[0]);
            my $target_class = $class->cp->get($field->class_index);
            my $var = '$' . _to_package_name($class->cp->get($target_class->name_index)->value);
            my $target_method = $class->cp->get($field->name_and_type_index);
            $var .= "::" . $class->cp->get($target_method->name_index)->value;
            push $stack, $var;
        }
        elsif ($op == JVM_OP_invokevirtual) {
            my $field = $class->cp->get($data[0]);
            my $target_class = $class->cp->get($field->class_index);
            $io->print(_to_package_name($class->cp->get($target_class->name_index)->value));
            my $target_method = $class->cp->get($field->name_and_type_index);
            $io->print("::", $class->cp->get($target_method->name_index)->value);
            $io->print("(", join(", ", @$stack), ")");
            $io->say(";");
            $stack = [];
        }
        elsif ($op == JVM_OP_ldc) {
            my $value_ref = $class->cp->get($data[0]);
            my $value;
            if ($value_ref->isa("PJVM::Class::ConstantPool::String")) {
                $value = q{"} . $class->cp->get($value_ref->string_index)->value . q{"};
            }
            else {
                $value = $value_ref->value;
            }
            push $stack, $value;
        }
        elsif ($op == JVM_OP_return) {
            if (@$stack) {
                $io->say("return ", pop $stack);
            }
        }
        else {
            $io->say(opcode_to_mnemonic($op));
        }
    }    
}

sub _decompile_method_body {
    my ($self, $class, $method) = @_;
    
    my @bytecode = @{PJVM::Bytecode::Reader->read($method->bytecode)};
    my @stack;
    
    $self->_decompile_bytecode($class, $method, \@stack, \@bytecode);
}

sub _to_package_name {
    my $name = shift;
    $name =~ s{/|\.}{::}g;
    return $name;
}


sub results {
    my $self = shift;
    my $output = ${$self->buffer};
    $output =~ s/ +/ /gm;
    $output =~ s/^(\t+)/"  " x length($1)/gme;
    return $output;
}

1;