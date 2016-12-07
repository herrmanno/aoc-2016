#!/usr/bin/perl
use strict;
use warnings;
use 5.012;
 
my $file = $ARGV[0];
open my $fh, '<', $file or die "Could not open '$file' $!\n";
 
my $abba = '(.)(?!\1)(.)\2\1';
my $sq_br_abba = '\[[^\]]*?(.)(?!\1)(.)\2\1[^\]]*?\]';

my $count = 0;
while (my $line = <$fh>) {
    if($line =~ /$abba/ && (not $line =~ m/$sq_br_abba/)) {
        $count ++;
    }
}

print "The number of IPs that support TLS is:\n\t $count\n";