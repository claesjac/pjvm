#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 25;
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
is (scalar @$fields, 5);
my @fields = sort { $a->name cmp $b->name } @$fields;
my $field = shift @fields;
is($field->name, "bar");
is($field->signature, "Lfoo/bar/quax;");
$field = shift @fields;
is($field->name, "field1");
is($field->signature, "I");
$field = shift @fields;
is($field->name, "field2");
is($field->signature, "Ljava/lang/Object;");
$field = shift @fields;
is($field->name, "field3");
is($field->signature, "[Ljava/lang/Object;");
$field = shift @fields;
is($field->name, "static_field1");
is($field->signature, "I");

# Methods
my $methods = $class->methods;
is (scalar @$methods, 5);
my @methods = sort { $a->name cmp $b->name } @$methods;

my $method = shift @methods;
is($method->name, "<clinit>");
is($method->signature, "()V");

$method = shift @methods;
is($method->name, "<init>");
is($method->signature, "()V");

$method = shift @methods;
is($method->name, "calc");
is($method->signature, "()I");

$method = shift @methods;
is($method->name, "decodeException");
is($method->signature, "(LFooException;)V");


$method = shift @methods;
is($method->name, "main");
is($method->signature, "([Ljava/lang/String;)V");
