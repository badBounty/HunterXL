from os import system
import os
import subprocess
from urllib.request import urlopen
from urllib.parse import urlparse

OUTPATH_SUBDOMAINS_WEBAPP="outputs/subdomains-webapp.txt"
OUTPATH_DIRNFILES="outputs/dirnfiles.txt"
OUTPATH_VULNERABILITIES="outputs/vulnerabilities.txt"
OUTPATH_DIRNFILES="outputs/dirnfiles.txt"

def getDomain(url):
    return urlparse(url).netloc

def framingAllowed(url):
    try:
        data=urlopen(url)
        headers=data.info()
        if not "X-Frame-Options" in headers:
            row=getDomain(url)+","+url+",Phishing,low"
            system("echo "+row+" >> "+OUTPATH_VULNERABILITIES)
    except: return False

if(not os.path.isfile(OUTPATH_DIRNFILES)):
    subdomainsWebappList=open(OUTPATH_SUBDOMAINS_WEBAPP, 'r')
    while True:
        subdomain=subdomainsWebappList.readline()
        if not subdomain:
            break
        framingAllowed(subdomain.strip())
    subdomainsWebappList.close()
else:
    dirnfilesList=open(OUTPATH_DIRNFILES, 'r')
    while True:
        url=dirnfilesList.readline()
        if not url:
            break
        framingAllowed(url.strip())
    dirnfilesList.close()
