use Test::More tests => 3;
BEGIN { use_ok('List::MoreUtil', qw/each_array natatime/) };

# each_array
my @a = (7, 3, 'a', undef, 'r');
my @b = ('a', 2, -1, 'x');

my $it = each_array @a, @b;
my @r;
while (my ($a, $b) = $it->())
{
    push @r, $a, $b;
}

ok eq_array(\@r, [7, 'a', 3, 2, 'a', -1, undef, 'x', 'r', undef]), 'each_array';


# natatime
my @x = ('a'..'g');
$it = natatime 3, @x;
@r = ();
while (my @vals = $it->())
{
    push @r, "@vals";
}

ok eq_array(\@r, ['a b c', 'd e f', 'g']), 'natatime: doc';
