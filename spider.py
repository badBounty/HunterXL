import subprocess,os

INPATH_WEBSUBDOMAINS="subdomains-webapp.txt"
SPIDER_NAME="spidering.sh"

#subprocess.run(["wget", SPIDER_WGET])
subprocess.run(["sh", SPIDER_NAME, INPATH_WEBSUBDOMAINS])
#subprocess.run(["rm", SPIDER_NAME])
