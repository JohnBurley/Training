#!/usr/bin/perl

# Written by Peter N Lewis a long time ago
# Released in to the Public Domain
# modified by Rudif c/o Perlmonks.org, to handle CRLF conversion

use strict;
use warnings;

usage() if $ARGV[0] and $ARGV[0] =~ m!^-[^-]!;

our $filepos = 0;
our $linechars = '';

foreach (@ARGV) {
    if ($_ eq "-") {
        binmode STDIN;
        *FILE = *STDIN;
    }
    else {
        open FILE, '<:raw', $_ or die "no such file $_";
    }
    while (<FILE>) {
        dump_char($_) foreach split(//);
    }
    dump_char( ' ', 1 ) while length($linechars) != 0;
    close FILE;
}

sub dump_char {
  my ( $char, $blank ) = @_;
  if ( length( $linechars ) == 0 ) {
    printf( "%06X: ", $filepos );
  }
  $linechars .= ( $char =~ m#[!-~ ]# ) ? $char : '.';
  if ( $blank ) {
    print '   ';
  } else {
    printf( "%02X ", ord($char) );
  }
  print ' ' if length( $linechars ) % 4 == 0;
  if ( length( $linechars ) == 16 ) {
    print( $linechars, "\n" );
    $linechars = '';
    $filepos += 16;
  }
}

sub usage {
  print STDERR <<EOM;
Usage: hdump.pl [file]...
Example `hdump.pl .cshrc' or `ls -l | hdump.pl'
EOM
  exit( 0 );
}
