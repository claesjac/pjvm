#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 10;

BEGIN { use_ok("PJVM::Runtime::Class"); }

use PJVM::Runtime;

my $rt = PJVM::Runtime->new({classpath => [qw(java)]});
isa_ok($rt, "PJVM::Runtime");
is_deeply($rt->classpath, ["java"]);

my $class = $rt->find_class("test1");
ok(defined $class);

is($class->qname, "test1");
ok(exists $class->methods->{"calc()I"});
ok(exists $class->methods->{"<init>()V"});
ok(exists $class->methods->{"main([Ljava/lang/String;)V"});

# static fields
is(scalar keys %{$class->static_fields}, 1);
ok(exists $class->fields->{static_field1});
