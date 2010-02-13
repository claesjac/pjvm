package PJVM::Runtime::Native::java::lang::Cloneable;

use strict;
use warnings;

use PJVM::Runtime::Class;

sub new {
    my $class = PJVM::Runtime::Class->new(
        qname => "java/lang/Cloneable",
        is_interface => 1,
    );
    
    return $class;
}

1;
__END__

=head1 NAME

PJVM::Runtime::Native::java::lang::Class -

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 INTERFACE
