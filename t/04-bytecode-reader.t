#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 5;

BEGIN { use_ok("PJVM::Bytecode::Reader"); }

use PJVM::ClassLoader;

my $loader = PJVM::ClassLoader->new({classpath => [qw(java)]});
my $class = $loader->load_class("test1");

my $method = $class->method(calc => "()I");
isa_ok($method, "PJVM::Class::Method");
is($method->name, "calc");
is($method->signature, "()I");
use Data::Dumper qw(Dumper);

my $code = $method->bytecode;

my $ops = PJVM::Bytecode::Reader->read($code);

is_deeply($ops, [[16,41],undef,[172]]);