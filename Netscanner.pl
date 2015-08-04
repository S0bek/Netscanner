#!/usr/bin/perl -w

use strict;
use Getopt::Std;
use Socket;

my %opts = ();
getopts("h:p:x" , \%opts);

my $protocol = getprotobyname("tcp");#pas d'icmp car peut être bloqué par l'hôte distant
my ($host , $port , $inetaddr , $portaddr , $return_code , $status);

#scanner
if ((defined($opts{h}) and defined($opts{p})) or defined($opts{h}) and defined($opts{x})) {

  $host = $opts{h};
  $inetaddr = inet_aton($host) or die "Impossible de resoudre le nom d'hote $host\n";#résolution DNS si le nom d'hôte est utilisé et non une adresse IP standard

  if (defined($opts{p}) and int($opts{p})) {

    $port = $opts{p};
    $portaddr = sockaddr_in($port , $inetaddr);
    $status = scan();

    print "VALEUR DE STATUS: $status\n";

  } elsif (defined($opts{x})){

    standard_scan();

  }

} else { die "$0 -h 192.168.0.1 -p 80\n-h: hote a scanner,\n-p: port a verifier\n-x (optionnel, a coupler avec h):scan les ports les plus reputes.\n"; }

sub scan {

    $return_code = 1;

    socket(SOCK , AF_INET , SOCK_STREAM , $protocol) or die $!;

    if (connect(SOCK , $portaddr)) {

      print "Le port distant est bien ouvert et accessible sur $host.\n";
      $return_code = 0;

    } else { die "Port distant ferme ou hote inaccessible.\n"; }

    close(SOCK);

  return $return_code;

}

sub standard_scan {

  if (defined($opts{x})) {

    my @ports = (21 , 22 , 23 , 25 , 69 , 80 , 107 , 110 , 115 , 123 , 139 , 161 , 389 , 443 , 636 , 873);
    my @services = ("ftp" , "ssh" , "telnet" , "smtp" , "tftp" , "http" , "rtelnet" , "pop3" , "sftp" , "ntp" , "Netbios-ssn" , "snmp" , "ldap" , "https" , "ldaps" , "rsync");
    my $i;

    for ($i = 0; $i < @ports; $i++) {
      my $sock;
      my $service = $services[$i];
      my $port = $ports[$i];
      my $portaddr = sockaddr_in($port , $inetaddr);
      my $timeout = 4;
      socket($sock , AF_INET , SOCK_STREAM , $protocol) or die $!;
      setsockopt($sock , SOL_SOCKET, SO_RCVTIMEO, pack('l!l!', $timeout, 0)) or die "setsockopt: $!";

      if (connect($sock , $portaddr)) {
        print "Service $service detecte sur $host, le port est ouvert.\n";
      }

      shutdown($sock, 2);
      close($sock);
    }

  }

}
