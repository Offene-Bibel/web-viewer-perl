#!/usr/bin/env perl
use CGI::Carp qw(fatalsToBrowser);
use Plack::Loader;
use Plack::Handler::FCGI;

my $psgi = '/path/to/bin/app.pl';
die "Unable to read startup script: $psgi" unless -r $psgi;

my $app = Plack::Util::load_psgi($psgi);
my $server = Plack::Handler::FCGI->new(nproc => 5, detach => 1);
$server->run($app);

