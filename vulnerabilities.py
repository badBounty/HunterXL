import json,os,subprocess

OUTPATH_SUBDOMAINS_WEBAPP="outputs/subdomains-webapp.txt"
OUTPATH_NUCLEI="outputs/nuclei.json"
OUTPATH_TESTSSL="outputs/output_ssl.html"
OUTPATH_SUBDOMAINS="outputs/subdomains.txt"
OUTPATH_SSLSCAN="outputs/output_sslscan.txt"
OUTPATH_NIKTO="outputs/output_nikto.txt"
OUTPATH_ZAP="outputs/zap-output.csv"
#os.system("nuclei -l "+OUTPATH_SUBDOMAINS_WEBAPP+" -t /home/admin/nuclei-templates -je -o "+OUTPATH_NUCLEI)
#if [os.path.exists(OUTPATH_TESTSSL)]:
#	(os.remove(OUTPATH_TESTSSL))
#else:
#	subprocess.run(["./tools/testssl.sh/testssl.sh", "--htmlfile", OUTPATH_TESTSSL, "-iL", OUTPATH_SUBDOMAINS_WEBAPP])

#os.system("sslscan --targets="+OUTPATH_SUBDOMAINS_WEBAPP+" > "+OUTPATH_SSLSCAN)
#os.system("nikto -host "+OUTPATH_SUBDOMAINS_WEBAPP+" -output "+OUTPATH_NIKTO)

#Zap en docker
comando = "docker run -v $(pwd):/zap/wrk --rm owasp/zap2docker-stable zap-baseline.py -t http://torneos.com -x OUTPATH_ZAP"

# Ejecutar el comando con sudo
sudo_comando = ["sudo", "bash","-c", comando]

# Llamar al comando con subprocess
subprocess.run(sudo_comando)


