# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Interface-Param.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 52;

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $tobj = new Tester();

# make sure the test object actually worked
ok( defined($tobj) );

# make sure inheritance worked
isa_ok( $tobj, 'Interface::Param' );

# check documented methods exist
can_ok( $tobj, 'param', 'param_get', 'param_set', 'param_del' );

# check empty args (no data yet)
is( $tobj->param(), 0 );

# check invalid key
is( $tobj->param('foo'), undef );

# check setting "" as key and retrieving
$tobj->param("" => 'foo' );
is( $tobj->param(""), 'foo' );


# check param_get and param_set 
{
    my @test_data = (
        0, 1, -1, "", "bar", [1,2,3], {'1'=>1,'a'=>'a'},
        [{'a'=>'b','c'=>'d'},{'e'=>'f','g'=>'h'}]
    );

    # single element tests
    foreach my $i ( 0 .. $#test_data )
    {
        my $d = $test_data[$i];
        my $cb;

        $tobj->param( ('foo' => $d) ); # hash/list style
        is_deeply( $tobj->param('foo'), $d );

        $tobj->param( {'foo' => $d} ); # hashref style
        is_deeply( $tobj->param('foo'), $d );

        next if $i > 4;

        $tobj->param( [ $d ] ); # arrayref style
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
        is_deeply( $tobj->param($key), $hash{$key} );
    }

    $tobj->param( \%hash ); #hashref style

    foreach my $key ( keys %hash )
    {
        is_deeply( $tobj->param($key), $hash{$key} );
    }
}

# check param_del deletes all data
$tobj->param( 'b' => 2, 'c' => 3 );
$tobj->param_del();
is( $tobj->param(), 0 );

# check other get/set/deletes with this data
$tobj->param( 'a' => 1, 'b' => 2, 'c' => 3 );

# check param_get returns multiple values in the right order
my @vals = $tobj->param_get( '__params', 'b', 'a', 'b', 'foo' );
is_deeply( \@vals, [2,1,2] );

# check param_get returns all keys when called with no arguments
is( $tobj->param(), 3 );

# check param_del deletes single elements
$tobj->param_del( 'c' );
is( $tobj->param(), 2 );
is( $tobj->param( 'c' ), undef );
$tobj->param( 'c' => 3 );

# check param_del deletes multiple elements
$tobj->param_del( 'c', 'b' );
is( $tobj->param(), 1 );
is( $tobj->param_get( '__params', 'b', 'c' ), 0 );
is( $tobj->param( 'b' ), undef );
is( $tobj->param( 'c' ), undef );



package Tester;
use base qw(Interface::Param::Hash);
use strict;
use warnings;

sub new
{
    my $proto = shift;
    my $class = ref($proto) || $proto;
    return bless( {}, $class );
}

# just wrap these calls to make it easier above
sub param     { (shift)->SUPER::param    ( '__params', @_ ) }
sub param_del { (shift)->SUPER::param_del( '__params', @_ ) }

1;

