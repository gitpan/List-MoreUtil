use Test::More tests => 15;
BEGIN { use_ok('List::MoreUtil', qw/first_index first_value indexes last_index last_value max maxs min mins/) };

my ($x, @x);

# first_index
$x = first_index {$_ > 5}  (4..9);    # returns 2
is $x, 2, 'first_index: doc 1';
$x = first_index {$_ > 5}  (1..4);    # returns undef
ok !defined $x, 'first_index: doc 2';

# first_value
$x = first_value {$_ > 5}  (4..9);    # returns 6
is $x, 6, 'first_value: doc 1';
$x = first_value {$_ > 5}  (1..4);    # returns undef
ok !defined $x, 'first_value: doc 2';

# indexes
@x = indexes {$_ > 5}  (4..9);    # returns (2, 3, 4, 5)
ok eq_array(\@x, [2..5]), 'indexes: doc 1';
@x = indexes {$_ > 5}  (1..4);    # returns ()
is 0, scalar @x, 'indexes: doc 2';

# last_index
$x = last_index {$_ > 5}  (4..9);    # returns 5
is $x, 5, 'last_index: doc 1';
$x = last_index {$_ > 5}  (1..4);    # returns undef
ok !defined $x, 'last_index: doc 2';

# last_value
$x = last_value {$_ > 5}  (4..9);    # returns 9
is $x, 9, 'last_value: doc 1';
$x = last_value {$_ > 5}  (1..4);    # returns undef
ok !defined $x, 'last_value: doc 1';

# max
$x = max (1, 4, 5, -9);
is $x, 5, 'max';

# maxs
$x = maxs qw/the quick brown fox/;
is $x, 'the', 'maxs';

# min
$x = min (-1, -4, 0, 9);
is $x, -4, 'min';

$x = mins qw/the quick brown fox/;
is $x, 'brown', 'mins';
