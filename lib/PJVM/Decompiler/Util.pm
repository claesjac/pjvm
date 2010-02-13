package PJVM::Decompiler::Util;

use strict;
use warnings;

use PJVM::Access qw(:flags);

require Exporter;

our @ISA = qw(Exporter);

our @EXPORT = qw(to_java_pkg_and_name to_java_fqcn to_java_access);
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

sub to_java_access {
    my $flags = shift;
    my %ok = map { lc $_ => lc $_ } @_;

    my $access = "";
    $access .= "public "        if $flags & ACC_PUBLIC;
    $access .= "private "       if $flags & ACC_PRIVATE;
    $access .= "protected "     if $flags & ACC_PROTECTED;
    $access .= "static"         if $flags & ACC_STATIC;
    $access .= "final "         if $flags & ACC_FINAL;
    $access .= "synchronized "  if $flags & ACC_SYNCHRONIZED;
    $access .= "volatile "      if $flags & ACC_VOLATILE;
    $access .= "transient "     if $flags & ACC_TRANSIENT;
    $access .= "native "        if $flags & ACC_NATIVE;
    $access .= "abstract "      if $flags & ACC_ABSTRACT;
    $access .= "strictfp "      if $flags & ACC_STRICT;
    
    if (%ok) {
        $access =~ s/(\w+)/$ok{$1} ? $ok{$1} : ""/ge;
        $access =~ s/\s+/ /g;
    }

    local $/ = " ";
    chomp $access;

    return $access;
}

1;