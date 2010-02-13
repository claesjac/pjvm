package PJVM::Class::Method;

use strict;
use warnings;

use Scalar::Util qw(weaken);

use PJVM::Access qw(:flags);
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
        parent_class       => $parent_class,
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

sub code {
    my $self = shift;
    
    # Locate first attribute which is a code
    for my $attribute (@{$self->attributes}) {
        if ($attribute->isa("PJVM::Class::Attribute::Code")) {
            return $attribute;
        }
    }    
    
    if ($self->access_flags & ACC_NATIVE || $self->access_flags & ACC_ABSTRACT) {
        return;
    }
    
    die "Method has no 'Code' attribute.. that is very very bad"
}

sub bytecode {
    my $self = shift;
    
    # Locate first attribute which is a code
    my $code = $self->code;
    return $code->code if $code;
    
    return '';
}

1;
__END__

=head1 NAME

PJVM::Class::Method -

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 INTERFACE
