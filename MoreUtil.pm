=for gpg
-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

=head1 NAME

List::MoreUtil - More list utility functions.

=head1 VERSION

This documentation describes version 0.01 of List::MoreUtil, October 11, 2004.

=cut

use strict;
package List::MoreUtil;

require Exporter;
use AutoLoader qw(AUTOLOAD);
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS @A @B);
@ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration: use List::MoreUtil ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
%EXPORT_TAGS = ( 'all' => [ qw(
        after
        after_incl
        all
        any
        before
        before_incl
        each_array
        each_arrayref
        first_index
        first_value
        indexes
        last_index
        last_value
        max
        maxs
        mesh
        min
        mins
        natatime
        none
        pairwise
) ] );

@EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
@EXPORT = qw();

$VERSION = '0.01';    # Also change in the documentation, above!


# Preloaded methods go here.

# Autoload methods go after =cut, and are processed by the autosplit program.

'This module returns a true value, so there!';
__END__

=head1 SYNOPSIS

 # Boolean test functions
 $bool = all  {code}  @list    # True if <code> is true for all <@list>
 $bool = any  {code}  @list    # True if <code> is true for any <@list>
 $bool = none {code}  @list    # True if <code> is false for all <@list>

 # Grep-like functions
 @list = after       {code} @list   # Values of <@list> after where {code} is true
 @list = after_incl  {code} @list   # Values of <@list> after (and including) where {code} is true
 @list = before      {code} @list   # Values of <@list> before where {code} is true
 @list = before_incl {code} @list   # Values of <@list> before (and including) where {code} is true

 # Map-like functions
 @list = mesh @array, ...           # Merge several arrays together
 @list = pairwise {code} @a, @b     # Apply a function to two arrays

 # Selection functions
 $num = first_index {code} @list    # First index into <@list> where {code} is true
 $val = first_value {code} @list    # First value of <@list> where {code} is true
 @num = indexes     {code} @list    # Indexes into <@list> where {code} is true
 $num = last_index  {code} @list    # Last index into <@list> where {code} is true
 $val = last_value  {code} @list    # Last value of <@list> where {code} is true
 $num = max  @list       # Maximum value of <@list> (numerically)
 $str = maxs @list       # Maximum value of <@list> (string comparison)
 $num = min  @list       # Minimum value of <@list> (numerically)
 $str = mins @list       # Minimum value of <@list> (string comparison)

 # Looping helpers
 $it = each_array    @array, ...    # Loop over several arrays at once
 $it = each_arrayref $arref, ...    # Loop over several array references at once
 $it = natatime $n, @list           # Loop over a list, taking several values at once


=head1 DESCRIPTION

This module is a loose collection of miscellaneous list/array utility
functions that I have written over the years.  They've been useful to
me, and I am making them available to others in the hope that they
will find them useful as well.

The only common thread between these functions is that they all
operate on lists of variables -- tranforming them, selecting from
them, looping over them.

=head1 FUNCTIONS

=over 4

=item after

 @list = after {code} @list;

Returns a list of the values of @list after (and not including) the
point where {code} returns a true value.  Each element of the input
list is assigned to $_ (as an lvalue alias) in turn before invoking
the test code.

Example:

    @x = after {$_ % 5 == 0} (1..9);    # returns 6, 7, 8, 9

=item after_incl

 @list = after_incl {code} @list;

Returns a list of the values of @list after (and including) the point
where {code} returns a true value.  Each element of the input list is
assigned to $_ (as an lvalue alias) in turn before invoking the test
code.

This is almost the same as C<after>, except that it includes the
value in the list where {code} first returned true.

Example:

    @x = after_incl {$_ % 5 == 0} (1..9);    # returns 5, 6, 7, 8, 9

=item all

 $bool = all {code} @list;

Returns true if C<{code}> evaluates true for all elements of @list.
Each element is passed in turn to C<{code}> as C<$_>.  C<$_> acts as
an lvalue alias, like it does for C<map>.

Examples:

     $x = all {$_ > 5} (1..10);    # false
     $y = all {$_ > 5} (10..20);   # true

=item any

 $bool = any {code} @list;

Returns true if C<{code}> evaluates true for any element of @list.
Each element is passed in turn to C<{code}> as C<$_>.  C<$_> acts as
an lvalue alias, like it does for C<map>.

Examples:

     $x = any {$_ > 5} (1..5);    # false
     $y = any {$_ > 5} (1..10);   # true

=item before

 @list = before {code} @list;

Returns a list of the values of @list up until (but not including)
the point where {code} returns a true value.  Each element of the
input list is assigned to $_ (as an lvalue alias) before invoking the
test code.

Example:

    @x = before {$_ % 5 == 0} (1..9);    # returns 1, 2, 3, 4

=item before_incl

 @list = before_incl {code} @list;

Returns a list of the values of @list up to (and including) the point
where {code} returns a true value.  Each element of the input list is
assigned to $_ (as an lvalue alias) in turn before invoking the test
code.

This is almost the same as C<before>, except that it includes the
value in the list where {code} first returned true.

Example:

    @x = before_incl {$_ % 5 == 0} (1..9);    # returns 1, 2, 3, 4, 5

=item each_array

 $array_iterator = each_array(@a, @b, @c, ...);

Creates an array iterator to return the elements of a set of arrays in
turn.  That is, the first time it is called, it returns the first
element of each array.  The next time, it returns the second elements.
And so on, until all elements are exhausted.

This is useful for looping over more than one array at once:

     my $ea = each_array(@a, @b, @c);
     while ( ($a,$b,$c) = $ea->() )   { .... }

If the iterator is passed an argument of 'C<index>', then it retuns
the index of the last fetched set of values, as a scalar.

=item each_arrayref

 $array_iterator = each_arrayref(\@a, \@b, \@c, ...);

Works like each_array(), but works on array references instead of
arrays directly.

=item first_index

 $index = first_index {code} @list;

Returns the position in the argument list of the first value that
satisfies a given condition.  Each element is passed to C<{code}> as
C<$_> (as an lvalue alias, like for C<grep>).  Returns C<undef> if no
value in the list satisfies the condition.

Example:

     $x = first_index {$_ > 5}  (4..9);    # returns 2
     $x = first_index {$_ > 5}  (1..4);    # returns undef

=item first_value

 $value = first_value {code} @list;

Returns the first value that satisfies a given condition.  Each
element is passed to C<{code}> as C<$_> (as an lvalue alias, like
for C<grep>).  Returns C<undef> if no value in the list satisfies
the condition.

Example:

     $x = first_value {$_ > 5}  (4..9);    # returns 6
     $x = first_value {$_ > 5}  (1..4);    # returns undef

=item indexes

 @list = indexes {code} @list;

Returns a list of the indexes into C<@list> of the values that satisfy
the given condition.  Sort of like C<grep>, but returns index
positions instead of values.  Each element is passed to C<{code}> as
C<$_>. (as an lvalue alias, like for C<grep>).  Returns the empty list
if no value in the list satisfies the condition.

Example:

     @x = indexes {$_ > 5}  (4..9);    # returns (2, 3, 4, 5)
     @x = indexes {$_ > 5}  (1..4);    # returns ()

=item last_index

 $index = last_index {code} @list;

Returns the position in the argument list of the last value that
satisfies a given condition.  Each element is passed to C<{code}> as
C<$_> (as an lvalue alias, like for C<grep>).  Returns undef if no
value in the list satisfies the condition.

Example:

     $x = last_index {$_ > 5}  (4..9);    # returns 5
     $x = last_index {$_ > 5}  (1..4);    # returns undef

=item last_value

 $value = last_value {code} @list;

Returns the last value in the list that satisfies a given condition.
Each element is passed to C<{code}> as C<$_> (as an lvalue alias, like
for C<grep>).  Returns C<undef> if no value in the list satisfies the
condition.

Example:

     $x = last_value {$_ > 5}  (4..9);    # returns 9
     $x = last_value {$_ > 5}  (1..4);    # returns undef

=item max

 $scalar = max @list;

Returns the maximum (numerically) of a list of numbers.

=item maxs

 $scalar = maxs @list;

Returns the maximum (lexically) of a list of strings.

=item mesh

 @list = mesh @a, @b, ...;

Returns a list consisting of the first elements of each array, then
the second, then the third, etc, until all arrays are exhausted.

Examples:

    @x = qw/a b c d/;
    @y = qw/1 2 3 4/;
    @z = mesh @x, @y;    # returns a, 1, b, 2, c, 3, d, 4

    @a = ('x');
    @b = ('1', '2');
    @c = qw/zip zap zot/;
    @d = mesh @a, @b, @c;   # x, 1, zip, undef, 2, zap, undef, undef, zot

=item min

 $scalar = min @list;

Returns the minimum (numerically) of a list of numbers.

=item mins

 $scalar = mins @list;

Returns the minimum (lexically) of a list of strings.

=item natatime

 $iterator = natatime $n, @list;

Creates an array iterator, for looping over an array in chunks of
C<$n> items at a time.  (n at a time, get it?).  An example is
probably a better explanation than I could give in words.

Example:

     my @x = ('a'..'g');
     my $it = natatime 3, @x;
     while (my @vals = $it->())
     {
         print "@vals\n";
     }

This prints

     a b c
     d e f
     g

=item none

 $bool = none {code} @list;

Returns true if C<{code}> evaluates false for all elements of @list.
Each element is passed in turn to C<{code}> as C<$_>.  C<$_> acts as
an lvalue alias, like it does for C<map>.

Example:

     $x = none {$_ > 5} (1..5);    # true
     $y = none {$_ > 5} (1..10);   # false

=item pairwise

 @c = pairwise {code} @a, @b;

Applies C<{code}> to each pair of elements of C<@a>, C<@b> in turn.
Returns a list of the results of that evaluation.  The pairs are
assigned to C<$a> and C<$b> before invoking the code.  Note that C<$a>
and C<$b> are lvalue aliases into the input arrays.

Examples:

    @a = (1, 2, 3); @b = (2, 4, 6);
    @c = pairwise {$a + $b} @a, @b;   # returns (3, 6, 9)
    @d = pairwise {$a * $b} @a, @b;   # returns (2, 8, 18)

=back

=head1 EXPORTS

No symbols are exported by this module by default.

=head1 SEE ALSO

L<List::Util>

=head1 AUTHOR / COPYRIGHT

Eric J. Roode, eric@cpan.org

Copyright (c) 2004 by Eric J. Roode. All Rights Reserved.  This module
is free software; you can redistribute it and/or modify it under the
same terms as Perl itself.

If you have suggestions for improvement, please drop me a line.  If
you make improvements to this software, I ask that you please send me
a copy of your changes. Thanks.


=cut

#--->     @list = after {code} @input;
#
# Change History:
#     10/20/2002  EJR  First version
sub after (&@)
{
    my $test = shift;
    my $started;
    my $lag;
    grep $started ||= do { my $x=$lag; $lag=$test->(); $x},  @_;
}


#--->     @list = after_incl {code} @list;
#
# Change History:
#     10/20/2002  EJR  First version
sub after_incl (&@)
{
    my $test = shift;
    my $started;
    grep $started ||= $test->(), @_;
}

#--->     $bool = all {code} @list;
#
# Change History:
#     05/30/2002  EJR  First version
sub all (&@)
{
    my $test = shift;
    $test->()  ||  return  foreach @_;
    return 1;
}


#--->     $bool = any {code} @list;
#
# Change History:
#     05/30/2002  EJR  First version
sub any (&@)
{
    my $test = shift;
    $test->()  &&  return 1  foreach @_;
    return;
}


#--->     @list = before {code} @list;
#
# Change History:
#     10/20/2002  EJR  First version
sub before (&@)
{
    my $test = shift;
    my $keepgoing=1;
    grep $keepgoing &&= !$test->(),  @_;
}

#--->     @list = before_incl {code} @list;
#
# Change History:
#     10/20/2002  EJR  First version
sub before_incl (&@)
{
    my $test = shift;
    my $keepgoing=1;
    my $lag=1;
    grep $keepgoing &&= do { my $x=$lag; $lag=!$test->(); $x},  @_;
}

#--->     $array_iterator = each_array(@a, @b, @c, ...);
#
# Change History:
#     07/20/2001  EJR  First version.
#     08/07/2001  EJR  Renamed from 'aiter' to 'each_array'.
#     11/30/2001  EJR  Moved the guts to each_arrayref.
sub each_array (\@;\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@)
{
    return each_arrayref(@_);
}

#--->     $array_iterator = each_arrayref(\@a, \@b, \@c, ...);
#
# Change History:
#     11/30/2001  EJR  First version, from each_array
#     05/30/2002  EJR  Added 'index', 'exhausted', 'nextval' methods.
#                      No longer returns index value in scalar context.
#     10/11/2004  EJR  Removed 'exhausted' and 'nextval' methods; weren't useful.
sub each_arrayref
{
    my @arr_list  = @_;     # The list of references to the arrays
    my $index     = 0;      # Which one the caller will get next
    my $max_num   = 0;      # Number of elements in longest array

    # Get the length of the longest input array
    foreach (@arr_list)
    {
        unless (ref($_) eq 'ARRAY')
        {
            require Carp;
            Carp::croak "each_arrayref: argument is not an array reference\n";
        }
        $max_num = @$_  if @$_ > $max_num;
    }

    # Return the iterator as a closure wrt the above variables.
    return sub
    {
        if (@_)
        {
            my $method = shift;
            if ($method eq 'index')
            {
                # Return current (last fetched) index
                return undef if $index == 0  ||  $index > $max_num;
                return $index-1;
            }
            else
            {
                require Carp;
                Carp::croak "each_array: unknown argument '$method' passed to iterator.";
            }
        }

        return if $index >= $max_num;     # No more elements to return
        my $i = $index++;
        return map $_->[$i], @arr_list;   # Return ith elements
    }
}

#--->     $index = first_index {code} @list;
#
# Change History:
#     06/11/2002  EJR  First version
sub first_index (&@)
{
    my $test = shift;
    my $ix = 0;
    local $_;
    foreach (@_)
    {
        return $ix if $test->();
        $ix++;
    }
    return undef;
}

#--->     $value = first_value {code} @list;
#
# Change History:
#     06/11/2002  EJR  First version
sub first_value (&@)
{
    my $test = shift;
    local $_;
    foreach (@_)
    {
        return $_ if $test->();
    }
    return undef;
}

#--->     @list = indexes {code} @list;
#
# Change History:
#     06/11/2002  EJR  First version
#     02/26/2003  EJR  Rewrite to use grep, and not to use a temp array
sub indexes (&@)
{
    my $test = shift;
    local $_;

    grep {local $_=$_[$_]; $test->()} 0..$#_;
}

#--->     $index = last_index {code} @list;
#
# Change History:
#     06/11/2002  EJR  First version
#     10/16/2002  EJR  Make $_ act as an lvalue into caller's array.
sub last_index (&@)
{
    my $test = shift;
    local $_;
    my $ix;
    for ($ix=$#_; $ix>=0; $ix--)
    {
        $_ = $_[$ix];
        my $testval = $test->();
        $_[$ix] = $_;    # simulate $_ as alias
        return $ix if $testval;
    }
    return undef;
}

#--->     $value = last_value {code} @list;
#
# Change History:
#     06/11/2002  EJR  First version
#     10/16/2002  EJR  Make $_ act as an lvalue into caller's array.
sub last_value (&@)
{
    my $test = shift;
    local $_;
    my $ix;
    for ($ix=$#_; $ix>=0; $ix--)
    {
        $_ = $_[$ix];
        my $testval = $test->();
        $_[$ix] = $_;    # simulate $_ as alias
        return $_ if $testval;
    }
    return undef;
}

#--->     $scalar = max @list;
#
# Change History:
#     10/11/2004  EJR  Rewrite
sub max
{
    my $max = shift;
    $_ > $max  &&  ($max = $_)  for @_;
    return $max;
}

#--->     $scalar = maxs @list;
#
# Change History:
#     10/11/2004  EJR  Rewrite
sub maxs
{
    my $max = shift;
    $_ gt $max  &&  ($max = $_)  for @_;
    return $max;
}

#--->     @list = mesh @array, @array, ...;
#
# Change History:
#     10/10/2004  EJR  First version
sub mesh (\@\@;\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@) {
    my $max = -1;
    $max < $#$_  &&  ($max = $#$_)  for @_;

    map { my $ix = $_; map $_->[$ix], @_; } 0..$max; }

#--->     $scalar = min @list;
#
# Change History:
#     10/11/2004  EJR  Rewrite
sub min
{
    my $min = shift;
    $_ < $min  &&  ($min = $_)  for @_;
    return $min;
}

#--->     $scalar = mins @list;
#
# Change History:
#     10/11/2004  EJR  Rewrite
sub mins
{
    my $min = shift;
    $_ lt $min  &&  ($min = $_)  for @_;
    return $min;
}

#--->     $it = natatime $n, @list;
#
# Change History
#     10/12/2004  EJR  First version
sub natatime
{
    my $n = shift;
    my @list = @_;

    return sub
    {
        return splice @list, 0, $n;
    }
}

#--->     $bool = none {code} @list;
#
# Change History:
#     06/27/2002  EJR  First version
sub none (&@)
{
    my $test = shift;
    local $_;
    foreach (@_)
    {
        return if $test->();
    }
    return 1;
}

#--->     @c = pairwise {code} @a, @b;
#
# Change History:
#     06/27/2002  EJR  First version
#     02/23/2003  EJR  Several improvements; thanks to Benjamin Goldberg
sub pairwise(&\@\@)
{
    my $op = shift;
    local (*A, *B) = @_;    # syms for caller's input arrays

    # Localise $a, $b
    my ($caller_a, $caller_b) = do
    {
        my $pkg = caller();
        no strict 'refs';
        \*{$pkg.'::a'}, \*{$pkg.'::b'};
    };

    my $limit = $#A > $#B? $#A : $#B;    # loop iteration limit

    local(*$caller_a, *$caller_b);
    map    # This map expression is also the return value.
    {
        # assign to $a, $b as refs to caller's array elements
        (*$caller_a, *$caller_b) = \($A[$_], $B[$_]);
        $op->();    # perform the transformation
    }  0 .. $limit;
}

=begin gpg

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (Cygwin)

iD8DBQFBbViAY96i4h5M0egRAi6QAKCccdykc+x6P82a8RN6jRauuVbDsgCeN2Wx
vXgS0zRIkV2K1nWgnpKaQo0=
=vprS
-----END PGP SIGNATURE-----

=end gpg
