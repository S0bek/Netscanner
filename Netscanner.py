#!/usr/bin/python

'''Simple network scanner with basic socket function'''

import socket
import os
import sys
import threading
from optparse import OptionParser

prog = os.path.basename(sys.argv[0])
host = None
port = None
scans = []

def banner():
    return """Netscanner (v2) by S0bek - Simple port scanner"""

ban = banner()

# Option config
parser = OptionParser()
parser.prog = prog
parser.description = ban
parser.usage = parser.prog + " -l length"
parser.add_option("-a", "--host", type=str, dest="host", help="target host to scan")
parser.add_option("-p" , "--port" , type=int , dest="ports" , help="port to scan")

(options, args) = parser.parse_args()

# Option check
if (options.host == None) and (options.ports == None):

    parser.print_help(file=None)
    exit(1)

else:

    if not options.host == None:
        host = options.host

        if options.ports == None:
            ports = {"ftp" : 21 , "ssh" : 22 , "telnet" : 23 , "smtp" : 25 , "dns" : 53 , "tftp" : 59 , "http" : 80 , "pop3" : 110 , "ntp" : 123 , "netbios" : 139 , "imap" : 143 , "snmp" : 161 , "imap3" : 220 , "https" : 443 , "smb/active directory" : 445 , "syslog" : 514 , "afp (Apple)" : 548}

        elif not options.ports == None:
            #here change the name of the key to match correct service name
            ports = {'defined' : options.ports}

    else:

        parser.print_help(file=None)
        exit(1)

# Functions
class Scan(threading.Thread):

    def __init__(self , host , port , service):
        threading.Thread.__init__(self)
        self.host = host
        self.port = port
        self.service = service

    #Function to start the thread operations
    def run(self):
        scan(self.host , self.port , self.service)

def scan(host , port , service):

    try:
        sock = socket.socket(socket.AF_INET , socket.SOCK_STREAM)

        status = sock.connect_ex((host , port))
        if status == 0:
            print("%s/tcp\t\topen\t\t%s" % (str(port) , service.upper()))
        sock.close()

    except Exception as e: print("[error]\tError during connection creation: " + str(e))

# We start the scan operation

print("[info]\tScanning network for " + host + "...\n")
print("LIST OF OPENED PORTS IDENTIFIED:\n")
print("PORT\t\tSTATE\t\tSERVICE")

for service in ports:

    #if not ports.has_key('defined'): print("[info]\tScanning port %s (%s)..." %(port , ports[port]))
    #else: print("[info]\tScanning port " + str(ports[port]) + "...")
    result = Scan(host , ports[service] , service)
    result.start()
    scans.append(result)

# Wait for job completion
for result in scans:
    result.join()

# Scan complete
print("\n[info]\tScan complete")
