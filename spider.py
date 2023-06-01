import subprocess,os

INPATH_WEBSUBDOMAINS="outputs/subdomains-webapp.txt"
SPIDER_WGET="https://gist.githubusercontent.com/maxpowersi/8b6ca5a39ed5d87580a303195f92c8d8/raw/e4c7fcfa53ea624f198e0b37f47d12aed49b6f94/spidering.sh"
SPIDER_NAME="spidering.sh"

subprocess.run(["wget", SPIDER_WGET])
subprocess.run(["sh", SPIDER_NAME, INPATH_WEBSUBDOMAINS])
subprocess.run(["rm", SPIDER_NAME])
