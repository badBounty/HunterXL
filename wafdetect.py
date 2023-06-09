import os,subprocess

from urllib.parse import urlparse

INPATH_SUBDOMAINS_WEBAPP="outputs/subdomains-webapp.txt"
OUTPATH_DIRNFILES_DOMAIN_AUX="outputs/dirnfiles-domain-aux.txt"
#OUTPATH_VULNERABILITIES="outputs/vulnerabilities.txt"
OUTPATH_WAFDETECT_NOWAF="outputs/wafdetect-nowaf.txt"

def getDomain(url):
    return urlparse(url).netloc

webappsList=open(INPATH_SUBDOMAINS_WEBAPP, 'r')

while True:
    endpoint=webappsList.readline()

    if not endpoint:
        break

    print("----------------Init wafw00f for: " + endpoint.strip())
    output = subprocess.Popen("wafw00f "+endpoint.strip()+" | grep -e 'No WAF detected' -e 'was not detected' -c", shell=True, stdout=subprocess.PIPE)
    
    output.wait()
    
    wafStatus = output.communicate()[0].decode("utf-8").strip()

    if wafStatus == '1':
        print("WAF not detected for: "+endpoint.strip())
        os.system("echo "+endpoint.strip()+" >> "+OUTPATH_WAFDETECT_NOWAF)
        
webappsList.close()

if(os.path.isfile(OUTPATH_DIRNFILES_DOMAIN_AUX)):
        os.remove(OUTPATH_DIRNFILES_DOMAIN_AUX)