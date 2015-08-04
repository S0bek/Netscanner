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

} else { die "$0 -h 192.168.0.1 -p 80\n-h: hote a scanner,\n-p: port a verifier\n"; }

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

    my %services = (
                    "21" => "ftp",
                    "22" => "ssh",
                    "23" => "telnet",
                    "25" => "smtp",
                    "69" => "tftp",
                    "80" => "http",
                    "107" => "rtelnet",
                    "110" => "pop3",
                    "115" => "sftp",
                    "123" => "ntp",
                    "139" => "Netbios-ssn",
                    "161" => "snmp",
                    "389" => "ldap",
                    "443" => "https",
                    "636" => "ldaps",
                    "873" => "rsync"
                    );

    for my $std_port (keys %services) {

      $port = $std_port;
      $portaddr = sockaddr_in($port , $inetaddr);

      print "TEST avec $std_port\n";

      socket(SOCK , AF_INET , SOCK_STREAM , $protocol) or die $!;

      if (connect(SOCK , $portaddr)) {

        print "Service $services{$std_port} detecte sur $host, le port est ouvert.\n";

      } #else { print "Port distant ferme ou hote inaccessible.\n"; }

      close(SOCK);

      # $port = $std_port;
      # $portaddr = sockaddr_in($port , $inetaddr);
      #
      # if(!defined(my $pid = fork())) {
      #   # si fork retourne undef, donc si aucune duplication si possible
      #   die "Impossible de dupliquer le thread courant: $!";
      #
      # } elsif ($pid == 0) {
      #
      #   #processus fils
      #   print "TEST avec $std_port\n";
      #
      #   socket(SOCK , AF_INET , SOCK_STREAM , $protocol) or die $!;
      #
      #   if (connect(SOCK , $portaddr)) {
      #
      #     print "Service $services{$std_port} detecte sur $host, le port est ouvert.\n";
      #
      #   } #else { print "Port distant ferme ou hote inaccessible.\n"; }
      #
      #   close(SOCK);
      #   #  print "Printed by child process\n";
      #   #  exec("date") || die "can't exec date: $!";
      #
      # } else {
      #
      #   #processus pere
      #
      #   # print "Printed by parent process\n";
      #   my $ret = waitpid($pid , 0);
      #   # print "Completed process id: $ret\n";
      #
      # }
      #
      # 1;



    }

  }

}
