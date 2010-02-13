package PJVM::Class::Attribute::LocalVariableTable;

use strict;
use warnings;

use Object::Tiny qw(
    local_variable_table
);

sub new_from_io {
    my ($pkg, $io, $cp) = @_;
    
    my $buff;
    
    read $io, $buff, 2;
    my $local_variable_table_length = unpack("n", $buff);
    
    my @classes;
    while ($local_variable_table_length--) {
        read $io, $buff, 10;
        push @classes, [unpack("n*", $buff)];
    }
    
    my $self = $pkg->new(
        local_variable_table => \@classes,
    );
    
    return $self;
}

1;
__END__

=head1 NAME

PJVM::Class::Attribute::LocalVariableTable -

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 INTERFACE
