package PJVM::Class;

use strict;
use warnings;

use PJVM::Class::ConstantPool;
use PJVM::Class::Field;
use PJVM::Class::Method;

use PJVM::Types;

use Object::Tiny qw(
    constant_pool
    access_flags
    this_class
    super_class
    interfaces_classes
    fields
    methods
    attributes
);

*cp = \&constant_pool;

sub new_from_io {
    my ($pkg, $io) = @_;
    
    my $buff;
    
    my $self = $pkg->new();
    
    # Check that's it is actually a class file
    read $io, $buff, 4;
    die "Not a classfile" unless sprintf("%x", unpack("N", $buff)) eq "cafebabe";
    
    # TODO: Blah blah blah.. version compliance crap, let's skip this for now and
    # maybe sometime in the future do something with it.
    read $io, $buff, 4;
    
    # Constant pool count.. here lies our constants, ie class names etc.    
    my $cp = PJVM::Class::ConstantPool->new_from_io($io);
    $self->{constant_pool} = $cp;

    # Access flags (you know, public etc...)
    read $io, $buff, 2;
    my $access_flags = unpack("n", $buff);
    $self->{access_flags} = $access_flags,
    
    # Name of class and parent
    read $io, $buff, 4;
    my ($this_class, $super_class) = unpack("nn", $buff);
    $self->{this_class} = $this_class,
    $self->{super_class} = $super_class,
        
    # Read interfaces
    read $io, $buff, 2;
    my $interface_count = unpack("n", $buff);
    my @interfaces;
    if ($interface_count) {
        read $io, $buff, 2 * $interface_count;
        @interfaces = unpack("n*", $buff);
    }
    $self->{interfaces_classes} = \@interfaces,
    
    # Read fields
    read $io, $buff, 2;
    my $fields_count = unpack("n", $buff);
    my @fields;
    if ($fields_count) {
        while ($fields_count--) {
            push @fields, PJVM::Class::Field->new_from_io($io, $cp, $self);
        }
    }
    $self->{fields} = \@fields,
    
    # Read methods
    read $io, $buff, 2;
    my $methods_count = unpack("n", $buff);
    my @methods;
    if ($methods_count) {
        while ($methods_count--) {
            push @methods, PJVM::Class::Method->new_from_io($io, $cp, $self);
        }
    }
    $self->{methods} = \@methods,
    
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
    $self->{attributes} = \@attributes,
    
    return $self;    
}

# TODO: Optimize since this will probablly be called mucho tiempo
sub method {
    my ($self, $name, $signature) = @_;

    for my $method (@{$self->methods}) {
        if ($method->name eq $name && $method->signature eq $signature) {
            return $method;
        }
    }
}

sub name {
    my $self = shift;
    my $class = $self->constant_pool->get($self->this_class);
    my $name = $self->constant_pool->get($class->name_index);
    
    return $name->value;
}

sub super {
    my $self = shift;
    my $class = $self->constant_pool->get($self->super_class);
    my $name = $self->constant_pool->get($class->name_index);
    
    return $name->value;
}

sub interfaces {
    my $self = shift;
    my @names = map {
        my $class = $self->constant_pool->get($_);
        my $name = $self->constant_pool->get($class->name_index);
        $name->value;
    } @{$self->interfaces_classes};
    
    return @names;
}

sub all_references {
    my $self = shift;

    my %refs;
    $refs{$self->super} = 1;
    $refs{$_} = 1 for $self->interfaces;
    
    for my $field (@{$self->fields}) {
        my @refs = PJVM::Types->extract_references_from_signature($field->signature);
        $refs{$_} = 1 for @refs;
    }
    
    return keys %refs;
}

1;
__END__

=head1 NAME

PJVM::Class -

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 INTERFACE
