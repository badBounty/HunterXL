import json,subprocess,os

from urllib.parse import urlparse

OUTPATH_SUBDOMAINS_WEBAPP="outputs/subdomains-webapp.txt"
OUTPATH_TECHNOLOGIES="outputs/technologies.txt"
OUTPATH_WAPPALYZER="outputs/wappalyzer.json"

data = []

url=""
statusCode=""

def getDomain(url):
    return urlparse(url).netloc

if(os.path.isfile(OUTPATH_SUBDOMAINS_WEBAPP)):
	subdomainsList=open(OUTPATH_SUBDOMAINS_WEBAPP, 'r')
	while True:
		endpoint=subdomainsList.readline()
  
		if not endpoint:
			break

		cmd=subprocess.Popen("node ./tools/wappalyzer/src/drivers/npm/cli.js "+endpoint.strip()+" -P -N | tee -a "+OUTPATH_WAPPALYZER, shell=True)
		cmd.wait()
  
		with open(OUTPATH_WAPPALYZER) as wappalyzerOutput:
			data =json.load(wappalyzerOutput)
		i=0
		for item in data['urls']:
			i+=1
		j=0
		for item in data['urls']:
			j+=1
			if(j==i):
				url=item
		for key,value in data['urls'][url].items():
			statusCode=str(value)
		for item in data['technologies']:
			os.system("echo "+getDomain(url)+","+statusCode+","+item['name']+","+str(item['version'])+" >> "+OUTPATH_TECHNOLOGIES) #cargar a db
		wappalyzerOutput.close()
		os.remove(OUTPATH_WAPPALYZER)
	subdomainsList.close()