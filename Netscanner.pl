#!/usr/bin/perl -w

use strict;
use Getopt::Std;
use Socket;

my %opts = ();
getopts("h:p:" , \%opts);

my $protocol = getprotobyname("tcp");#pas d'icmp car peut être bloqué par l'hôte distant
my ($host , $port , $inetaddr , $portaddr , $return_code , $status);

sub usage {

  die "$0 -h 192.168.0.1 -p 80\n-h: hote a scanner,\n-p: port a verifier\n";

}

sub scan {

  if (defined($opts{h}) and defined($opts{p}) and int($opts{p})) {

    $return_code = 1;

    $host = $opts{h};
    $port = $opts{p};

    $inetaddr = inet_aton($host) or die "Impossible de resoudre le nom d'hote $host\n";#résolution DNS si le nom d'hôte est utilisé et non une adresse IP standard
    $portaddr = sockaddr_in($port , $inetaddr);

    socket(SOCK , AF_INET , SOCK_STREAM , $protocol) or die $!;

    if (connect(SOCK , $portaddr)) {

      print "Le port distant est bien ouvert et accessible sur $host\n";
      $return_code = 0;

    } else { die "Port distant ferme ou hote inaccessible\n"; }

    close(SOCK);

  } else { usage(); }

  return $return_code;

}

$status = scan();
print "VALEUR DE STATUS: $status\n";
