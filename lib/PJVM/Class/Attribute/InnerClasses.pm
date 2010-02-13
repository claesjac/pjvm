package PJVM::Class::Attribute::InnerClasses;

use strict;
use warnings;

use Object::Tiny qw(
    classes
);

sub new_from_io {
    my ($pkg, $io, $cp) = @_;
    
    my $buff;
    
    read $io, $buff, 2;
    my $number_of_classes = unpack("n", $buff);
    
    my @classes;
    while ($number_of_classes--) {
        read $io, $buff, 8;
        push @classes, [unpack("n*", $buff)];
    }
    
    my $self = $pkg->new(
        classes => \@classes,
    );
    
    return $self;
}

1;
__END__

=head1 NAME

PJVM::Class::Attribute::InnerClasses -

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 INTERFACE
