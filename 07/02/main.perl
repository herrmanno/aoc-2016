#!/usr/bin/perl
use strict;
use warnings;
use 5.012;
 
my $file = $ARGV[0];
open my $fh, '<', $file or die "Could not open '$file' $!\n";
 
my $r1 = '(.)(?!\1)(.)\1.*?\[[^\]]*?\2\1\2[^\]]*?\]';
my $r2 = '\[[^\]]*?(.)(?!\1)(.)\1[^\]]*?\].*?\2\1\2';
my $r3 = '\[[^\]]*?(.)(?!\1)(.)\1[^\]]*?\].*\[[^\]]*?\2\1\2[^\]]*?\]';

my $count = 0;
while ($_ = <$fh>) {
    if(/$r1/ || /$r2/) {
        $count ++;
    }
    if(/$r3/) {
        $count --;
    }
}

print "The number of IPs that support SSL is:\n\t $count\n";