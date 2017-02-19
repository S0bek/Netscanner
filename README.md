Un simple scanner de ports

VERSION PERL:
Usage:
Netscanner.pl -h 192.168.0.1 -p 80                                                                        
Netscanner.pl -h 192.168.0.1 -x                                                                           
-h: adresse ip de l'hôte ciblé                                                                            
-p: port à tester                                                                                         
-x: scanner les ports les plus communs: ssh, http, ftp...                                                 

VERSION PYTHON (les options changent):      
Usage: Netscanner.py -l length                     
Netscanner (v2) by S0bek - Simple port scanner       
     
Options:                                                  
  -h, --help             show this help message and exit    
  -a HOST, --host=HOST   target host to scan             
  -p PORTS, --port=PORTS port to scan                     
