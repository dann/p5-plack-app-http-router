package Plack::App::HTTP::Router;
use strict;
use warnings;
use parent qw(Plack::Component);
use Plack::Request;
use Scalar::Util qw(blessed);

use Plack::Util::Accessor qw(router);

our $VERSION = '0.01';

sub call {
    my ( $self, $env ) = @_;
    my $req   = Plack::Request->new($env);
    my $match = $self->router->match($req);

    my $res;
    if ($match) {
        my $controller_name = $match->params->{controller};
        my $action          = $match->params->{action};
        my $params          = $match->params;
        $res = $self->dispatch_to_controller( $controller_name,
            $action, $params, $req );

        if ( blessed $res && $res->can('finalize') ) {
            return $res->finalize;
        }
        elsif ( not ref $res ) {
            return [ 200, [ 'Content-Type' => 'text/html' ], [$res] ];
        }
        else {
            return $res;
        }
    }

    return $self->return_404();
}

sub dispatch_to_controller {
    my ( $self, $controller_name, $action, $params, $req ) = @_;

    eval "require $controller_name";
    if ($@) {
        return $self->return_505($@);
    }

    my $controller = $controller_name->new;
    if ( $controller->can($action) ) {
        my $res = $controller->$action( $req, $params );
        return $res;
    }
    return;
}

sub return_505 {
    my ( $self, $error ) = @_;
    return [
        505,
        [ 'Content-Type' => 'text/html' ],
        [ 'Internal Server Error:' . $error ]
    ];

}

sub return_404 {
    return [ 404, [ 'Content-Type' => 'text/html' ], ['Not Found'] ];
}


sub show_routes {
    my $self = shift;
    eval "require Text::SimpleTable";
    if ($@) {
        print "Text::SimpleTable is required to show routes";
    }

    my $t = Text::SimpleTable->new(
        [ 50, 'path' ],
        [ 10, 'method' ],
        [ 10, 'controller' ],
        [ 10, 'action' ]
    );
    foreach my $route ( $self->router->routes ) {
        my $methods = $route->conditions->{method};
        $t->row(
            $route->path, $methods,
            $route->params->{controller},
            $route->params->{action}
        );
    }
    my $header = 'Dispatch Table:' . "\n";
    my $body = $t->draw;
    print $header . $body . "\n";
}
 
1;

1;
__END__

=encoding utf-8

=head1 NAME

Plack::App::HTTP::Router - A Plack component for RESTful dispatching 

=head1 SYNOPSIS

  use Plack::App::HTTP::Router;
  use HTTP::Router::Declare;
  my $router = router {
        match '/' => to { controller => 'Root', action => 'index' };
        resources 'weather';
        match '/{controller}/{action}/{id}.{format}';
        match '/{controller}/{action}/{id}';
  };
  my $app = Plack::App::HTTP::Router->new({ router => $router })->to_app;

=head1 DESCRIPTION

Plack::App::HTTP::Router is a plack component for RESTful dispatching.

=head1 SOURCE AVAILABILITY

This source is in Github:

  http://github.com/dann/p5-plack-app-http-router

=head1 AUTHOR

Takatoshi Kitano E<lt>kitano.tk@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
