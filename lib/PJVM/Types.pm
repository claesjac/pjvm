package PJVM::Types;

use strict;
use warnings;

{
    # These are primitive values and their initial value
    my %Default_value = (
        B   => 0,           # int
        C   => chr(0x0000), # char
        D   => 0.0,         # double
        F   => 0.0,         # float
        I   => 0,           # int
        J   => 0,           # long
        S   => 0,           # short
        Z   => 0,           # boolean
    );
    
    sub default_value_for_signature {
        my $signature = pop;
    
        return $Default_value{$signature};
    }
}

sub extract_references_from_signature {
    my $sig = pop;
    
    my %refs;
    while ($sig =~ /\GL(.*?);/g) {
        $refs{$1} = 1;
    }
    
    return keys %refs;
}
1;
__END__

=head1 NAME

PJVM::Types -

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 INTERFACE
