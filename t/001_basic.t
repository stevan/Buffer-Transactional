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

my $b = Buffer::Transactional->new( out => IO::Scalar->new(\$data) );
isa_ok($b, 'Buffer::Transactional');

$b->begin_work;

$b->print('Greetings');
is($data, '', '... no data is sent to the handle yet');
is($b->current_buffer->as_string, 'Greetings', '... what we expected in the buffer');

my $world = 'World';
$b->printf('Hello %s', $world);
is($data, '', '... no data is sent to the handle yet');
is($b->current_buffer->as_string, 'GreetingsHello World', '... what we expected in the buffer');

$b->say('Goodbye');
is($data, '', '... no data is sent to the handle yet');
is($b->current_buffer->as_string, "GreetingsHello WorldGoodbye\n", '... what we expected in the buffer');

$b->commit;

is($data, "GreetingsHello WorldGoodbye\n", '... now data is sent to the handle');










