package PJVM::Class::Attribute;

use strict;
use warnings;

use PJVM::Class::Attribute::Code;
use PJVM::Class::Attribute::ConstantValue;
use PJVM::Class::Attribute::Exceptions;
use PJVM::Class::Attribute::InnerClasses;
use PJVM::Class::Attribute::LineNumberTable;
use PJVM::Class::Attribute::Synthetic;
use PJVM::Class::Attribute::SourceFile;
use PJVM::Class::Attribute::LocalVariableTable;
use PJVM::Class::Attribute::Deprecated;

{
    my %attribute_class = (
        Code                => "PJVM::Class::Attribute::Code",
        ConstantValue       => "PJVM::Class::Attribute::ConstantValue",
        Exceptions          => "PJVM::Class::Attribute::Exceptions",
        InnerClasses        => "PJVM::Class::Attribute::InnerClasses",
        LineNumberTable     => "PJVM::Class::Attribute::LineNumberTable",
        Synthetic           => "PJVM::Class::Attribute::Synthetic",
        SourceFile          => "PJVM::Class::Attribute::SourceFile",
        LocalVariableTable  => "PJVM::Class::Attribute::LocalVariableTable",
        Deprecated          => "PJVM::Class::Attribute::Deprecated",
    );
    
    sub new_from_io {
        my ($pkg, $io, $cp) = @_;
    
        my $buff;
    
        read $io, $buff, 2;
        my $type_ix = unpack("n", $buff);
        my $type = $cp->get($type_ix)->value;

        read $io, $buff, 4;
        my $length = unpack("N", $buff);
    
        if (exists $attribute_class{$type}) {
            return $attribute_class{$type}->new_from_io($io, $cp);
        }
        else {
            warn "Couldn't find attribute handler for '${type}'";
        }

        read $io, $buff, $length;
        
        # Return nothing
        return ();
    }
}

1;
__END__

=head1 NAME

PJVM::Class::Attribute -

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 INTERFACE
