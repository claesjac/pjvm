package PJVM::Bytecode::Reader;

use strict;
use warnings;

use List::MoreUtils qw(any);

sub _index_byte     { ${$_[1]} += 1; return (shift @{$_[0]}); }

sub _index_short    { ${$_[1]} += 2; my ($i1, $i2) = splice @{$_[0]}, 0, 2; return ($i1 << 8 | $i2); }

sub _byte           { ${$_[1]} += 1; return (shift @{$_[0]}); }

sub _short          { ${$_[1]} += 2; my ($i1, $i2) = splice @{$_[0]}, 0, 2; return ($i1 << 8 | $i2); }

sub _offset_short   { ${$_[1]} += 2; my ($o1, $o2) = splice @{$_[0]}, 0, 2; return ($o1 << 8 | $o2); }

sub _offset_long    { 
    ${$_[1]} += 4; 
    my ($o1, $o2, $o3, $o4) = splice @{$_[0]}, 0, 4;
    return ($o1 << 24 | $o2 << 16 | $o3 << 8 | $o4);
}

sub _index_byte_const {
    ${$_[1]} += 2; 
    return splice @{$_[0]}, 0, 2;
}

sub _index_short_count_0 {
    ${$_[1]} += 4; 
    my ($i1, $i2, $count, undef) = splice @{$_[0]}, 0, 4;
    return ($i1 << 8 | $i2, $count);
}

sub _index_short_count {
    ${$_[1]} += 3; 
    my ($i1, $i2, $count) = splice @{$_[0]}, 0, 3;
    return ($i1 << 8 | $i2, $count);
}


my %Op_transformation = (
    0x19 => \&_index_byte, # aload
    0xbd => \&_index_short, # anewarray    
    0x3a => \&_index_byte, # astore 
    
    0x10 => \&_byte, # bipush

    0xc0 => \&_index_short, # checkcast
    
    0x18 => \&_index_byte, # dload
    0x39 => \&_index_byte, # dstore
    
    0x17 => \&_index_byte, # fload
    0x38 => \&_index_byte, # fstore
    
    0xb4 => \&_index_short, # getfield
    0xb2 => \&_index_short, # getstatic
    0xa7 => \&_offset_short, # goto
    0xc8 => \&_offset_long, # goto_w
    
    0xa5 => \&_offset_short, # if_acmpeq
    0xa6 => \&_offset_short, # if_acmpne
    0x9f => \&_offset_short, # if_icmpeq
    0xa0 => \&_offset_short, # if_icmpne
    0xa1 => \&_offset_short, # if_icmplt
    0xa2 => \&_offset_short, # if_icmpge
    0xa3 => \&_offset_short, # if_icmpgt
    0xa4 => \&_offset_short, # if_icmple
    0x99 => \&_offset_short, # ifeq
    0x9a => \&_offset_short, # ifne
    0x9b => \&_offset_short, # iflt
    0x9c => \&_offset_short, # ifge
    0x9d => \&_offset_short, # ifgt
    0x9e => \&_offset_short, # ifle
    0xc7 => \&_offset_short, # ifnotnull
    0xc6 => \&_offset_short, # ifnull
    0x84 => \&_index_byte_const, # iinc
    0x15 => \&_index_byte, # iload
    0xc1 => \&_index_short, # instanceof
    0xb9 => \&_index_short_count_0, # invokeinterface
    0xb7 => \&_index_short, # invokespecial
    0xb8 => \&_index_short, # invokestatic
    0xb6 => \&_index_short, # invokevirtual
    0x36 => \&_index_byte, # istore
    
    0xa8 => \&_offset_short, # jsr
    0xc9 => \&_offset_long, # jsr_w
    
    0x12 => \&_index_byte, # ldc
    0x13 => \&_index_short, # ldc_w
    0x14 => \&_index_short, # ldc2_w
    0x16 => \&_index_short, # lload
    0xab => sub { # lookupswitch
        my ($ops, $ix) = @_;
        my $pad = 3 - ($$ix - 1) % 4;
        if ($pad) {
            splice @$ops, 0, $pad;
            $$ix += $pad;
        };
        
        # default offset
        my ($d1, $d2, $d3, $d4) = splice @$ops, 0, 4;
        $$ix += 4;
        my $default = ($d1 << 24 | $d2 << 16 | $d3 << 8 | $d4);

        # number of case <int>:
        my ($n1, $n2, $n3, $n4) = splice @$ops, 0, 4;
        $$ix += 4;
        my $case_no = ($d1 << 24 | $d2 << 16 | $d3 << 8 | $d4);
        
        my @pairs;
        if ($case_no) {
            my ($i1, $i2, $i3, $i4, $o1, $o2, $o3, $o4) = splice @$ops, 0, 8;
            $$ix += 8;
            push @pairs, ($i1 << 24 | $i2 << 16 | $i3 << 8 | $i4), ($o1 << 24 | $o2 << 16 | $o3 << 8 | $o4);
        }
        
        return ($default, @pairs);
    },
    0x37 => \&_index_byte, # lstore
    
    0xc5 => \&_index_short_count, # multianewarray
    
    0xbb => \&_index_short, # new
    0xbc => \&_byte, # newarray 
    
    0xb5 => \&_index_short, # putfield
    0xb3 => \&_index_short, # putstatic
    
    0xa9 => \&_index_byte, # ret
    
    0x11 => \&_short, # sipush

    0xaa => sub { # tableswitch
        my ($ops, $ix) = @_;
        my $pad = 3 - ($$ix - 1) % 4;
        if ($pad) {
            splice @$ops, 0, $pad;
            $$ix += $pad;
        };
        
        # default offset
        my ($d1, $d2, $d3, $d4) = splice @$ops, 0, 4;
        $$ix += 4;
        my $default = ($d1 << 24 | $d2 << 16 | $d3 << 8 | $d4);

        # low <int>:
        my ($l1, $l2, $l3, $l4) = splice @$ops, 0, 4;
        $$ix += 4;
        my $low = ($l1 << 24 | $l2 << 16 | $l3 << 8 | $l4);

        my ($h1, $h2, $h3, $h4) = splice @$ops, 0, 4;
        $$ix += 4;
        my $high = ($h1 << 24 | $h2 << 16 | $h3 << 8 | $h4);
        
        my $jump_offsets = $high - $low + 1;
        my @jump_offsets;
        if ($jump_offsets) {
            my ($o1, $o2, $o3, $o4) = splice @$ops, 0, 4;
            $$ix += 4;
            push @jump_offsets, ($o1 << 24 | $o2 << 16 | $o3 << 8 | $o4);
        }
        
        return ($default, $low, $high, @jump_offsets);
    },
    
    0xc4 => sub { # wide
        my ($ops, $ix) = @_;
        
        my $op = shift @$ops;
        $$ix++;
        
        if ($op == 0x84) {
            my ($i1, $i2, $c1, $c2) = splice @$ops, 0, 4;
            $$ix += 4;
            return ($op, $i1 << 8 | $i2, $c1 << 8 | $c2);            
        }
        elsif (any { $_ == $op } (0x15, 0x36, 0x17, 0x38, 0x19, 0x3a, 0x16, 0x37, 0x18, 0x39, 0xa9)) {
            my ($i1, $i2) = splice @$ops, 0, 2;
            $$ix += 2;
            return ($op, $i1 << 8 | $i2);
        }
        else {
            die "Bytecode stream error"
        }
    }
);    
    
sub read {
    my ($pkg, $bytecode) = @_;
    
    my @bytecode = unpack("C*", $bytecode);
    my @ops;
    my $ix = 0;
    while (@bytecode) {
        my $opcode = shift @bytecode;
        my $pc = $ix++;
        my $transformer = $Op_transformation{$opcode};
        my @args = defined $transformer ? $transformer->(\@bytecode, \$ix) : ();
        push @ops, [$opcode, @args], (undef) x ($ix - 1 - $pc);
    }
    
    return \@ops;
}

1;
__END__

=head1 NAME

PJVM::Bytecode::Reader -

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 INTERFACE
