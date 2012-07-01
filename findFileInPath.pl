#!/usr/bin/perl

# Written by Peter N Lewis
# Released in to the Public Domain
# I'm going to delete everything now!! :P

# Usage: perl findFileInPath.pl dos2unix

use warnings;
use strict;

our $path = $ENV{'PATH'};

for my $request (shift) {
  for my $dir ( split( /:/,$path ) ) {
	my $file = "$dir/$request";
    print "$file\n" if -e $file;
  }
}
