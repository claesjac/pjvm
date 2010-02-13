package PJVM::Class::Attribute::ConstantValue;

use strict;
use warnings;

use Object::Tiny qw(
    constantvalue_index
);

sub new_from_io {
    my ($pkg, $io, $cp) = @_;
    
    my $buff;
    
    # Stack stuff
    read $io, $buff, 2;
    my $constantvalue_index = unpack("n", $buff);
        
    my $self = $pkg->new(
        constantvalue_index => $constantvalue_index,
    );
    
    return $self;
}

1;
__END__

=head1 NAME

PJVM::Class::Attribute::ConstantValue -

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 INTERFACE
