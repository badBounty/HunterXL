import subprocess,os,shutil

from os import system

DIRPATH_OUTPUTS="outputs"

INPATH_SUBDOMAINS="outputs/subdomains.txt"
OUTPATH_SUBDOMAINS_HTTPX="outputs/httpx.txt"
OUTPATH_SUBDOMAINS_WEBAPP="outputs/subdomains-webapp.txt"

os.system("cat "+ INPATH_SUBDOMAINS+ " |httprobe -p http:81 -p http:300 -p http:591 -p http:593 -p http:832 -p http:981 -p http:1010 -p http:1311 -p http:2082 -p http:2087 -p http:2095 -p http:2096 -p http:2480 -p http:3000 -p http:3128 -p http:3333 -p http:4243 -p http:4567 -p http:4711 -p http:4712 -p http:4993 -p http:5000 -p http:5104 -p http:5108 -p http:5800 -p http:6543 -p http:7000 -p http:7396 -p http:7474 -p http:8000 -p http:8001 -p http:8008 -p http:8014 -p http:8042 -p http:8069 -p http:8080 -p http:8081 -p http:8088 -p http:8090 -p http:8091 -p http:8118 -p http:8123 -p http:8172 -p http:8222 -p http:8243 -p http:8280 -p http:8281 -p http:8333 -p http:8443 -p http:8500 -p http:8834 -p http:8880 -p http:8888 -p http:8983 -p http:9000 -p http:9043 -p http:9060 -p http:9080 -p http:9090 -p http:9091 -p http:9200 -p http:9443 -p http:9800 -p http:9981 -p http:12443 -p http:16080 -p http:18091 -p http:18092 -p http:20720 -p http:28017 -p https:81 -p https:300 -p https:591 -p https:593 -p https:832 -p https:981 -p https:1010 -p https:1311 -p https:2082 -p https:2087 -p https:2095 -p https:2096 -p https:2480 -p https:3000 -p https:3128 -p https:3333 -p https:4243 -p https:4567 -p https:4711 -p https:4712 -p https:4993 -p https:5000 -p https:5104 -p https:5108 -p https:5800 -p https:6543 -p https:7000 -p https:7396 -p https:7474 -p https:8000 -p https:8001 -p https:8008 -p https:8014 -p https:8042 -p https:8069 -p https:8080 -p https:8081 -p https:8088 -p https:8090 -p https:8091 -p https:8118 -p https:8123 -p https:8172 -p https:8222 -p https:8243 -p https:8280 -p https:8281 -p https:8333 -p https:8443 -p https:8500 -p https:8834 -p https:8880 -p https:8888 -p https:8983 -p https:9000 -p https:9043 -p https:9060 -p https:9080 -p https:9090 -p https:9091 -p https:9200 -p https:9443 -p https:9800 -p https:9981 -p https:12443 -p https:16080 -p https:18091 -p https:18092 -p https:20720 -p https:28017 -t 5000 -c 100 | tee "+ OUTPATH_SUBDOMAINS_WEBAPP)
os.system("httpx -l "+ OUTPATH_SUBDOMAINS_WEBAPP+" -o "+OUTPATH_SUBDOMAINS_HTTPX+" -screenshot -sc -td -location")
