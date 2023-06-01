import os

from os import system

DIRPATH_WORDLISTS="wordlists"
DIRPATH_INPUTS="inputs"
DIRPATH_OUTPUTS="outputs"

INPATH_DIRNFILES_WORDLISTS="inputs/dirnfiles-wordlists.txt"
FILPATH_DIRNFILES="wordlists/dirnfiles.txt"
FILPATH_DIRNFILES_AUX="wordlists/dirnfiles-aux.txt"
FILPATH_BASIC="inputs/basicAuth.txt"

OUTPATH_SUBDOMAINS_WEBAPP="outputs/subdomains-webapp.txt"
OUTPATH_DIRNFILES="outputs/dirnfiles.txt"
OUTPATH_DIRNFILES_AUX="outputs/dirnfiles-aux.txt"
OUTPATH_DIRNFILES_DOMAIN_AUX="outputs/dirnfiles-domain-aux.txt"
OUTPATH_WAFDETECT_NOWAF="outputs/wafdetect-nowaf.txt"

if(not os.path.isfile(FILPATH_DIRNFILES)):
	dirnfilesWordlists=open(INPATH_DIRNFILES_WORDLISTS, 'r')
	while True:
		url=dirnfilesWordlists.readline()
		if not url:
			break
		system("wget " + url.strip() + " -O " + FILPATH_DIRNFILES_AUX)
		system("cat "+FILPATH_DIRNFILES_AUX+" >> "+FILPATH_DIRNFILES)
		os.remove(FILPATH_DIRNFILES_AUX)
	dirnfilesWordlists.close()

if(os.path.isfile(OUTPATH_WAFDETECT_NOWAF)):
	noWafWebappsList=open(OUTPATH_WAFDETECT_NOWAF, 'r')
	while True:
		endpoint=noWafWebappsList.readline()
		if not endpoint:
			break
		system("dirsearch -u "+endpoint.strip()+" -w "+FILPATH_DIRNFILES+" -o "+OUTPATH_DIRNFILES_AUX+" -f -r --deep-recursive --force-recursive -e zip,bak,old,php,jsp,asp,aspx,txt,html,sql,js,log,xml,sh -i 200 --format=csv -t 60")
		system("cat "+OUTPATH_DIRNFILES_AUX+" >> "+OUTPATH_DIRNFILES)
		os.remove(OUTPATH_DIRNFILES_AUX)
	noWafWebappsList.close()