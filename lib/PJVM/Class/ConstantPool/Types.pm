use strict;
use warnings;

package PJVM::Class::ConstantPool::Base;

use Object::Tiny qw(
    tag
);

sub new_from_io {
    my $pkg = shift;
    die "$pkg does not implement new_from_io";
}

package PJVM::Class::ConstantPool::Extended;
our @ISA = qw(PJVM::Class::ConstantPool::Base);

package PJVM::Class::ConstantPool::Class;
our @ISA = qw(PJVM::Class::ConstantPool::Base);

use Object::Tiny qw(
    name_index
);

sub new_from_io {
    my ($pkg, $tag, $io) = @_;
    
    my $buff;
    read $io, $buff, 2;
    my ($name_index) = unpack("n", $buff);
    
    my $self = $pkg->new(
        tag         => $tag,
        name_index  => $name_index,
    );
    
    return $self;
}

package PJVM::Class::ConstantPool::Long;
our @ISA = qw(PJVM::Class::ConstantPool::Extended);

use Object::Tiny qw(
    value
);

sub new_from_io {
    my ($pkg, $tag, $io) = @_;
    
    my $buff;
    read $io, $buff, 8;
    my ($high, $low) = unpack("NN", $buff);
    
    my $value = ($high * (2**32)) + $low;
    
    my $self = $pkg->new(
        tag     => $tag,
        value   => $value,
    );
    
    return $self;
}

package PJVM::Class::ConstantPool::Ref;
our @isa = qw(PJVM::Class::ConstantPool::Base);

use Object::Tiny qw(
    tag
    class_index
    name_and_type_index
);

sub new_from_io {
    my ($pkg, $tag, $io) = @_;
    
    my $buff;
    read $io, $buff, 4;
    my ($class_index, $name_and_type_index) = unpack("nn", $buff);

    my $self = $pkg->new(
        tag                 => $tag,
        class_index         => $class_index,
        name_and_type_index => $name_and_type_index,
    );
    
    return $self;
}

package PJVM::Class::ConstantPool::FieldRef;
our @ISA = qw(PJVM::Class::ConstantPool::Ref);

package PJVM::Class::ConstantPool::MethodRef;
our @ISA = qw(PJVM::Class::ConstantPool::Ref);

package PJVM::Class::ConstantPool::InterfaceMethodRef;
our @ISA = qw(PJVM::Class::ConstantPool::Ref);

package PJVM::Class::ConstantPool::NameAndType;
our @ISA = qw(PJVM::Class::ConstantPool::Base);

use Object::Tiny qw(
    name_index
    descriptor_index
);

sub new_from_io {
    my ($pkg, $tag, $io) = @_;
    
    my $buff;
    read $io, $buff, 4;
    my ($name_index, $descriptor_index) = unpack("nn", $buff);

    my $self = $pkg->new(
        tag                 => $tag,
        name_index          => $name_index,
        descriptor_index    => $descriptor_index,
    );
    
    return $self;    
}

package PJVM::Class::ConstantPool::String;
our @ISA = qw(PJVM::Class::ConstantPool::Base);

use Object::Tiny qw(
    string_index
);

sub new_from_io {
    my ($pkg, $tag, $io) = @_;
    
    my $buff;
    read $io, $buff, 2;
    my ($string_index) = unpack("n", $buff);

    my $self = $pkg->new(
        tag             => $tag,
        string_index    => $string_index,
    );
    
    return $self;    
}

package PJVM::Class::ConstantPool::Utf8;
our @ISA = qw(PJVM::Class::ConstantPool::Base);

use Object::Tiny qw(
    value
);

sub new_from_io {
    my ($pkg, $tag, $io) = @_;
    
    my $buff;
    read $io, $buff, 2;
    my ($length) = unpack("n", $buff);
    
    read $io, $buff, $length;
    my $str = $buff; 
    utf8::upgrade($str);
    
    my $self = $pkg->new(
        tag     => $tag,
        value   => $str,
    );
        
    return $self;
}

1;
__END__
