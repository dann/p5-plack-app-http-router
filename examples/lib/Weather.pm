package Weather;
use strict;
use warnings;
use base qw(Class::Accessor);

sub index {
    return [ 200, [], ["index"] ];
}

sub create {
    return [ 200, [], ["create"] ];
}

sub post {
    return [ 200, [], ["post"] ];
}

sub show {
    return [ 200, [], ["show"] ];
}

sub edit {

    return [ 200, [], ["edit"] ];
}

sub destroy {
    return [ 200, [], ["destroy"] ];
}

sub update {
    return [ 200, [], ["update"] ];
}

1;
