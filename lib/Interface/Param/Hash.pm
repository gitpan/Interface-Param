package Interface::Param::Hash;
use base qw(Interface::Param);

use Data::Dumper;

use strict;
use warnings;

our $VERSION='0.2';

my $Data = {};

sub param_get
{
    my ($self,$field) = (shift,shift);
    my $data = $Data->{$field} ||= {};

    if( @_ == 0 )
    {
        return keys %$data;
    }

    if( @_ == 1 )
    {
        return exists $data->{$_[0]}
                ? $data->{$_[0]}
                : undef;
    }

    my @vals = ();
    foreach my $key ( @_ )
    {
        if( exists $data->{$key} ) 
        {
            push(@vals, $data->{$key});
        }
    }

    return @vals;
}


sub param_set
{
    my ($self,$field,$input) = (@_);
    my $data = $Data->{$field} ||= {};

    %$data = ( %$data, %$input );

    return keys %$input;
}


sub param_del
{
    my ($self,$field) = (shift,shift);
    my $data = $Data->{$field} ||= {};

    if( @_ ) {
        map { delete $data->{$_} } @_;
    } else {
        delete $Data->{$field};
    }
}


1;


__END__

=pod

=head1 NAME

Interface::Param::Hash - A hash-based implementation of the Interface::Param
virtual class methods.

=head1 DESCRIPTION

This method implements the Interface::Param virtual method param() by storing
your key/value data in memory (with a hash).

=head1 SYNOPSIS

 package MyObject;
 use base qw(MyParent Interface::Param::Hash);
 use warnings;
 use strict;

 sub set_defaults
 {
    my $self = shift;
    $self->options( 'sounds' => 0, 'level' => 1, 'volume' => 50 );
 }

 sub print_volume
 {
    my $self = shift;
    print $self->options( 'volume' );
 }

 # create a param method called options 
 sub options
 {
    my $self = shift;
    return $self->param( '__options', @_ );
 }

 1;

=head1 METHODS

=head2 See L<Interface::Param/METHODS>

=head1 AUTHOR

Shaun Guth <l8nite@l8nite.net>

=head1 LICENSE

Copyright (C) 2004 Shaun Guth

This program is free software; you can redistribute it and/or modify
it under the same terms as perl itself.

=cut

