#!/usr/bin/perl

# Written by Peter N Lewis a long time ago
# Released in to the Public Domain

# This script displays the IP associated with a DNS name (or vice versa).

# Usage: perl getDNSinfo.pl 192.168.0.202

use strict;
use warnings;

use Socket qw(AF_INET);

usage() if $#ARGV == -1;
display_info( @ARGV );

sub display_info {
  foreach (shift) {
    my ($ip, $host, $aliases, $addrtype, $length, @addrs);
    $ip = $_;
    if ( /^(\d+)\.(\d+)\.(\d+)\.(\d+)$/ ) {
      print "IP is $ip\n";
      ($host, $aliases, $addrtype, $length, @addrs) = 
         gethostbyaddr( pack( 'C4', $1, $2, $3, $4 ), AF_INET );
      die "Reverse lookup failed to find name for $ip\n" unless $host;
    }
    $host = $ip unless $host;
    print "Hostname is $host\n";
    ($host, $aliases, $addrtype, $length, @addrs) = gethostbyname( $host );
    die "Lookup failed to find address for $host\n" unless @addrs;
    print "Maps to these IPs:\n";
    foreach (@addrs) {
      print "IP: ".join( '.', unpack( 'C4', $_ ) )."\n";
    }
  }
}

sub usage {
  print STDERR <<EOM;
Usage: getdnsinfo.pl <IP|host>...
Example `getdnsinfo.pl www.interarchy.com'
EOM
  exit( 0 );
}
