#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 2;

use Scalar::Util qw(refaddr);

use PJVM::Runtime;

my $rt = PJVM::Runtime->new({classpath => [qw(java)]});

my $object = $rt->instantiate($rt->find_class("java/lang/Object"));
ok(defined $object);

my $hash_code = $rt->call("hashCode()I" => $object);
is($hash_code, refaddr $object);