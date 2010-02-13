package PJVM::Runtime::Native::java::lang::System;

use strict;
use warnings;

use Scalar::Util qw(refaddr);

use PJVM::Access qw(:flags);
use PJVM::Runtime qw(:stack :signature);
use PJVM::Runtime::Class;

sub new {
    my $class = PJVM::Runtime::Class->new(
        qname => "java/lang/System",
        fields => {
            "err"   => "Ljava/io/PrintStream;",
            "out"   => "Ljava/io/PrintStream;",
            "in"    => "Ljava/io/PrintStream;",
        },
        fields_access => {
            "err"   => ACC_PUBLIC | ACC_STATIC,
            "in"    => ACC_PUBLIC | ACC_STATIC,
            "out"   => ACC_PUBLIC | ACC_STATIC,
        },
        methods => {            
            # Constructor
            "()V"                           => \&j_new,

            # public static long currentTimeMillis()
            "currentTimeMillis()J"          => \&j_get_current_time_millis,          
            
            # public void exit(int)
            "exit(I)V"                      => \&j_exit,
            
            # public void gc()
            "gc()V"                         => sub {},
            
            # String getenv(java/lang/String)
            "getenv(Ljava/lang/String;)Ljava/Lang/String;" => \&j_getenv,
            
        },
        methods_access => {
            "()V"                                           => ACC_PRIVATE,
            "getCurrentTimeMillis()J"                       => ACC_PUBLIC | ACC_STATIC,
            "exit(I)V"                                      => ACC_PUBLIC | ACC_STATIC,
            "gc()V"                                         => ACC_PUBLIC | ACC_STATIC,
            "getenv(Ljava/lang/String;)Ljava/Lang/String;"  => ACC_PUBLIC | ACC_STATIC,
        },
    );    
    
    return $class;
}

sub j_new {
    die "EPIC FAIL";
}

{
    use Time::HiRes qw(time);
    sub j_current_time_millis {
        return int(time * 1000);
    }
}

sub j_exit {
    my $code = pop;
    exit $code;
}

sub j_getenv {
    my $string = pop;
    my $env = $ENV{$string->value};
    return PJVM::Runtime::String->new($env);
}

1;
__END__

=head1 NAME

PJVM::Runtime::Native::java::lang::Object -

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 INTERFACE
