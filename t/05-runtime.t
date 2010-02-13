#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 5;
use Test::Exception;

BEGIN { use_ok("PJVM::Runtime"); }

my $rt = PJVM::Runtime->new({classpath => [qw(java)]});
isa_ok($rt, "PJVM::Runtime");
is_deeply($rt->classpath, ["java"]);

dies_ok {
    my $class = $rt->get_class("test2");
};

my $class = $rt->load_class("test2");
ok(defined $class);