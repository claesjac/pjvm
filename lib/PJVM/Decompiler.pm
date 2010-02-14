package PJVM::Decompiler;

use strict;
use warnings;

use PJVM::Decompiler::ToText;

use Object::Tiny qw(output_class);

sub new {
    my ($class, $args) = @_;
    
    $args = {} unless ref $args eq "HASH";
    
    my $self = bless {
        output_class => "PJVM::Decompiler::ToText",
    }, $class;

    return $self;
}

sub decompile {
    my ($self, $class) = @_;
    
    my $output = $self->output_class->new();
    
    $output->do_package_decl($class);
    $output->do_imports($class);
        
    $output->do_class_open($class);

    $output->do_field($class, $_) for @{$class->fields};
    $output->do_fields_done() if @{$class->fields};

    # Output in asciibetical sort order
    my @methods = sort {
        $a->name cmp $b->name
    } @{$class->methods};
    $output->do_method($class, $_) for @methods;
    
    $output->do_methods_done() if @{$class->methods};
    
    $output->do_class_close($class);
    
    print $output->results, "\n";
}

1;