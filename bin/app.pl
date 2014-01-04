#!/usr/bin/env perl
use v5.12;

my $path;
BEGIN{
    use File::Basename;
    (undef,$path,undef) = fileparse(__FILE__);
}
use lib "$path../lib";

use OfBiViewer;
OfBiViewer->dance;

