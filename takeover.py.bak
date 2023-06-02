import subprocess,os,json

OUTPATH_DNSREAPER="outputs/takeover.csv"
INPATH_SUBDOMAINS="outputs/subdomains.txt"

subprocess.run(["python3","tools/dnsReaper/main.py","file","--filename",INPATH_SUBDOMAINS,"--out", OUTPATH_DNSREAPER,"--out-format","csv"])
