#!/usr/bin/perl

use strict;
use warnings;

use PJVM::ClassLoader;

my $loader = PJVM::ClassLoader->new({classpath => [shift]});

my $class = $loader->load_class(shift);

use Data::Dumper qw(Dumper);
print Dumper($class);