import os

from os import system

INPATH_SUBDOMAINS="outputs/subdomains.txt"
OUTPATH_SUBDOMAINS_SCAN="outputs/subdomains_scan.xml"
OUTPATH_SUBDOMAINS_SCAN_CSV="outputs/ports.csv"

system("sudo nmap --top-ports 1000 --open --script vuln,default,banner,ftp-anon,ftp-bounce,ftp-syst,ssh-auth-methods,sshv1,telnet-ntlm-info,dns-cache-snoop,dns-recursion -iL " + INPATH_SUBDOMAINS+" -sSV -Pn -oX "+OUTPATH_SUBDOMAINS_SCAN)
system("./tools/nmaptocsv/nmaptocsv.py -S -x "+OUTPATH_SUBDOMAINS_SCAN+" -o "+OUTPATH_SUBDOMAINS_SCAN_CSV)
system("sudo rm " + OUTPATH_SUBDOMAINS_SCAN)
