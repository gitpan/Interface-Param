package Interface::Param;

use strict;
use warnings;

our $VERSION='0.2';

sub param 
{
    my ($self,$field) = (shift,shift);
    my $data = {};

    if( scalar(@_) ) {
        if( (@_ == 1) && !(ref($_[0])) ) {
            return $self->param_get( $field, $_[0] );
        }
                   # merge a hashref
        my %temp = ref($_[0]) eq 'HASH'  ? %{$_[0]} :
                   # merge an arrayref
                   ref($_[0]) eq 'ARRAY' ? map{$_=>$_} @{$_[0]} :
                   # otherwise, merge list
                   (@_);

        return $self->param_set( $field, \%temp );
    }

    return $self->param_get( $field );
}

sub param_set { die "Virtual method " . __PACKAGE__ . "::param_set() not implemented"; }
sub param_get { die "Virtual method " . __PACKAGE__ . "::param_get() not implemented"; }
sub param_del { die "Virtual method " . __PACKAGE__ . "::param_del() not implemented"; }


1;


__END__
=head1 NAME

Interface::Param - Virtual class for param() method

=head1 DESCRIPTION

This virtual class allows you to specify that your object implements a param()
method which allows storing and retrieving data quickly through an interface
that is similar to CGI.pm's param() method.  It enforces the calling
convention of the param() method, but it does not attempt to impose any type
of storage system for the key/value pairs.

=head1 SYNOPSIS

See L<Interface::Param::Hash> for a useful subclass that implements the
virtual methods of this interface.

=head1 METHODS

=over

=item param ( 'field', key || (list || hash || hashref || arrayref) )

This is the core of the Interface::Param package.

=over

=item 'field'

A name to store the data under

=item 'key || (list || hash || hashref || arrayref)'

If no arguments are given, param_get() will be called with no arguments.

If a single scalar argument is passed that isn't a reference, param_get() will
be called with the argument and field name sent.

If multiple arguments are given, or a single argument that is a reference, the
data will be unwrapped and merged into a hash using conventional means (ie, a
hashref will be dereferenced, and a list will be slurped as
(key1,value1,...,keyN,valueN); however, array references are treated as a
special case.  They are mapped with each element being both the key and the
value.

=back

=back

=head1 VIRTUAL METHODS

=over

=item param_get ( $field, [@keys] )

If called with no arguments, the typical response is to return a list of all
keys.  If called with one or more arguments, the values corresponding to those keys
are returned.

=item param_set ( $field, \%data )

Should stores the data received from the input hash.  Returns the keys set.

=item param_del ( $field, [@keys] )

If called with no arguments, delete all data stored for $field.  If called
with one or more arguments, delete the values stored for those particular
keys.

=back

=head1 AUTHOR

Shaun Guth <l8nite@l8nite.net>

=head1 LICENSE

Copyright (C) 2004 Shaun Guth

This program is free software; you can redistribute it and/or modify
it under the same terms as perl itself.

=cut

