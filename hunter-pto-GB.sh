#!/bin/bash

#Run:
	#hunter-pto-BB.sh "https://www.example.com" "https://collaborator.com" "aspx,php,asp" "true/false" "Cookie: galleta=valor; galleta2=valor"
	#hunter-pto-BB.sh "https://www.example.com" "https://collaborator.com" "aspx,php,asp"  "true/false" "Authorization: Bearer JWT"
	#hunter-pto-BB.sh "url site" "url callback" "extension" "force waf" "auth headers"

#Output:
	#nmap.csv
	#retirejs.csv
	#testssl.csv
	#nikto.csv
	#zap.csv
	#Auth:
		#dirnfiles.txt
		#nuclei.csv
		#xsstrike.txt
		#spidering.txt
		#openredirect.csv
		#sqlmap.csv
		#dalfox.csv

sitio=$1
callback=$2
extensiones=$3
forcewaf=$4
galletas=$5

if [ -z "${sitio}" ]; then
    echo "No se ha enviado el parametro sitio"
	echo "Usage: hunter-pto-BB.sh https://www.example.com https://collaborator.com \"aspx,php,asp\" \"Cookie: galleta=valor\""
	exit
fi

if [ -z "${callback}" ]; then
    echo "No se ha enviado el parametro callback"
	echo "Usage: hunter-pto-BB.sh https://www.example.com https://collaborator.com \"aspx,php,asp\" \"Cookie: galleta=valor\""
	exit
fi

if [ -z "${extensiones}" ]; then
    echo "No se ha enviado el parametro extensiones, las extensiones por defecto incluidas son zip,bak,log,xml"
	echo "Usage: hunter-pto-BB.sh https://www.example.com https://collaborator.com \"aspx,php,asp\" \"Cookie: galleta=valor\""
	exit
fi

if [ -z "${wafcheck}" ]; then
    echo "No se ha enviado el parametro waf check seleccione true o false"
	echo "Usage: hunter-pto-BB.sh https://www.example.com https://collaborator.com \"aspx,php,asp\" \"true\" "
	exit
fi

if [ -z "${galletas}" ]; then
    echo "No se ha enviado el parametro extensiones, las extensiones por defecto incluidas son zip,bak,log,xml"
	echo "Usage: hunter-pto-BB.sh https://www.example.com https://collaborator.com \"aspx,php,asp\" \"Cookie: galleta=valor\""
	exit
fi

WAF=0
if [[  "$wafcheck" == "true" ]]
	then
		out=$(wafw00f "$sitio" | grep -e 'No WAF detected' -e 'was not detected' -c)
		if [ $out -eq 1 ]
		then
			echo "No WAF detected in $sitio"
		else
			echo "The site $sitio is behind WAF"
			wafw00f "$sitio"
			WAF=1
		fi
else
	echo "WAF check skipped, all test will be run"
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
if [ $WAF -eq 0 ]
	then
		echo "------------Init dirsearch------------"
		wget -nc https://gist.githubusercontent.com/jhaddix/b80ea67d85c13206125806f0828f4d10/raw/c81a34fe84731430741e0463eb6076129c20c4c0/content_discovery_all.txt
		dirsearch -u "$sitio" -w "$(pwd)/content_discovery_all.txt" -o "$(pwd)/dirnfiles.txt" --deep-recursive --force-recursive -e "zip,bak,log,xml,$extensiones" --format=csv -t 60 -H "$galletas"
		rm content_discovery_all.txt
	else
		echo "------------WAF Detected dirsearch skipped------------"
fi

#spidering
echo "------------Init katana------------"
katana -o katana.txt -silent -js-crawl -u "$sitio" -H "$galletas"

echo "------------Init gau------------"
echo "$sitio" | gau --o  gau.txt

echo "------------Init hakrawler"
echo "$sitio" | hakrawler -subs -h "$galletas" | tee hakrawler.txt

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

echo "$sitio" | jsfinder -read -s -o ./"$folder"/js-list.txt

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
if [ $WAF -eq 0 ]
	then
		echo "------------Init xsstrike------------"
		python3 ../tools/XSStrike/xsstrike.py -u "$sitio" --crawl -l 3 --skip --headers "$galletas" | tee xsstrike.txt
	else
		echo "------------WAF Detected xsstrike skipped------------"
fi

#creamos params
echo "------------Creating params------------"
cat spidering.txt | grep "=" | sort | uniq  | qsreplace FUZZ | tee raw_params.txt
cat raw_params.txt | grep -E -i "$sitio" | tee params.txt

#SSRF & open redirect. Check the blind payload to test SSRF. Check the file openredirect.txt to check vuls.
echo "------------Init openredirec test------------"
echo "start,vulnerable,end" > openredirect.csv
cat params.txt | qsreplace $callback | sort | uniq | httpx -H "$galletas" -silent -status-code -location -json -fr | jq -r '. | .url + "," + .final_url' | awk -F, '{ print $1==$2?$1 "," $2 ",SI": $1 "," $2 ",NO" }' | grep "SI" >> openredirect.csv

#SqlMap
if [ $WAF -eq 0 ]
	then
		echo "------------Init sqlmap------------"
		sqlmap --banner --batch --level=1 --results-file=sqlmap.csv -m params.txt --ignore-redirects --headers="$galletas"
	else
		echo "------------WAF Detected SqlMap skipped------------"
fi

#dalfox
if [ $WAF -eq 0 ]
	then
		echo "------------Init dalfox------------"
		wget -nc https://raw.githubusercontent.com/danielmiessler/SecLists/master/Fuzzing/XSS/XSS-Jhaddix.txt
		echo "<script>alert(1)</script>" >> XSS-Jhaddix.txt
		dalfox file params.txt --waf-evasion --output dalfox.json --format json --skip-mining-all --only-custom-payload --custom-payload ./XSS-Jhaddix.txt -H "$galletas"
		rm XSS-Jhaddix.txt
		python3 ../dalfox-converter.py
		rm dalfox.json
	else
		echo "------------WAF Detected dalfox skipped------------"
fi

python3 ../dalfox-converter.py
rm dalfox.json

#nuclei
echo "------------Init nuclei------------"
nuclei -u "$sitio" -j -o nuclei.json -t "$HOME/nuclei-templates" -H "$galletas"
python3 ../nuclei-converter.py
rm nuclei.json

#Testssl
echo "--------------Init testssl--------------"
testssl --csvfile testssl.csv "$sitio" 

#Nikto
if [ $WAF -eq 0 ]
	then
		echo "--------------Init nikto--------------"
		nikto -maxtime 15m -host "$sitio" -Format csv -output "./nikto.csv"
	else
		echo "------------WAF DetectedniktoZAP skipped------------"
fi

#ZAP
if [ $WAF -eq 1 ]
	then
		echo "--------------Init zap--------------"
		sudo docker run -v $(pwd):/zap/wrk owasp/zap2docker-stable zap-baseline.py -t $sitio -s -j -T 10 -m 5 -a -J zap.json
		echo "--------------Init CSV Zap--------------"
		python3 ../zap-converter-init.py
		echo "--------------Init Converter JSON To CSV--------------"
		python3 ../zap-converter.py
	else
		echo "------------WAF Detected ZAP skipped------------"
		exit
fi
