use Plack::Builder;
use Plack::App::HTTP::Router;
use HTTP::Router::Declare;
use lib 'examples/lib';

my $router = router {
      match '/' => to { controller => 'Root', action => 'index' };
      resources 'Weather';
      match '/{controller}/{action}/{id}.{format}';
      match '/{controller}/{action}/{id}';
};
my $app = Plack::App::HTTP::Router->new({ router => $router} )->to_app;

builder {
    enable "Plack::Middleware::StackTrace";
    $app;
};

