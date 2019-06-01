#!/usr/bin/perl
use warnings;
use strict;
use v5.18;

my $i = 0;
for my $line (split(/\n/,`docker images`)) {
    next unless $i++;
    if ($line =~ /^\<none\>\s+\S+\s+(\w+)/) {
        system('docker rmi -f ' . $1);
    }
}
