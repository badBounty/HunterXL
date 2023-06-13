#!/bin/bash

RED=$'\e[0;31m'
NC=$'\e[0m'

if ! command -v nmap &> /dev/null
then
    echo "${RED}nmap could not be found${NC}"
    exit 100
else
	echo "nmap found"
fi
if ! command -v httprobe &> /dev/null
then
    echo "${RED}httprobe could not be found${NC}"
    exit 100
else
	echo "httprobe found"
fi
if ! command -v httpx &> /dev/null
then
    echo "${RED}httpx could not be found${NC}"
    exit 100
else
	echo "httpx found"
fi
if ! command -v hakrawler &> /dev/null
then
    echo "${RED}hakrawler could not be found${NC}"
    exit 100
else
	echo "hakrawler found"
fi
if ! command -v retire  &> /dev/null
then
    echo "${RED}retire  could not be found${NC}"
    exit 100
else
	echo "retire found"
fi
if ! command -v jsfinder &> /dev/null
then
    echo "${RED}jsfinder could not be found${NC}"
    exit 100
else
	echo "jsfinder found"
fi

if ! command -v gau &> /dev/null
then
    echo "${RED}gau could not be found${NC}"
    exit 100
else
	echo "gau found"
fi

if ! command -v katana &> /dev/null
then
    echo "${RED}katana could not be found${NC}"
    exit 100
else
	echo "katana found"
fi
if ! command -v sqlmap &> /dev/null
then
    echo "${RED}sqlmap could not be found${NC}"
    exit 100
else
	echo "sqlmap found"
fi

if ! command -v qsreplace &> /dev/null
then
    echo "${RED}qsreplace could not be found${NC}"
    exit 100
else
	echo "qsreplace found"
fi

if ! command -v nikto &> /dev/null
then
    echo "${RED}nikto could not be found${NC}"
    exit 100
else
	echo "nikto found"
fi
if ! command -v testssl &> /dev/null
then
    echo "${RED}testssl could not be found${NC}"
    exit 100
else
	echo "testssl found"
fi
if ! command -v nuclei &> /dev/null
then
    echo "${RED}nuclei could not be found${NC}"
    exit 100
else
	echo "nuclei found"
fi
if ! command -v wafw00f &> /dev/null
then
    echo "${RED}wafw00f could not be found${NC}"
    exit 100
else
	echo "wafw00f found"
fi
if ! command -v jq &> /dev/null
then
    echo "${RED}jq could not be found${NC}"
    exit 100
else
	echo "jq found"
fi
if ! command -v docker &> /dev/null
then
    echo "${RED}docker could not be found${NC}"
    exit 100
else
	echo "docker found"
fi

if test -f "tools/XSStrike/xsstrike.py"
then
	echo "xsstrike.py found"
else
    echo "${RED}xsstrike.py could not be found${NC}"
    exit 100
fi

if test -f "tools/nmaptocsv/nmaptocsv.py"
then
	echo "nmaptocsv.py found"
else
    echo "${RED}nmaptocsv.py could not be found${NC}"
    exit 100
fi

if test -f "tools/ParamSpider/paramspider.py"
then
	echo "paramspider.py found"
else
    echo "${RED}paramspider.py could not be found${NC}"
    exit 100
fi

if test -f "tools/dnsReaper/main.py"
then
    echo "dnsReaper main.py found"
else
    echo "${RED}dnsReaper main.py could not be found${NC}"
    exit 100
fi

if test -f "tools/LinkFinder/linkfinder.py"
then
     echo "linkfinder.py found"
else
    echo "${RED}linkfinder.py could not be found${NC}"
    exit 100
fi
