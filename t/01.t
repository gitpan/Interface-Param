# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Interface-Param.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 86;

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $tobj = new Tester();

# make sure the test object actually worked
ok( defined($tobj) );

# make sure inheritance worked
isa_ok( $tobj, 'Interface::Param' );

# check documented methods exist
can_ok( $tobj, '_param', '_delete_param', '_clear_param' );

# check empty args (no data yet)
is( $tobj->param(), 0 );

# check invalid key
is( $tobj->param('foo'), undef );

# check setting "" as key and retrieving
$tobj->param("" => 'foo' );
is( $tobj->param(""), 'foo' );


# check setting/poking/retrieving data (poking = get data directly)
{
    my @test_data = (
        0, 1, -1, "", "bar", [1,2,3], {'1'=>1,'a'=>'a'},
        [{'a'=>'b','c'=>'d'},{'e'=>'f','g'=>'h'}]
    );

    # single element tests all-styles (including complex refs ) 
    foreach my $i ( 0 .. $#test_data )
    {
        my $d = $test_data[$i];
        my $cb;

        $tobj->param( ('foo' => $d) ); # hash/list style
        is_deeply( $tobj->{'__params'}->{'foo'}, $d );
        is_deeply( $tobj->param('foo'), $d );

        $tobj->param( {'foo' => $d} ); # hashref style
        is_deeply( $tobj->{'__params'}->{'foo'}, $d );
        is_deeply( $tobj->param('foo'), $d );

        next if $i > 4;

        $tobj->param( [ $d ] ); # arrayref style
        is_deeply( $tobj->{'__params'}->{$d}, $d );
        is_deeply( $tobj->param($d), $d );
    }

    # multiple element tests 
    my @keys = ( "a" .. "z" );
    my %hash;
    my $idx = 0;
    map { $hash{$keys[$idx++]} = $_ } @test_data;

    $tobj->param( %hash ); # hash/list style (hashes are flattened)

    # check results
    foreach my $key ( keys %hash )
    {
        is_deeply( $tobj->{'__params'}->{$key}, $hash{$key} );
        is_deeply( $tobj->param($key), $hash{$key} );
    }

    $tobj->param( \%hash ); #hashref style

    foreach my $key ( keys %hash )
    {
        is_deeply( $tobj->{'__params'}->{$key}, $hash{$key} );
        is_deeply( $tobj->param($key), $hash{$key} );
    }
}


# check clear all params

$tobj->param( 'foo' => 'bar' );
$tobj->_clear_param( '__params' );

is( $tobj->param(), 0 );
is( $tobj->param('foo'), undef );


# check clear individual params
$tobj->param( 'a' => 1, 'b' => 2, 'c' => 3 );
is( $tobj->param(), 3 );
$tobj->_delete_param( '__params', 'a' );
is( $tobj->param(), 2 );
is( $tobj->param('a'), undef );
is( $tobj->param('b'), 2 );




package Tester;
use base qw(Interface::Param);
use strict;
use warnings;

sub new
{
    my $proto = shift;
    my $class = ref($proto) || $proto;
    return bless( {}, $class );
}

sub param
{
    my $self = shift;
    $self->_param( '__params', @_ );
}

1;
