package PJVM::Class::Attribute::Code;

use strict;
use warnings;

use Object::Tiny qw(
    max_stack
    max_locals
    code
    exceptions_table
);

sub new_from_io {
    my ($pkg, $io, $cp) = @_;
    
    my $buff;
    
    # Stack stuff
    read $io, $buff, 4;
    my ($max_stack, $max_locals) = unpack("nn", $buff);
    
    # Number of operations
    read $io, $buff, 4;
    my $op_count = unpack("N", $buff);
    
    # Load code
    read $io, $buff, $op_count;
    my $code = $buff;
    
    # Exceptions stuff
    read $io, $buff, 2;
    my $ex_table_count = unpack("n", $buff);
    my @exceptions_table;
    while ($ex_table_count--) {
        read $io, $buff, 8;
        my ($start_pc, $end_pc, $handler_pc, $catch_type) = unpack("nnnn", $buff);
        push @exceptions_table, [$start_pc, $end_pc, $handler_pc, $catch_type];
    }
    
    # Attributes
    read $io, $buff, 2;
    my $attributes_count = unpack("n", $buff);
        
    # Read attributes
    my @attributes;
    if ($attributes_count) {
        while ($attributes_count--) {
            push @attributes, PJVM::Class::Attribute->new_from_io($io, $cp);
        }
    }    
    
    my $self = $pkg->new(
        max_stack           => $max_stack,
        max_locals          => $max_locals,
        code                => $code,
        exceptions_table    => \@exceptions_table,
        attributes          => \@attributes,
    );
    
    return $self;
}

1;
__END__

=head1 NAME

PJVM::Class::Attribute::Code -

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 INTERFACE
