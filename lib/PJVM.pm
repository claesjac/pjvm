package PJVM;

use 5.008001;
use strict;
use warnings;

our $VERSION = "0.01_03";

1;
__END__

=head1 NAME

PJVM - Java virtual machine written in Perl

=head1 SYNOPSIS

  use PJVM;
  
  my $rt = PVJM::Runtime->new({classpath => [qw(.)]});
  my $class = $rt->init_class("MyApp");
  $class->main(@ARGV);

=head1 DESCRIPTION

PJVM is a Java Virtual Machine written in Perl. It will proably be dog-slow and is just an experiment. Currently it 
is just able to load classes but not execute them which is being worked on.

The plan is to implement multiple bytecode backend execution engines, such as:

=over 4 

=item *

Simple switching runloop

=item *

One that can transform Java bytecode to perl optrees directly

=item *

Transform bytecode -> Perl source and eval

=item *

Fast JIT:ing backend written in XS

=back

The execution during the lifetime of the app should not be limited to one execution engine and 
each class/method might end up being executed by different backend depending on a criteria such as 
maybe annotating the Java method with a PVJMExecutionEngine attribute or something.

Please do not report any bugs since this module is very experimental.

=head1 BUGS AND LIMITATIONS

* Disregard from this currently please *

Please report any bugs or feature requests to C<bug-pjvm@rt.cpan.org>, 
or through the web interface at L<http://rt.cpan.org>.

=head1 AUTHOR

Claes Jakobsson, Versed Solutions C<< <claesjac@cpan.org> >>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2008, Versed Solutions C<< <info@versed.se> >>. All rights reserved.

This software is released under the MIT license cited below.

=head2 The "MIT" License

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.

=cut
