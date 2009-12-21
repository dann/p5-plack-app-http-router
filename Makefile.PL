use inc::Module::Install;
name 'Plack-App-HTTP-Router';
all_from 'lib/Plack/App/HTTP/Router.pm';

requires(
    'Plack'          => 0,
    'Plack::Request' => 0,
);

test_requires(
    'Test::More'           => 0,
    'Test::LoadAllModules' => 0,
);
use_test_base;
auto_include;
WriteAll;
