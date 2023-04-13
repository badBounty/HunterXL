import subprocess,os,json

OUTPATH_DNSREAPER="outputs/dnsreaper.json"
OUTPATH_SUBDOMAINS="outputs/subdomains.txt"
OUTPATH_VULNERABILITIES="outputs/vulnerabilities.txt"

subprocess.run(["python3","tools/dnsReaper/main.py","file","--filename",OUTPATH_SUBDOMAINS,"--out","outputs/dnsreaper","--out-format","json"])

if(os.path.isfile(OUTPATH_DNSREAPER)):
    if(os.stat(OUTPATH_DNSREAPER).st_size != 0):
        with open(OUTPATH_DNSREAPER,'r') as takeoverJson:
            data=json.load(takeoverJson)

        for item in data:
            recordsCount=0
            for dns in item['cname_records']:
                recordsCount+=1
            subprocess.Popen("echo "+item['domain']+","+item['cname_records'][recordsCount-1]+",Subdomain Takeover,High"+" >> "+OUTPATH_VULNERABILITIES, shell=True)
    os.remove(OUTPATH_DNSREAPER)