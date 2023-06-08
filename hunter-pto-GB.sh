#!/bin/bash

#Run:
	#hunter-pto-BB.sh "https://www.example.com" "https://collaborator.com" "aspx,php,asp" "header=value"

#Output:
	#nmap.csv
	#retirejs.csv
	#testssl.csv
	#nikto.csv
	#zap.csv
	#Auth:
		#spidering.txt
		#dirnfiles.txt
		#nuclei.csv
		#xsstrike.txt
		#openredirect.csv
		#sqlmap.csv
		#dalfox.csv

sitio=$1
callback=$2
extensiones=$3
galletas=$4

if [ -z "${sitio}" ]; then
    echo "No se ha enviado el parametro sitio"
	echo "Usage: hunter-pto-BB.sh https://www.example.com https://collaborator.com aspx,php,asp \"galleta=valor\""
	exit
fi

if [ -z "${callback}" ]; then
    echo "No se ha enviado el parametro callback"
	echo "Usage: hunter-pto-BB.sh https://www.example.com https://collaborator.com aspx,php,asp \"galleta=valor\""
	exit
fi

if [ -z "${extensiones}" ]; then
    echo "No se ha enviado el parametro extensiones, las extensiones por defecto incluidas son zip,bak,log,xml"
	echo "Usage: hunter-pto-BB.sh https://www.example.com https://collaborator.com aspx,php,asp \"galleta=valor\""
	exit
fi


if [ -z "${galletas}" ]; then
    echo "No se ha enviado el parametro extensiones, las extensiones por defecto incluidas son zip,bak,log,xml"
	echo "Usage: hunter-pto-BB.sh https://www.example.com https://collaborator.com aspx,php,asp \"galleta=valor\""
	exit
fi

#creamos, puede fallar si existe en ese caso no nos interesa porque igual escribe ahi
mkdir outputs
cd outputs

#nmap scan
echo ------------Init nmap------------
host=$(echo $sitio | awk -F[/:] '{print $4}')
sudo nmap --top-ports 1000 --open --script vuln,default,banner,ftp-anon,ftp-bounce,ftp-syst,ssh-auth-methods,sshv1,telnet-ntlm-info,dns-cache-snoop,dns-recursion -sSV -Pn "$host" -oA "nmap"

python3 ../tools/nmaptocsv/nmaptocsv.py -S -x "nmap.xml" -o "nmap.csv"

#dirsearch
echo ------------Init dirsearch------------
wget -nc https://gist.githubusercontent.com/jhaddix/b80ea67d85c13206125806f0828f4d10/raw/c81a34fe84731430741e0463eb6076129c20c4c0/content_discovery_all.txt
dirsearch "$sitio" -w "content_discovery_all.txt" -o "dirnfiles.txt" --deep-recursive --force-recursive -e "zip,bak,log,xml,$extensiones" --format=csv -t 60
rm 
#spidering

echo "------------Init katana------------"
katana -o katana.txt -silent -js-crawl -u "$sitio"

echo "------------Init gau------------"
echo "$sitio" | gau --o  gau.txt

echo "------------Init hakrawler"
echo "$sitio" | hakrawler -subs | tee hakrawler.txt

echo ------------"Init paramspider------------"
python3 ../tools/ParamSpider/paramspider.py -q --domain "$sitio" -o paramspider.txt --level high
mv ./output/paramspider.txt ./paramspider.txt
rm -r output

#unificar resultados del spidering
cat katana.txt hakrawler.txt gau.txt paramspider.txt | tee spider.txt
sort spider.txt | uniq | tee spidering.txt
rm gau.txt
rm hakrawler.txt
rm katana.txt
rm paramspider.txt
rm spider.txt

#jsfinder
echo "--------------Init jsfinder------------"

folder=$(echo "$sitio" |  sed -r 's/https:\/\///g'  |  sed -r 's/http:\/\///g'  |  sed -r 's/HTTPS:\/\///g'  |  sed -r 's/HTTP:\/\///g')

mkdir "$folder"

echo "$sitio" | jsfinder -read -s -o ./"$sitio"/js-list.txt

cd "$folder"

while read line; do wget "$line"; done < ./js-list.txt

#rm js-list.txt

echo "-----------Init retire-----------"
retire --outputformat json --outputpath ../retirejs.json

cd ..
#rm -r ./"$folder"

python3 ../retire-converter.py
rm retirejs.json

# xsstrike
echo "------------Init xsstrike------------"
python3 ../tools/XSStrike/xsstrike.py -u "$sitio" --crawl -l 3 --skip | tee xsstrike.txt

#creamos params
echo "------------Creating params------------"
cat spidering.txt | grep "=" | sort | uniq  | qsreplace FUZZ | tee raw_params.txt
cat raw_params.txt | grep -E -i "$sitio" | tee params.txt

#SSRF & open redirect. Check the blind payload to test SSRF. Check the file openredirect.txt to check vuls.
echo "------------Init openredirec test------------"
echo "start,vulnerable,end" > openredirect.csv
cat params.txt | qsreplace $callback | sort | uniq | httpx -silent -status-code -location -json -fr | jq -r '. | .url + "," + .final_url' | awk -F, '{ #print $1==$2?$1 "," $2 ",SI": $1 "," $2 ",NO" }' | grep "SI" >> openredirect.csv

#SqlMap
echo "------------Init sqlmap------------"
sqlmap --banner --batch --level=1 --results-file=sqlmap.csv -m params.txt --ignore-redirects

#dalfox
echo "------------Init dalfox------------"
wget -nc https://raw.githubusercontent.com/danielmiessler/SecLists/master/Fuzzing/XSS/XSS-Jhaddix.txt
echo "<script>alert(1)</script>" >> XSS-Jhaddix.txt
dalfox file params.txt --waf-evasion --output dalfox.json --format json --skip-mining-all --only-custom-payload --custom-payload ./XSS-Jhaddix.txt
rm XSS-Jhaddix.txt

python3 ../dalfox-converter.py
rm dalfox.json

#nuclei
echo "------------Init nuclei------------"
nuclei -u "$sitio" -j -o nuclei.json -t "$HOME/nuclei-templates"
python3 ../nuclei-converter.py
rm nuclei.json

#Testssl
echo "--------------Init testssl--------------"
testssl --csvfile testssl.csv "$sitio" 

#Nikto
echo "--------------Init nikto--------------"
nikto -maxtime 15m -host "$sitio" -Format csv -output "./nikto.csv"

#ZAP
CSVHEADERS=1
touch zap-runner.sh

echo "echo \"--------------Init zap--------------\"" >> zap-runner.sh

#This can be run from WSL or a real Linux
if [[ $(cat /proc/version) == *"WSL"* ]]; then
    echo "docker.exe run -v \"$(wslpath -w .)\":/zap/wrk owasp/zap2docker-stable zap-baseline.py -t $sitio -s -j -T 10 -m 5 -a -J  zap.json" >> zap-runner.sh
else
    echo "docker run -v $(pwd):/zap/wrk owasp/zap2docker-stable zap-baseline.py -t $sitio -s -j -T 10 -m 5 -a -J zap.json"  >> zap-runner.sh
fi

if [ $CSVHEADERS -eq 1 ]; then
    echo "echo --------------Init CSV Zap"  >> zap-runner.sh
    echo "python3 ../zap-converter-init.py" >> zap-runner.sh
    CSVHEADERS=0
fi

echo "echo --------------Init Converter JSON To CSV--------------" >> zap-runner.sh
echo "python3 ../zap-converter.py" >> zap-runner.sh
echo "rm zap.json" >> zap-runner.sh		

sh zap-runner.sh
rm zap-runner.sh