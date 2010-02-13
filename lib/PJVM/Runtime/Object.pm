package PJVM::Runtime::Object;

use strict;
use warnings;

use Scalar::Util qw(weaken);

use PJVM::Access qw(:flags);

sub new {
    my ($pkg, $class) = @_;
    my $self = bless { ".class" => $class }, $pkg;
    weaken $self->{".class"};
    # Set defaults for all fields
    my $fields = $class->instance_fields;
    for my $name (keys %$fields) {
        my $default = PJVM::Types->default_value_for_signature($fields->{$name});
        $self->{$name} = $default;
    }
    
    return $self;
}

sub class {
    my $self = shift;
    return $self->{".class"};
}

sub clone {
    my $self = shift;
    my $clone = bless {}, $self;
    $clone->{$_} = $self->{$_} for keys %$self;
    return $clone;
}

1;
__END__

=head1 NAME

PJVM::Runtime::Object -

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 INTERFACE
