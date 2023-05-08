import json,os

OUTPATH_SUBDOMAINS_WEBAPP="outputs/subdomains-webapp.txt"
OUTPATH_NUCLEI="outputs/nuclei.json"

os.system("nuclei -l "+OUTPATH_SUBDOMAINS_WEBAPP+" -t /home/admin/nuclei-templates -je -o "+OUTPATH_NUCLEI)

