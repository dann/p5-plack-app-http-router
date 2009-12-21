package Root;
use strict;
use warnings;
use base qw(Class::Accessor);

sub index {
    return [ 200, [], [ "Hello World" ] ];
}

1;
