package PJVM::Class::Field;

use strict;
use warnings;

use Scalar::Util qw(weaken);

use PJVM::Class::Attribute;

use Object::Tiny qw(
    access_flags
    name_index
    descriptor_index
    attributes
    parent_class
);

sub new_from_io {
    my ($pkg, $io, $cp, $parent_class) = @_;
    
    my $buff;

    read $io, $buff, 8;

    my ($access_flags, $name_index, $descriptor_index, $attributes_count) = unpack("nnnn", $buff);
        
    # Read attributes
    my @attributes;
    if ($attributes_count) {
        while ($attributes_count--) {
            push @attributes, PJVM::Class::Attribute->new_from_io($io, $cp);
        }
    }
    
    my $self = $pkg->new(
        access_flags        => $access_flags,
        name_index          => $name_index,
        descriptor_index    => $descriptor_index,
        attributes          => \@attributes,
        parent_class        => $parent_class,
    );
    
    weaken $self->parent_class;
    
    return $self;
}

sub name {
    my $self = shift;
    my $name = $self->parent_class->constant_pool->get($self->name_index);
    return $name->value;
}

sub signature {
    my $self = shift;
    my $signature = $self->parent_class->constant_pool->get($self->descriptor_index);
    return $signature->value;
}

1;
__END__

=head1 NAME

PJVM::Class::Field -

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 INTERFACE
