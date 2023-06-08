import os

from os import system

INPATH_SUBDOMAINS="outputs/subdomains.txt"
OUTPATH_SUBDOMAINS_SCAN="outputs/subdomains_scan"
OUTPATH_SUBDOMAINS_SCAN_CSV="outputs/ports.csv"

system("sudo nmap --top-ports 1000 --open --script vuln,default,banner,ftp-anon,ftp-bounce,ftp-syst,ssh-auth-methods,sshv1,telnet-ntlm-info,dns-cache-snoop,dns-recursion -iL " + INPATH_SUBDOMAINS+" -sSV -Pn -oA "+OUTPATH_SUBDOMAINS_SCAN)

system("./tools/nmaptocsv/nmaptocsv.py -S -x " + OUTPATH_SUBDOMAINS_SCAN + ".xml -o "+OUTPATH_SUBDOMAINS_SCAN_CSV)