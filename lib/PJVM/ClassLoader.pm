package PJVM::ClassLoader;

use strict;
use warnings;

use File::Spec;
use File::Slurp qw(slurp);

use IO::Scalar;

use PJVM::Class;

our @ISA = qw(Exporter);

use Object::Tiny qw(
    classpath
);

sub new {
    my ($pkg, $args) = @_;
    
    $args = {} unless ref $args eq "HASH";
    
    my $classpath;
    if ($args->{classpath}) {
        die "argument 'classpath' must be an array reference" unless ref $args->{classpath} eq "ARRAY";
        $classpath = $args->{classpath};
    }
    
    my $self = bless {
        classpath => $classpath,
    }, $pkg;
    
    return $self;
}

sub load_class {
    my ($self, $fqcn) = @_;
    
    my @fqcn = split /\./, $fqcn;
    my $name = pop @fqcn;
    
    # Find the class to load
    my $path;
    for my $cp (@{$self->classpath}) {
        my $pt = File::Spec->catfile($cp, @fqcn, "${name}.class");
        if (-e $pt) {
            $path = $pt;
            last;
        }
    }
    
    die "Can't find '${fqcn}.class' in my classpath" unless $path;
    
    open(my $io, "<:raw", $path) || die $!;
    my $class = $self->read_class($io);
    close($io);
    
    return $class;
}

sub read_class {
    my ($self, $io) = @_;
    return PJVM::Class->new_from_io($io);
}

1;
__END__

=head1 NAME

PJVM::ClassLoader -

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 INTERFACE
