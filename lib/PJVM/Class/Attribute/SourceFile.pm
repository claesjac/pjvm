package PJVM::Class::Attribute::SourceFile;

use strict;
use warnings;

use Object::Tiny qw(
    sourcefile_index
);

sub new_from_io {
    my ($pkg, $io, $cp) = @_;
    
    my $buff;
    
    read $io, $buff, 2;
    my $sourcefile_index = unpack("n", $buff);
        
    my $self = $pkg->new(
        sourcefile_index => $sourcefile_index,
    );
    
    return $self;
}

1;
__END__

=head1 NAME

PJVM::Class::Attribute::SourceFile -

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 INTERFACE
