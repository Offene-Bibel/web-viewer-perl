#!/usr/bin/env perl
use CGI::Carp qw(fatalsToBrowser);
use Plack::Loader;
use Plack::Handler::CGI;

my $psgi = '/path/to/bin/app.pl';
die "Unable to read startup script: $psgi" unless -r $psgi;

my $app = Plack::Util::load_psgi($psgi);
Plack::Handler::CGI->new->run($app);

