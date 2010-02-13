#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 3;

BEGIN { use_ok("PJVM::Runtime::Object"); }

use PJVM::Runtime;

my $rt = PJVM::Runtime->new({classpath => [qw(java)]});
my $class = $rt->load_class("test1");

my $instance = PJVM::Runtime::Object->new($class);
ok(defined $instance);
is($instance->class, $rt->get_class("test1"));