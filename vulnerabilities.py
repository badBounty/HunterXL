import json,os,subprocess

OUTPATH_SUBDOMAINS_WEBAPP="outputs/subdomains-webapp.txt"
OUTPATH_NUCLEI="outputs/nuclei.json"
OUTPATH_TESTSSL="outputs/output_ssl.html"
OUTPATH_SUBDOMAINS="outputs/subdomains.txt"
OUTPATH_SSLSCAN="outputs/output_sslscan.txt"

os.system("nuclei -l "+OUTPATH_SUBDOMAINS_WEBAPP+" -t /home/admin/nuclei-templates -je -o "+OUTPATH_NUCLEI)
if [os.path.exists(OUTPATH_TESTSSL)]:
	(os.remove(OUTPATH_TESTSSL))
else:
	subprocess.run(["./tools/testssl.sh/testssl.sh", "--htmlfile", OUTPATH_TESTSSL, "-iL", OUTPATH_SUBDOMAINS_WEBAPP])

os.system("sslscan --targets="+OUTPATH_SUBDOMAINS_WEBAPP+" > "+OUTPATH_SSLSCAN)
