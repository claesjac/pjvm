package PJVM::Class::Attribute::Exceptions;

use strict;
use warnings;

use Object::Tiny qw(
    exceptions_index_table
);

sub new_from_io {
    my ($pkg, $io, $cp) = @_;
    
    my $buff;
    
    # Number of exceptions
    read $io, $buff, 2;
    my $number_of_exceptions = unpack("n", $buff);
    
    read $io, $buff, $number_of_exceptions * 2;
    my @exceptions_index_table = unpack("n*", $buff);
    
    my $self = $pkg->new(
        exceptions_index_table => \@exceptions_index_table,
    );
    
    return $self;
}

1;
__END__

=head1 NAME

PJVM::Class::Attribute::Exceptions -

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 INTERFACE
