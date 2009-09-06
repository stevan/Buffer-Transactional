#!/usr/bin/perl

use strict;
use warnings;

use Test::More 'no_plan';
use Test::Exception;

use IO::Scalar;

BEGIN {
    use_ok('Buffer::Transactional');
}

my $data = '';
my $b = Buffer::Transactional->new( output => IO::Scalar->new(\$data) );
isa_ok($b, 'Buffer::Transactional');

eval {
    $b->begin_work;
    $b->print('OH HAI');
    is($data, '', '... no data is sent to the handle yet');
    is(${$b->current_buffer->string_ref}, 'OH HAI', '... what we expected in the buffer');
    die "Whoops!\n"
};
if ($@) {
    $b->rollback;
    is($data, '', '... no data was sent to the handle');
}










