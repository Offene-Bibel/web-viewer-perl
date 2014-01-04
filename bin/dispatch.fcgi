#!/usr/bin/env perl
use CGI::Carp qw(fatalsToBrowser);
use Plack::Handler::FCGI;

my $psgi = '/path/to/bin/app.pl';

$ENV{DANCER_APPHANDLER} = 'PSGI';
my $app = do($psgi);
die "Unable to read startup script: $@" if $@;
my $server = Plack::Handler::FCGI->new(nproc => 5, detach => 1);
$server->run($app);

