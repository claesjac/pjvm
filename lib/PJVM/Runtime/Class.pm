package PJVM::Runtime::Class;

use strict;
use warnings;

use PJVM::Types;
use PJVM::Access qw(:flags);
use PJVM::Runtime qw(rt_pop_stack);

use Object::Tiny qw(
    qname
    methods
    methods_access
    fields
    fields_access
    ee
    extends
    implements
    cp
    is_initialized
    is_interface
);

sub new_from_spec {
    my ($pkg, $runtime, $spec) = @_;
    
    my $self = $pkg->SUPER::new(
        qname           => $spec->name,
    );
    
    # Methods
    
    my $ee = $runtime->default_execution_engine;
    my (%methods, %methods_access);
    for my $method (@{$spec->methods}) {
        # handle clinit
        my $mkey = $method->name . $method->signature;
        # Let the engine have a chance to compile this if we want too
        my $cb = $ee->compile($method->code);
        $methods{$mkey} = ref $cb eq "CODE" ? $cb : sub { $ee->execute(shift, shift, $cb) };
        $methods_access{$mkey} = $method->access_flags;
    }

    # Create default class init method
    unless (exists $methods{"<clinit>()V"}) {
        $methods{"<clinit>()V"} = sub { 
            PJVM::Runtime::rt_pop_stack(); 
        };
        $methods_access{"<clinit>()V"} = ACC_PRIVATE;
    }
    
    # Fields
    my (%fields, %fields_access);
    for my $field (@{$spec->fields}) {
        $fields{$field->name} = $field->signature;
        $fields_access{$field->name} = $field->access_flags;
    }
    
    # Extends
    my $extends = $spec->super;
    my @implements = $spec->interfaces;
    
    $self->{methods}        = \%methods,
    $self->{methods_acces}  = \%methods_access,
    $self->{fields}         = \%fields,
    $self->{fields_access}  = \%fields_access,
    $self->{access_flags}   = $spec->access_flags,
    $self->{cp}             = $spec->constant_pool,
    $self->{extends}        = $extends,
    $self->{implements}     = \@implements,

    # Static fields
    $self->{static_fields_value}         = {};
    for my $name (keys %fields) {
        next unless $fields_access{$name} & ACC_STATIC;
        my $default = $fieldsPJVM::Types->default_value_for_signature($fields{$name});
        $self->{static_fields_value}->{$name} = $default;
    }
    
    return $self;
}

sub class {
    my $self = shift;
    return $self;
}

sub has_method {
    my ($self, $signature) = @_;
    return exists $self->{methods}->{$signature};
}

sub get_method {
    my ($self, $signature) = @_;
    my $method = $self->{methods}->{$signature};    
    die "AbstractMethodError" unless $method;
    return $method;
}

sub static_fields {
    my $self = shift;
    my $fields = $self->fields;
    my $fields_access = $self->fields_access;
    my %static = map { $_ => $fields->{$_} } grep { $fields_access->{$_} & ACC_STATIC } keys %$fields;
    return \%static;
}

sub instance_fields {
    my $self = shift;
    my $fields = $self->fields;
    my $fields_access = $self->fields_access;
    my %static = map { $_ => $fields->{$_} } grep { !($fields_access->{$_} & ACC_STATIC)  } keys %$fields;
    return \%static;
}

sub clinit {
    my ($self, $runtime) = @_;

    return if $self->is_initialized;
    if ($self->has_method("<clinit>()V")) {
        $runtime->call("<clinit>()V", $self);
    }
    $self->{is_initialized} = 1;
}

sub get_field_value {
    my ($self, $field) = @_;
    return $self->{static_field_value}->{$field};
}

sub set_field_value {
    my ($self, $field, $value) = @_;
    $self->{static_field_value}->{$field} = $value;
}

1;
__END__

=head1 NAME

PJVM::Runtime::Class -

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 INTERFACE
