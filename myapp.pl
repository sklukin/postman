#!/usr/bin/env perl
use Mojolicious::Lite;
use DDP;

# Documentation browser under "/perldoc"
plugin 'PODRenderer';

plugin 'Config' => { file => 'main.conf' };

plugin 'mail' => {
  from => 'mail@sklukin.ru',
  type => 'text/html; charset="utf-8"'
};

get '/' => sub {
  my $c = shift;
  $c->render(template => 'index');
};

post '/send' => sub {
  my $c = shift;
  my $message = '';

  $c->reply->not_found unless my $msg = $c->param('msg');

  p $msg;

  $c->mail(
    to      => 'sklukin@yandex.ru',
    subject => 'Hi',
    data    => 'use Perl or die',
  );

  p $msg;

  # # $c->mail(mail => $msg);
  # # my @args = ('/usr/bin/sendmail', $msg;
  # # system (@args) or $message = 'Cant send mail'

  # my @cmd = ( 'sendmail', '-t', '-oi', '-oem' );

  # # # SetSender default is true
  # # $p{SetSender} = 1 unless defined $p{SetSender};

  # # ### See if we are forcibly setting the sender:
  # # $p{SetSender} ||= defined( $p{FromSender} );

  # # ### Add the -f argument, unless we're explicitly told NOT to:
  # # if ( $p{SetSender} ) {
  # #     my $from = $p{FromSender} || ( $self->get('From') )[0];
  # #     if ($from) {
  # #         my ($from_addr) = extract_full_addrs($from);
  # #         push @cmd, "-f$from_addr" if $from_addr;
  # #     }
  # # }
  # push @cmd, $msg;

  # ### Open the command in a taint-safe fashion:
  # my $pid = open SENDMAIL, "|-";
  # defined($pid) or die "open of pipe failed: $!\n";
  # if ( !$pid ) {    ### child
  #     exec(@cmd) or die "can't exec sendmail: $!\n";
  #     ### NOTREACHED
  # } else {          ### parent
  #     # $self->print( \*SENDMAIL );
  #     close SENDMAIL || die "error closing sendmail: $! (exit $?)\n";
  #     # $return = 1;
  # }

  $c->render(json => {
    success => 1,
    message => $message,
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
