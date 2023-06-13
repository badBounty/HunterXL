import os,subprocess

import subprocess,os

INPATH_WEBSUBDOMAINS="subdomains-webapp.txt"
INPATH_NOWAF="subdomains-webapp.txt"
INPATH_SPIDERING="spidering.txt"
VUL_NAME="vulners.sh"

PINGBACK="http://pingb.in/p/78d27164f0d7b2b00ca80599dcad"

subprocess.run(["/bin/bash", VUL_NAME, INPATH_WEBSUBDOMAINS, INPATH_SPIDERING, PINGBACK, INPATH_NOWAF])
