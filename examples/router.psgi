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
my $router_app = Plack::App::HTTP::Router->new({ router => $router} );
$router_app->show_routes;
my $app = $router_app->to_app;

builder {
    enable "Plack::Middleware::StackTrace";
    enable "Plack::Middleware::MethodOverride";
    $app;
};

