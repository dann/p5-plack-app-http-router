use Test::Dependencies
    exclude => [qw/Test::Dependencies Test::Base Test::Perl::Critic Plack::App::HTTP::Router/],
    style   => 'light';
ok_dependencies();
