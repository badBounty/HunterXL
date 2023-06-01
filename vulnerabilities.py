import os,subprocess

import subprocess,os

INPATH_WEBSUBDOMAINS="subdomains-webapp.txt"
INPATH_SPIDERING="spidering.txt"

WGET="https://gist.githubusercontent.com/maxpowersi/4c8282e16ac5149acf1b7409aa44b511/raw/07c0e963fee46cc7cfc45132c5791d2aad24bf62/vulners.sh"
VUL_NAME="vulners.sh"

PINGBACK="http://pingb.in/p/78d27164f0d7b2b00ca80599dcad"

subprocess.run(["wget", WGET])
subprocess.run(["sh", VUL_NAME, INPATH_WEBSUBDOMAINS, INPATH_SPIDERING, PINGBACK])
subprocess.run(["rm", VUL_NAME])

