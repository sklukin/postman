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

post '/send' => sub {
  my $c = shift;
  my $error  = '';
  my @params = (qw/to from subject data secret/);
  my %params;

  for my $p (@params) {
    return $c->reply->not_found unless $params{$p} = $c->param($p);
  }

  return $c->reply->not_found if $c->app->config->{secret} ne $params{secret};

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
