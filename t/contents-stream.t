use v6;
use Test;
use PDF::DOM::Contents::Stream;
plan 3;

my $gfx = PDF::DOM::Contents::Stream.new;

lives-ok {$gfx.ops.push: ('Tj' => [ :literal('Hello, world!') ])}, 'push raw content';
$gfx.save( :prepend );
$gfx.restore;
is-deeply $gfx.ops, [
    'q',
    :Tj[ :literal('Hello, world!') ],
    'Q',
    ], 'content ops';

my $content = $gfx.content;

is-deeply [$content.lines], ['q', '(Hello, world!) Tj', 'Q'], 'rendered content';

