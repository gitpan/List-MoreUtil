use Test::More tests => 13;
BEGIN { use_ok('List::MoreUtil', qw/after after_incl before before_incl/) };

my @x;

# after
@x = after {$_ % 5 == 0} (1..9);    # returns 6, 7, 8, 9
ok eq_array(\@x, [6, 7, 8, 9]), 'after: doc test 1';
@x = after { /foo/ } qw/bar baz/;
ok 0 ==  @x, 'after: empty result';
@x = after { /b/ } qw/bar baz foo/;
ok eq_array(\@x, [ qw/baz foo/ ]), 'after: 2th result';

# after_incl
@x = after_incl {$_ % 5 == 0} (1..9);    # returns 5, 6, 7, 8, 9
ok eq_array(\@x, [5, 6, 7, 8, 9]), 'after_incl: doc test 1';
@x = after_incl { /foo/ } qw/bar baz/;
ok 0 ==  @x, 'after_incl: empty result';
@x = after_incl { /b/ } qw/bar baz foo/;
ok eq_array(\@x, [ qw/bar baz foo/ ]), 'after_incl: inclusive result';

# before
@x = before {$_ % 5 == 0} (1..9);    # returns 1, 2, 3, 4
ok eq_array(\@x, [1, 2, 3, 4]), 'before: doc test 1';
@x = before { /b/ } qw/bar baz/;
ok 0 == @x, 'before: first match';
@x = before { /f/ } qw/bar baz foo/;
ok eq_array(\@x, [  qw/bar baz/ ]), 'before: inclusive result';

# before_incl
@x = before_incl {$_ % 5 == 0} (1..9);    # returns 1, 2, 3, 4, 5
ok eq_array(\@x, [1, 2, 3, 4, 5]), 'before_incl: doc test 1';
@x = before_incl { /foo/ } qw/bar baz/;
ok eq_array(\@x, [ qw/bar baz/ ]), 'before_incl: no match';
@x = before_incl { /f/ } qw/bar baz foo/;
ok eq_array(\@x, [ qw/bar baz foo/ ]), 'before_incl: inclusive result';
