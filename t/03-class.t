#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 17;
use Test::Exception;

use PJVM::ClassLoader;

my $loader = PJVM::ClassLoader->new({classpath => [qw(java)]});
my $class = $loader->load_class("test1");

# Basic stuff
is($class->name, "test1");
is($class->super, "java/lang/Object");
is_deeply([$class->interfaces], ["java/lang/Cloneable"]);

# Fields
my $fields = $class->fields;
is (scalar @$fields, 3);
my @fields = sort { $a->signature cmp $b->signature } @$fields;
my $field = shift @fields;
is($field->name, "static_field1");
is($field->signature, "I");
$field = shift @fields;
is($field->name, "field1");
is($field->signature, "I");
$field = shift @fields;
is($field->name, "field2");
is($field->signature, "Ljava/lang/Object;");

# Methods
my $methods = $class->methods;
is (scalar @$methods, 3);
my @methods = sort { $a->signature cmp $b->signature } @$methods;

my $method = shift @methods;
is($method->name, "calc");
is($method->signature, "()I");

$method = shift @methods;
is($method->name, "<init>");
is($method->signature, "()V");

$method = shift @methods;
is($method->name, "main");
is($method->signature, "([Ljava/lang/String;)V");
