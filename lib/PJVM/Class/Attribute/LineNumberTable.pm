package PJVM::Class::Attribute::LineNumberTable;

use strict;
use warnings;

use Object::Tiny qw(
    line_number_table
);

sub new_from_io {
    my ($pkg, $io, $cp) = @_;
    
    my $buff;
    
    read $io, $buff, 2;
    my $line_number_table_length = unpack("n", $buff);
    
    my @line_number_table;
    while ($line_number_table_length--) {
        read $io, $buff, 4;
        push @line_number_table, [unpack("n*", $buff)];
    }
    
    my $self = $pkg->new(
        line_number_table => \@line_number_table,
    );
    
    return $self;
}

1;
__END__

=head1 NAME

PJVM::Class::Attribute::LineNumberTable -

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 INTERFACE
