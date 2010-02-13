package PJVM::Decompiler::Util;

use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

our @EXPORT = qw(to_java_pkg_and_name to_java_fqcn);
our @EXPORT_OK = @EXPORT;

sub to_java_pkg_and_name {
    my $fqcn = pop;
    
    my ($package, $name) = ("", $fqcn);
    if ($fqcn =~ m{^(.*)/([A-Za-z0-9_\$]+)}) {
        $package = to_java_fqcn($1);
        $name = $2;
    }

    return ($package, $name);
}

sub to_java_fqcn {
    my $fqcn = pop;
    return "" unless $fqcn;
    $fqcn =~ s/\//./g;
    return $fqcn;
}
1;