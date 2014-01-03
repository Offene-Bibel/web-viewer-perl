#!/usr/bin/env perl
use CGI::Carp qw(fatalsToBrowser);
use Plack::Runner;

my $psgi = '/path/to/bin/app.pl';

die "Unable to read startup script: $psgi" unless -r $psgi;
Plack::Runner->run($psgi);

