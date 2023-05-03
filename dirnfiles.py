import os

OUTPATH_SUBDOMAINS_WEBAPP="outputs/subdomains-webapp.txt"
OUTPATH_DIRNFILES_GAU_AUX="outputs/dirnfiles-gau-aux.txt"
OUTPATH_DIRNFILES="outputs/dirnfiles.txt"

if(os.path.isfile(OUTPATH_SUBDOMAINS_WEBAPP)):
	webappsList=open(OUTPATH_SUBDOMAINS_WEBAPP, 'r')
	while True:
		endpoint=webappsList.readline()
		if not endpoint:
			break
		os.system("gau "+endpoint.strip()+" --verbose --o "+OUTPATH_DIRNFILES_GAU_AUX)
		os.system("sort -u "+OUTPATH_DIRNFILES_GAU_AUX+" >> "+OUTPATH_DIRNFILES)
		os.remove(OUTPATH_DIRNFILES_GAU_AUX)
	webappsList.close()
