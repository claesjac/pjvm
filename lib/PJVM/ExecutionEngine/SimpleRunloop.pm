package PJVM::ExecutionEngine::SimpleRunloop;

use strict;
use warnings;

use PJVM::InstructionSet qw(:all);

sub new {
    my $pkg = shift;
    return bless do { my $v; \$v; }, $pkg;
}

sub compile {
    my ($self, $code) = @_;
    my @bc = unpack("C*", $code->code);
    return \@bc;
}

{
    sub execute {
        my ($self, $rt, $this, $bc) = @_;
        my $pc = 0;
        my @stack;
        my @locals;
        my $len = scalar @$bc;

        while($pc < $len) {
            my $op = $bc->[$pc++];

            print STDERR "Executing op: ", opcode_to_mnemonic($op), "\n";
            
            if ($op == JVM_OP_aaload || $op == JVM_OP_baload || $op == JVM_OP_caload || $op == JVM_OP_daload) {
                my $index = pop @stack;
                my $array = pop @stack;
                die "NullPointerException" unless defined $array;
                die "ArrayIndexOutOfBoundsException" if $index > $array->length;
                push @stack, $array->get($index);
            }
            elsif ($op == JVM_OP_aastore || $op == JVM_OP_bastore || $op == JVM_OP_castore || $op == JVM_OP_dastore) {
                my $value = pop @stack;
                my $index = pop @stack;
                my $array = pop @stack;
                die "NullPointerException" unless defined $array;
                die "ArrayIndexOutOfBoundsException" if $index > $array->length;
                # TODO: check that we don't try to put somehting incompatible into the array.
                # but for now we don't give a crap since I just want something that runs.. (and typing is for sissies)
                $array->set($index, $value);
            }
            elsif ($op == JVM_OP_aconst_null) {
                push @stack, undef;
            }
            elsif ($op == JVM_OP_aload || $op == JVM_OP_dload) {
                my $index = $bc->[$pc++];
                push @stack, $locals[$index];
            }
            elsif ($op >= JVM_OP_aload_0 && $op <= JVM_OP_aload_3) {
                push @stack, $locals[$op - JVM_OP_aload_0];
            }
            elsif ($op == JVM_OP_ldc) {
                my $index = pop @stack;
                my $class = $this->class;
                my $v = $class->cp->get($index);
                use Data::Dumper qw(Dumper);
                print STDERR Dumper($v), "\n";
                push @stack, $v;
            }
            elsif ($op == JVM_OP_anewarray) {
                # TODO: implement
                $pc += 2;
            }
            elsif ($op == JVM_OP_areturn || $op == JVM_OP_dreturn) { return pop @stack; }
            elsif ($op == JVM_OP_arraylength) {
                my $array = pop @stack;
                die "NullPointerException" unless defined $array;
                push @stack, $array->length;
            }
            elsif ($op == JVM_OP_astore || $op == JVM_OP_dstore) {
                my $index = $bc->[$pc++];
                my $object = pop @stack;
                $locals[$index] = $object;
            }
            elsif ($op >= JVM_OP_astore_0 && $op <= JVM_OP_astore_3) {
                my $index = $op - JVM_OP_aload_0;
                my $object = pop @stack;
                $locals[$index] = $object;
            }
            elsif ($op == JVM_OP_athrow) { 
                # TODO: error handling is for suckers, don't write code that FAILS!
            }
            elsif ($op == JVM_OP_bipush) { push @stack, $bc->[$pc++]; }
            elsif ($op == JVM_OP_checkcast) {
                my ($i1, $i2) = ($bc->[$pc++], $bc->[$pc++]);
                my $index = $i1 << 8 | $i2;
                # TODO: does a lookup in the constant pool and do stuff            
            }
            elsif ($op == JVM_OP_d2f) { # Convert double to float 
            }
            elsif ($op == JVM_OP_d2i || $op == JVM_OP_d2l) { push @stack, int(pop @stack); }
            elsif ($op == JVM_OP_dadd) { push @stack, (pop(@stack) + pop(@stack)); }
            elsif ($op == JVM_OP_dcmpg || $op == JVM_OP_dcmpl) { push @stack, (pop(@stack) <=> pop(@stack)); }
            elsif ($op == JVM_OP_dconst_0) { push @stack, 0.0; }
            elsif ($op == JVM_OP_dconst_1) { push @stack, 1.0; }
            elsif ($op == JVM_OP_ddiv) { my $v2 = pop @stack; my $v1 = pop @stack; push @stack, ($v1 / $v2); }
            elsif ($op >= JVM_OP_dload_0 && $op <= JVM_OP_dload_3) {
                push @stack, $locals[$op - JVM_OP_dload_0];
            }
            elsif ($op == JVM_OP_dmul) { push @stack, (pop(@stack) * pop(@stack)); }
            elsif ($op == JVM_OP_dneg) { push @stack, (pop(@stack) * -1); }
            elsif ($op == JVM_OP_drem) { my $v2 = pop @stack; my $v1 = pop @stack; push @stack, ($v1 % $v2); }
            elsif ($op >= JVM_OP_dstore_0 && $op <= JVM_OP_dstore_3) {
                my $index = $op - JVM_OP_aload_0;
                my $object = pop @stack;
                $locals[$index] = $object;
            }
            elsif ($op == JVM_OP_dsub) { push @stack, (pop(@stack) - pop(@stack)); }
            elsif ($op == JVM_OP_dup) { push @stack, $stack[-1]; }
            elsif ($op == JVM_OP_dup_x1) { splice @stack, -2, 0, $stack[-1]; }
            elsif ($op == JVM_OP_dup_x2) {
                # TODO: dear JVM spec, not all stacks are a continous chunk of memory that needs to know
                # what type you expect
            }
            elsif ($op == JVM_OP_dup_x2) { splice @stack, -2, 0, @stack[-2, -1]; }
            elsif ($op == JVM_OP_ldc2_w) {
                my ($i1, $i2) = ($bc->[$pc++], $bc->[$pc++]);
                my $ix = $i1 << 8 | $i2;
                my $pi = $this->class->cp->[$ix];
                push @stack, $pi->value;                
            }
            elsif ($op == JVM_OP_getstatic) {
                my $cp = $this->class->cp; # constant pool
                my ($i1, $i2) = ($bc->[$pc++], $bc->[$pc++]);
                my $ix = $i1 << 8 | $i2;
                my $pi = $cp->[$ix];
                my $class = $cp->[$cp->[$pi->class_index]->name_index]->value;
                my $field = $cp->[$cp->[$pi->name_and_type_index]->name_index]->value;            
                push @stack, $rt->get_class($class)->class->get_field_value($field);
                print STDERR Dumper(\@stack);
            }
            elsif ($op >= JVM_OP_fconst_0 && $op <= JVM_OP_fconst_2) {
                push @stack, $op - JVM_OP_fconst_0 + 0.0;
            }
            elsif ($op == JVM_OP_nop) {
                # do nothing
            }
            elsif ($op == JVM_OP_return) {
                return;
            }
            else {
                die "No implementation for ", opcode_to_mnemonic($op), "\n";
            }            
        };
    }
}

1;
__END__

=head1 NAME

PJVM::ExecutionEngine::SimpleRunloop -

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 INTERFACE
