package Interface::Param;

use 5.006;
use strict;
use warnings;

our $VERSION='0.1';

sub _param
{
    my ($self,$field) = (shift,shift);
    my $data = $self->{$field} ||= {};

    if( scalar(@_) ) {
        if( (@_ == 1) && !(ref($_[0])) ) {
            return exists $data->{$_[0]} ? $data->{$_[0]} : undef;
        }
                   # merge a hashref
        my %temp = ref($_[0]) eq 'HASH'  ? %{$_[0]} :
                   # merge an arrayref
                   ref($_[0]) eq 'ARRAY' ? map{$_=>$_} @{$_[0]} :
                   # otherwise, merge list
                   (@_);
        %$data = ( %$data, %temp );
    }

    return keys %$data;
}


sub _delete_param
{
    my ($self,$field) = (shift,shift);
    my $data = $self->{$field} ||= {};

    map { delete $data->{$_} } @_;
}


sub _clear_param
{
    my ($self,$field) = @_;
    delete $self->{$field};
}


1;


__END__
=head1 NAME

Interface::Param - Plug-n-play param()-style methods

=head1 DESCRIPTION

This abstract class allows you to quickly and easily add a method to your 
objects which stores key/value pairs and allows you to retrieve them.  The 
functionality is not unlike the param() method from CGI.pm (which you're
probably familiar with).

=head1 SYNOPSIS

 package MyObject;
 use base qw(MyParent Interface::Param);
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
    return $self->_param( '__options', @_ );
 }

 1;

=head1 METHODS

=over

=item _param

This is the core of the Interface::Param package.  You simply pass this method
a name to store the data under, and then the arguments your custom param method
received, and it will do the rest.  Accepts input to store as a list, hashref, 
or hash.  It also accepts input as an arrayref which is handled differently.
Each element of the arrayref is set as the key and value.
If passed one key, will return value of that key.  If passed no arguments,
will return all keys currently stored.

=item _delete_param

Takes a name of your data store and a field and deletes it from the stored data

=item _clear_param

Takes a name of your data store and clears all elements of it.

=back

=head1 CREDITS

I'm pretty sure I borrowed this routine (if not the code, then the idea) from
another module on CPAN, but I can't for the life of me remember which one.
If anybody ever reads this and recognizes it let me know so I can give the
author credit.

=head1 AUTHOR

Shaun Guth <l8nite@l8nite.net>

=head1 LICENSE

Copyright (C) 2004 Shaun Guth

This program is free software; you can redistribute it and/or modify
it under the same terms as perl itself.

=cut

