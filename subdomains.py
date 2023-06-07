import os,subprocess

DIRPATH_WORDLISTS="wordlists"
DIRPATH_INPUTS="inputs"
DIRPATH_OUTPUTS="outputs"

INPATH_DOMAINS="inputs/domains.txt"
INPATH_SUBDOMAINS_WORDLISTS="inputs/subdomains-wordlists.txt"

FILPATH_WORDS="wordlists/words.txt"
FILPATH_RESOLVERS="wordlists/resolvers.txt"
FILPATH_SUBDOMAINS="wordlists/subdomains.txt"
FILPATH_SUBDOMAINS_AUX="wordlists/subdomains-aux.txt"

OUTPATH_AMASS="outputs/subdomains-amass.txt"
OUTPATH_ALTNDS_AUX="outputs/subdomains-altdns-aux.txt"
OUTPATH_ALTNDS="outputs/subdomains-altdns.txt"
OUTPATH_SUBDOMAINS="outputs/subdomains.txt"
OUTPATH_SUBDOMAINS_AUX="outputs/subdomains-aux.txt"

URLPATH_WORDS="https://raw.githubusercontent.com/infosec-au/altdns/master/words.txt"
URLPATH_RESOLVERS="https://raw.githubusercontent.com/blechschmidt/massdns/master/lists/resolvers.txt"

if(not os.path.isdir(DIRPATH_WORDLISTS)):
	os.mkdir(DIRPATH_WORDLISTS)

if(not os.path.isdir(DIRPATH_INPUTS)):
	os.mkdir(DIRPATH_INPUTS)

if(not os.path.isdir(DIRPATH_OUTPUTS)):
	os.mkdir(DIRPATH_OUTPUTS)

if(not os.path.isfile(FILPATH_WORDS)):
	subprocess.run(["wget",URLPATH_WORDS,"-q","-P",DIRPATH_WORDLISTS])

if(not os.path.isfile(FILPATH_RESOLVERS)):
    subprocess.run(["wget",URLPATH_RESOLVERS,"-q","-P",DIRPATH_WORDLISTS])

if(not os.path.isfile(FILPATH_SUBDOMAINS)):
	subdomainsWordlists=open(INPATH_SUBDOMAINS_WORDLISTS, 'r')
	while True:
		wordlistUrl=subdomainsWordlists.readline()
		if not wordlistUrl:
			break
		subprocess.run(["wget",wordlistUrl.strip(),"-O",FILPATH_SUBDOMAINS_AUX])
		os.system("cat "+FILPATH_SUBDOMAINS_AUX+" >> "+FILPATH_SUBDOMAINS)
		os.remove(FILPATH_SUBDOMAINS_AUX)
	subdomainsWordlists.close()


if(os.path.isfile(INPATH_DOMAINS)):
    domainsList=open(INPATH_DOMAINS, 'r')
    
    while True:
        domain=domainsList.readline()
        
        if not domain:
            break
            
        print("----------------Init amass for: " + domain.strip())
        subprocess.run(["amass","enum","-active","-d",domain.strip(),"-rf",FILPATH_RESOLVERS,"-brute","-w",FILPATH_SUBDOMAINS,"-o",OUTPATH_AMASS])
        
        print("----------------Init altdns for: " + domain.strip())
        subprocess.run(["altdns","-i",OUTPATH_AMASS,"-w",FILPATH_WORDS,"-r","-s",OUTPATH_ALTNDS_AUX,"-t","20", "-o", "dataoutput.txt"])
        
        print("----------------Init merge for: " + domain.strip())
        #os.remove("dataoutput.txt")
        os.system("cat "+OUTPATH_ALTNDS_AUX+" | awk -F: '(NR==0){h1=$1;h2=$2;next} {print $1}' > "+OUTPATH_ALTNDS)
        os.system("cat "+OUTPATH_AMASS+" >> "+OUTPATH_SUBDOMAINS_AUX)
        os.system("cat "+OUTPATH_ALTNDS+" >> "+OUTPATH_SUBDOMAINS_AUX)
        os.remove(OUTPATH_AMASS)
        os.remove(OUTPATH_ALTNDS)
        os.remove(OUTPATH_ALTNDS_AUX)
    domainsList.close()

os.system("sort -u " + OUTPATH_SUBDOMAINS_AUX +" > "+ OUTPATH_SUBDOMAINS)

os.remove(OUTPATH_SUBDOMAINS_AUX)

subprocess.run(["rm", "-r" , "wordlists"])
