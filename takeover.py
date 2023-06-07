import subprocess,os,json

OUTPATH_DNSREAPER="outputs/takeover"
INPATH_SUBDOMAINS="outputs/subdomains.txt"

print("-------------Init dnsReaper-------------")

subprocess.run(["python3","tools/dnsReaper/main.py","file","--filename",INPATH_SUBDOMAINS,"--out", OUTPATH_DNSREAPER,"--out-format","csv"])
