import os,subprocess

import subprocess,os

INPATH_WEBSUBDOMAINS="subdomains-webapp.txt"
INPATH_SPIDERING="spidering.txt"

WGET="https://gist.githubusercontent.com/maxpowersi/4c8282e16ac5149acf1b7409aa44b511/raw/a68b7044114c63e4b2712c50bf13bd8d6f568b87/vulners.sh"
VUL_NAME="vulners.sh"

PINGBACK="http://pingb.in/p/78d27164f0d7b2b00ca80599dcad"

subprocess.run(["wget", WGET])
subprocess.run(["sh", VUL_NAME, INPATH_WEBSUBDOMAINS, INPATH_SPIDERING, PINGBACK])
subprocess.run(["rm", VUL_NAME])

