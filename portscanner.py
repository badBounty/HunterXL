import os

from os import system

OUTPATH_SUBDOMAINS="outputs/subdomains.txt"
OUTPATH_SUBDOMAINS_SCAN="outputs/subdomains_scan.xml"
OUTPATH_SUBDOMAINS_SCAN_CSV="outputs/subdomains_scan.csv"
system("sudo nmap --top-ports 1000 -T4 -iL "+OUTPATH_SUBDOMAINS+" -sSV -Pn -oX "+OUTPATH_SUBDOMAINS_SCAN)
system("./tools/nmaptocsv/nmaptocsv.py -x "+OUTPATH_SUBDOMAINS_SCAN+" -o "+OUTPATH_SUBDOMAINS_SCAN_CSV)
