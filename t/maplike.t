use Test::More tests => 5;
BEGIN { use_ok('List::MoreUtil', qw/mesh pairwise/) };

# mesh
my (@x, @y, @z, @a, @b, @c, @d);

@x = qw/a b c d/;
@y = qw/1 2 3 4/;
@z = mesh @x, @y;
ok eq_array(\@z, ['a', 1, 'b', 2, 'c', 3, 'd', 4]), 'mesh: doc 1';

@a = ('x');
@b = ('1', '2');
@c = qw/zip zap zot/;
@d = mesh @a, @b, @c;
ok eq_array(\@d, ['x', 1, 'zip', undef, 2, 'zap', undef, undef, 'zot']), 'mesh: doc 2';

# pairwise
@a = (1, 2, 3);
@b = (2, 4, 6);
@c = pairwise {$a + $b} @a, @b;
ok eq_array(\@c, [3, 6, 9]), 'pairwise: doc 1';

@d = pairwise {$a * $b} @a, @b;   # returns (2, 8, 18)
ok eq_array(\@d, [2, 8, 18]), 'pairwise: doc 2';
