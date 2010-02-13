package PJVM::Access;

use strict;
use warnings;

our @ISA = qw(Exporter);

our @EXPORT;
our @EXPORT_OK = qw(
    ACC_PUBLIC
    ACC_PRIVATE
    ACC_PROTECTED
    ACC_STATIC
    ACC_FINAL
    ACC_SUPER
    ACC_SYNCHRONIZED
    ACC_VOLATILE
    ACC_TRANSIENT
    ACC_NATIVE
    ACC_INTERFACE
    ACC_ABSTRACT
    ACC_STRICT
);

our %EXPORT_TAGS = (
    flags => [qw(
        ACC_PUBLIC
        ACC_PRIVATE
        ACC_PROTECTED
        ACC_STATIC
        ACC_FINAL
        ACC_SUPER
        ACC_SYNCHRONIZED
        ACC_VOLATILE
        ACC_TRANSIENT
        ACC_NATIVE
        ACC_INTERFACE
        ACC_ABSTRACT
        ACC_STRICT
    )],
);

use constant {
    ACC_PUBLIC          => 0x0001, # Declared public; may be accessed from outside its package.
    ACC_PRIVATE         => 0x0002, # Declared private; usable only within the defining class.
    ACC_PROTECTED       => 0x0004, # Declared protected; may be accessed within subclasses.
    ACC_STATIC          => 0x0008, # Declared static.
    ACC_FINAL           => 0x0010, # Declared final; no subclasses allowed.
    ACC_SUPER           => 0x0020, # Treat superclass methods specially when invoked by the invokespecial instruction.
    ACC_SYNCHRONIZED    => 0x0020, # Declared synchronized; invocation is wrapped in a monitor lock
    ACC_VOLATILE        => 0x0040, # Declared volatile; cannot be cached.
    ACC_TRANSIENT       => 0x0080, # Declared transient; not written or read by a persistent object manager.
    ACC_NATIVE          => 0x0100, # Declared native; implemented in a language other than Java.
    ACC_INTERFACE       => 0x0200, # Is an interface, not a class.
    ACC_ABSTRACT        => 0x0400, # Declared abstract; may not be instantiated.    
    ACC_STRICT          => 0x0800, # Declared strictfp; floating-point mode is FP-strict
};

1;
__END__

=head1 NAME

PJVM::Access - Access flags and control

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 INTERFACE

=head2 CONSTANTS

=over 4

=item ACC_PUBLIC

May be accessed from outside its package.

=item ACC_PRIVATE

Usable only within the defining class.

=item ACC_PROTECTED

May be accessed within subclasses.

=item ACC_STATIC

Shared between instances of the class.

=item ACC_FINAL

No subclassing allowed or constant.

=item ACC_SUPER

Treat superclass methods specially when invoked by the invokespecial instruction.

=item ACC_SYNCHRONIZED

Invocation is wrapped in a monitor lock

=item ACC_VOLATILE

Cannot be cached.

=item ACC_TRANSIENT

Not written or read by a persistent object manager.

=item ACC_NATIVE

Implemented in a language other than Java.

=item ACC_INTERFACE

Is an interface, not a class.

=item ACC_ABSTRACT

May not be instantiated.    

=item ACC_STRICT

Floating-point mode is FP-strict

=back

=head1 EXPORTS

None by default. Symbols may be requested by name or by using the following tags:

=over 4

=item flags

Export all ACC_* constants.

=back

=cut