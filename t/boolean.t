use Test::More tests => 7;
BEGIN { use_ok('List::MoreUtil', qw/all any none/) };

my ($x, $y);

# All
$x = all {$_ > 5} (1..10);    # false
ok !$x, 'all: doc example 1';
$y = all {$_ > 5} (10..20);   # true
ok  $y, 'all: doc example 2';

# Any
$x = any {$_ > 5} (1..5);    # false
ok !$x, 'any: doc example 1';
$y = any {$_ > 5} (1..10);   # true
ok  $y, 'any: doc example 2';

# None
$x = none {$_ > 5} (1..5);    # true
ok  $x, 'none: doc example 1';
$y = none {$_ > 5} (1..10);   # false
ok !$y, 'none: doc example 2';

