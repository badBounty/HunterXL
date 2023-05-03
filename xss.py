import subprocess,os

from urllib.parse import urlparse

OUTPATH_DIRNFILES="outputs/dirnfiles.txt"
OUTPATH_XSS_GAU="outputs/xss-gau.txt"
OUTPATH_XSS_DALFOX="outputs/xss-dalfox.txt"
OUTPATH_XSS_DALFOX_AUX="outputs/xss-dalfox-aux.txt"
OUTPATH_VULNERABILITIES="outputs/vulnerabilities.txt"

def getDomain(url):
    return urlparse(url).netloc

getCmd=subprocess.Popen("cat "+OUTPATH_DIRNFILES+" | gf xss | sed 's/=.*/=/' | sed 's/URL: //' | tee -a "+OUTPATH_XSS_GAU, shell=True)
getCmd.wait()
xssCmd=subprocess.Popen("dalfox file "+OUTPATH_XSS_GAU+" --custom-alert-value=document.cookie --waf-evasion -o "+OUTPATH_XSS_DALFOX_AUX, shell=True)
xssCmd.wait()

if(os.path.isfile(OUTPATH_XSS_DALFOX_AUX)):
	parseCmd=subprocess.Popen("""awk '{for(i=1;i<=NF;i++){if($i~/^http/){print $i > "outputs/xss-dalfox.txt"}}}' """+OUTPATH_XSS_DALFOX_AUX, shell=True)
	parseCmd.wait()
	xssList=open(OUTPATH_XSS_DALFOX, 'r')
	while(True):
		endpoint=xssList.readline()
		if not endpoint:
			break
		os.system("echo "+getDomain(endpoint.strip())+","+endpoint.strip()+",XSS,Medium >> "+OUTPATH_VULNERABILITIES)
	xssList.close()
 
os.remove(OUTPATH_XSS_GAU)
os.remove(OUTPATH_XSS_DALFOX_AUX)
os.remove(OUTPATH_XSS_DALFOX)
