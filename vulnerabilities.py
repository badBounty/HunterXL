import json,os,subprocess

from urllib.parse import urlparse

OUTPATH_SUBDOMAINS_WEBAPP="outputs/subdomains-webapp.txt"
OUTPATH_VULNERABILITIES="outputs/vulnerabilities.txt"
OUTPATH_NUCLEI="outputs/nuclei.json"
OUTPATH_NUCLEI_AUX="outputs/nuclei-aux.json"

def getDomain(url):
    return urlparse(url).netloc

os.system("nuclei -l "+OUTPATH_SUBDOMAINS_WEBAPP+" -include-tags fuzz,misc -nts -es info -json -o "+OUTPATH_NUCLEI)

data = {'vulnerabilities': []}

with open(OUTPATH_NUCLEI, 'r') as nucleiOutput:
    lines = nucleiOutput.readlines()
    for line in lines:
        data['vulnerabilities'].append(json.loads(line))
        
with open(OUTPATH_NUCLEI_AUX, 'w', encoding='utf-8') as nucleiJson:
    json.dump(data, nucleiJson, ensure_ascii=False, indent=4)

nucleiJson = open(OUTPATH_NUCLEI_AUX)
data = json.load(nucleiJson)

record = data['vulnerabilities']

for eachRecord in record:
    if(eachRecord['host'].__contains__("http")):
        os.system("echo "+getDomain(eachRecord['host'])+","+eachRecord['matched-at']+","+eachRecord['info']['name']+","+eachRecord['info']['severity']+" >> "+OUTPATH_VULNERABILITIES)
    else:
        os.system("echo "+eachRecord['host']+","+eachRecord['matched-at']+","+eachRecord['info']['name']+","+eachRecord['info']['severity']+" >> "+OUTPATH_VULNERABILITIES)

nucleiOutput.close()
nucleiJson.close()

os.remove(OUTPATH_NUCLEI)
os.remove(OUTPATH_NUCLEI_AUX)