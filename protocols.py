import subprocess,os,shutil

from os import system

DIRPATH_OUTPUTS="outputs"

OUTPATH_SUBDOMAINS="outputs/subdomains.txt"
OUTPATH_SUBDOMAINS_WEBAPP_AUX="outputs/subdomains-webapp-aux.txt"
OUTPATH_SUBDOMAINS_WEBAPP="outputs/subdomains-webapp.txt"
system("cat " +OUTPATH_SUBDOMAINS+" | aquatone -ports large -threads 7 -chrome-path /usr/bin/chromium")
system("cat aquatone_urls.txt | grep 'https:' > "+OUTPATH_SUBDOMAINS_WEBAPP_AUX)
os.remove("aquatone_urls.txt")
os.remove("aquatone_report.html")
os.remove("aquatone_session.json")
shutil.rmtree("headers")
shutil.rmtree("html")
#shutil.rmtree("screenshots")

subdomainsList=open(OUTPATH_SUBDOMAINS_WEBAPP_AUX, 'r')
while True:
	subdomain=subdomainsList.readline()
	if not subdomain:
		break
	statusCode = subprocess.run(['curl', subdomain.strip(), '-o', '/dev/null', '-s', '-w', '%{http_code}'], check=False, capture_output=True, text=True).stdout
	if statusCode == "200":
		system("echo "+subdomain.strip()+" >> "+OUTPATH_SUBDOMAINS_WEBAPP)
subdomainsList.close()
os.remove(OUTPATH_SUBDOMAINS_WEBAPP_AUX)


