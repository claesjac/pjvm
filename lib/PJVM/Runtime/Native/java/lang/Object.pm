package PJVM::Runtime::Native::java::lang::Object;

use strict;
use warnings;

use Scalar::Util qw(refaddr);

use PJVM::Access qw(:flags);
use PJVM::Runtime qw(:stack :signature);
use PJVM::Runtime::Class;

sub new {
    my $class = PJVM::Runtime::Class->new(
        qname => "java/lang/Object",
        methods => {            
            # Constructor
            "()V"                           => \&j_new,

            # protected Object clone()
            "clone()Ljava/lang/Object;"     => \&j_clone,
            
            # boolean equals(Object)
            "equals(Ljava/lang/Object;)Z"   => \&j_equals,
            
            # protected void finalize()
            "finalize()V"                   => \&j_finalize,
            
            # Class getClass()
            "getClass()Ljava/lang/Class;"   => \&j_get_class,
            
            # int hashCode()
            "hashCode()I"                   => \&j_hash_code,
            
            # void notify()
            "notify()V"                     => \&j_notify,

            # void notifyAll()
            "notifyAll()V"                  => \&j_notify_all,
            
            # String toString()
            "toString()Ljava/lang/String;"  => \&j_to_string,
            
            # void wait(), void wait(long), void wait(long, int)
            "wait()V"                       => \&j_wait,
            "wait(J)V"                      => \&j_wait,
            "wait(JI)V"                     => \&j_wait,
        },
        methods_access => {
            "()V"                          => ACC_PUBLIC,
            "clone()Ljava/lang/Object;"    => ACC_PROTECTED,
            "equals(Ljava/lang/Object;)Z"  => ACC_PUBLIC,
            "finalize()V"                  => ACC_PROTECTED,
            "getClass()Ljava/lang/Class;"  => ACC_PUBLIC,            
        },
    );
    
    return $class;
}

sub j_new {
}

# Methods bound to Java space, refere to $self as $this to follow Java conventions
sub j_clone {
    my ($rt, $this) = @_;
    ;
    # TODO: check interface and throw java/lang/CloneNotSupportedException if 
    # not class does not implement java/lang/Cloneable
    # Performs a shallow clone
    my $clone = $this->clone();
    return $clone;
}

sub j_equals {
    my ($rt, $this, $that) = @_;
    return refaddr $this == refaddr $that;
}

sub j_finalize {
}

sub j_get_class {
    my $this = pop;
    return $this->class;
}

sub j_hash_code {
    my $this = pop;
    return refaddr $this;
}

sub j_notify {
    # TODO: needs threads and monitors
    die "NotImplementedYet";
}

sub j_notify_all {
    # TODO: needs threads and monitors
    die "NotImplementedYet";
}

sub j_to_string {
    my $this = pop;
    return "$this";
}

sub j_wait {
    die "NotImplementedYet";
    
    my $signature = rt_signature; # meh, stupid polymorphism
    
    my ($timeout, $nanos);
    ($timeout, $nanos) = (0, 0)                         if $signature eq "wait()V";
    ($timeout, $nanos) = (pop(@_), 0)              if $signature eq "wait(J)V";
    ($timeout, $nanos) = (pop(@_), pop(@_))   if $signature eq "wait(JI)V";
}

1;
__END__

=head1 NAME

PJVM::Runtime::Native::java::lang::Object -

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 INTERFACE
