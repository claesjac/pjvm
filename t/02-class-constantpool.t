#!/usr/bin/perl

use strict;
use warnings;

use File::Spec;
use IO::Scalar;

use Test::More tests => 3;

BEGIN { use_ok("PJVM::Class::ConstantPool"); }

open(my $io, "<:raw", File::Spec->catfile("java", "test1.class")) || die $!;

# Skip header stuff
seek $io, 8, 0;

my $pool = PJVM::Class::ConstantPool->new_from_io($io);
isa_ok($pool, "PJVM::Class::ConstantPool");
is($pool->length, 25);

