package PJVM::Class::ConstantPool;

use strict;
use warnings;

use PJVM::Class::ConstantPool::Types;

use constant {
    CONSTANT_Class              => 7,
    CONSTANT_Fieldref           => 9,
    CONSTANT_Methodref          => 10,
    CONSTANT_InterfaceMethodref => 11,
    CONSTANT_String             => 8,
    CONSTANT_Integer            => 3,
    CONSTANT_Float              => 4,
    CONSTANT_Long               => 5,
    CONSTANT_Double             => 6,
    CONSTANT_NameAndType        => 12,
    CONSTANT_Utf8               => 1,
};

{
    # Don't use fat comma (=>) here because we want to key to refer to a constant
    my %constant_readers = (
        CONSTANT_Class,                 "PJVM::Class::ConstantPool::Class",
        CONSTANT_Fieldref,              "PJVM::Class::ConstantPool::FieldRef",
        CONSTANT_Methodref,             "PJVM::Class::ConstantPool::MethodRef",
        CONSTANT_InterfaceMethodref,    "PJVM::Class::ConstantPool::InterfaceMethodRef",
        CONSTANT_String,                "PJVM::Class::ConstantPool::String",
        CONSTANT_Integer,               "PJVM::Class::ConstantPool::Integer",
        CONSTANT_Float,                 "PJVM::Class::ConstantPool::Float",
        CONSTANT_Long,                  "PJVM::Class::ConstantPool::Long",
        CONSTANT_Double,                "PJVM::Class::ConstantPool::Double",
        CONSTANT_NameAndType,           "PJVM::Class::ConstantPool::NameAndType",
        CONSTANT_Utf8,                  "PJVM::Class::ConstantPool::Utf8",
    );

    sub new_from_io {
        my ($pkg, $io) = @_;
    
        my $buff;
        read $io, $buff, 2;
        my $count = unpack("n", $buff) - 1;

        my $constants = [];
        if ($count) {
            my $ix = 1;
            my $tag;
            while ($count--) {
                read $io, $buff, 1;        
                my $tag = unpack("C", $buff);
                die "Don't know how to read tag '${tag}'" unless exists $constant_readers{$tag};
            
                my $constant = $constant_readers{$tag}->new_from_io($tag, $io);
                $constants->[$ix++] = $constant;
                if ($constant->isa("PJVM::Class::ConstantPool::Extended")) {
                    $constants->[$ix++] = $constant;
                    $count--;
                }
            }
        }
        
        my $self = bless $constants, $pkg;
        return $self;
    }
}

sub length {
    my $self = shift;
    my $length = scalar @$self;
    return $length ? $length - 1 : 0;
}

sub get {
    my ($self, $ix) = @_;
    return $self->[$ix];
}

1;
__END__

=head1 NAME

PJVM::Class::ConstantPool -

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 INTERFACE
