package PJVM::Decompiler;

use 5.010;

use strict;
use warnings;

use Module::Load qw();

use Object::Tiny qw(output_class);

sub new {
    my ($class, $args) = @_;
    
    $args = {} unless ref $args eq "HASH";
    
    my $output_class = "PJVM::Decompiler::" . ($args->{output} // "Java");
    
    Module::Load::load $output_class;
    
    my $self = bless {
        output_class => $output_class
    }, $class;

    return $self;
}

sub decompile {
    my ($self, @classes) = @_;
    
    for my $class (@classes) {
        my $output = $self->output_class->decompile($class);
        say $output;
    }
}

1;