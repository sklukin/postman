#!/usr/bin/env perl
use Mojolicious::Lite;
use DDP;

# Documentation browser under "/perldoc"
plugin 'PODRenderer';

plugin 'Config' => { file => 'main.conf' };

plugin 'mail' => {
  from => 'info@sklukin.ru',
  type => 'text/html; charset="utf-8"'
};

get '/' => sub {
  my $c = shift;
  $c->render(template => 'index');
};

post '/send' => sub {
  my $c = shift;
  my $error  = '';
  my @params = (qw/to from subject data/);
  my %params;

  for my $p (@params) {
    return $c->reply->not_found unless $params{$p} = $c->param($p);
  }

  eval {
    $c->mail(%params);
    1;
  } or do {
    $error = "Sent error - $@"
  };

  $c->render(json => {
    success => $error ? 0 : 1,
    message => $error,
  });
};

app->start;

__DATA__

@@ index.html.ep
% layout 'default';
% title 'Welcome';
<h1>Welcome to the Mojolicious real-time web framework!</h1>
To learn more, you can browse through the documentation
<%= link_to 'here' => '/perldoc' %>.

@@ layouts/default.html.ep
<!DOCTYPE html>
<html>
  <head><title><%= title %></title></head>
  <body><%= content %></body>
</html>
