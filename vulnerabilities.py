import os,subprocess

import subprocess,os

INPATH_WEBSUBDOMAINS="subdomains-webapp.txt"
INPATH_SPIDERING="spidering.txt"

WGET="https://gist.github.com/maxpowersi/4c8282e16ac5149acf1b7409aa44b511/raw/a0bf379ac1a65805fca00aacfe689e5d5e5a0302/vulners.sh"
VUL_NAME="vulners.sh"

PINGBACK="http://pingb.in/p/78d27164f0d7b2b00ca80599dcad"

subprocess.run(["wget", WGET])
subprocess.run(["sh", VUL_NAME, INPATH_WEBSUBDOMAINS, INPATH_SPIDERING, PINGBACK])
subprocess.run(["rm", VUL_NAME])

