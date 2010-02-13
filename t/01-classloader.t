#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 7;
use Test::Exception;

BEGIN { use_ok("PJVM::ClassLoader"); }

throws_ok {
    PJVM::ClassLoader->new({classpath => "."});
} qr/argument 'classpath' must be an array reference/;

my $loader = PJVM::ClassLoader->new({classpath => [qw(java)]});
isa_ok($loader, "PJVM::ClassLoader");
is_deeply($loader->classpath, ["java"]);

throws_ok {
    $loader->load_class("NoSuchClass");
} qr/Can't find 'NoSuchClass.class' in my classpath/;

my $class;
lives_ok {
    $class = $loader->load_class("test1");
};

isa_ok($class, "PJVM::Class");