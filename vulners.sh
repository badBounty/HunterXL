#!/bin/bash

#vulners.sh  subdomains-webapp.txt spidering.txt http://pingb.in/p/03e8fef1e7d875c304b342e0b02
#->
#openredirect.csv
#sqlmap.csv
#testssl.csv
#nikto.csv
#zap.csv
#nuclei.csv
#retirejs.csv
#dalfox.csv
#xsstrike.txt

#Buscamos vuls en archivos JS

websites=$1

cd outputs

while read subdomain; do

	echo "--------------Init jsfinder for: $subdomain"

	folder=$(echo "$subdomain" |  sed -r 's/https:\/\///g'  |  sed -r 's/http:\/\///g'  |  sed -r 's/HTTPS:\/\///g'  |  sed -r 's/HTTP:\/\///g')

        mkdir "$folder"

        echo "$subdomain" | jsfinder -read -s -o ./"$folder"/js-list.txt

        cd "$folder"

        while read line; do wget "$line"; done < ./js-list.txt

        rm js-list.txt

	echo "--------------Init retire for: $subdomain"

        retire --outputformat json --outputpath ../"$folder".retire.txt

        cd ..

        rm -r ./"$folder"

done < ./"$websites"

cat *.retire.txt > retirejs.csv

rm *.retire.txt


#-------------------------

#ejecutamos xsstrike
echo "--------------Init xsstrike"
python3 ../tools/XSStrike/xsstrike.py --seeds $1 --crawl -l 3 --skip | tee xsstrike.txt

#creamos params
echo "--------------Creating params"
cat $2 | grep "=" | sort | uniq  | qsreplace FUZZ | tee params.txt
while read line; do echo "^$line" >> tmp_grep.txt ; done < $1
cat params.txt | grep -E -i "^$(paste -s -d "|" tmp_grep.txt)" | tee params.txt
rm tmp_grep.txt

#test de SSRF y Open Redirect. Check the blind payload to test SSRF. Check the file openredirect.txt to check vuls.
echo "--------------Init openredirec test"
echo "start,vulnerable,end" > openredirect.csv
cat params.txt | qsreplace $3 | sort | uniq | httpx -silent -status-code -location -json -fr | jq -r '. | .url + "," + .final_url' | awk -F, '{ print $1==$2?$1 "," $2 ",SI": $1 "," $2 ",NO" }' | grep "SI" >> openredirect.csv

#SqlMap
echo "--------------Init sqlmap"
sqlmap --banner --batch --level=3 --results-file=sqlmap.csv -m params.txt --ignore-redirects

#dalfox
echo "--------------Init dalfox"
wget -nc https://raw.githubusercontent.com/danielmiessler/SecLists/master/Fuzzing/XSS/XSS-Jhaddix.txt
echo "<script>alert(1)</script>" >> XSS-Jhaddix.txt
dalfox file params.txt --waf-evasion --output dalfox.csv --format json --skip-mining-all --only-custom-payload --custom-payload ./XSS-Jhaddix.txt
rm XSS-Jhaddix.txt

#borramos params
rm params.txt

#Nuclei
echo "--------------Init nuclei"
nuclei -l ./"$websites" -j nuclei.csv -t "$HOME/nuclei-templates"

#Testssl
echo "--------------Init testssl"
testssl -iL ./"$websites" --csvfile testssl.csv

#Nikto
echo "--------------Init nikto"
while read line; do nikto -maxtime 30m -host "$line" -Format csv -output ./$(cat /proc/sys/kernel/random/uuid).nik; done < ./"$websites"
cat *.nik > nikto.csv
rm *.nik

#ZAP
CSVHEADERS=0
while read subdomain; do

	echo "--------------Init ZAP for: $subdomain"

	if [[ $(cat /proc/version) == *"WSL"* ]]; then 
		docker.exe run -v $(wslpath -w .):/zap/wrk owasp/zap2docker-stable zap-baseline.py -t "$subdomain" -s -j -T 10 -m 5 -a -J zap.json
	else
	docker run -v $(pwd):/zap/wrk owasp/zap2docker-stable zap-baseline.py -t "$subdomain" -s -j -T 10 -m 5 -a -J zap.json
	fi

	if [ $CSVHEADERS -eq 1 ] then
		echo "--------------Init CSV Zap"
		python3 ../zap-converter-init.py
		CSVHEADERS=1
	#fi

	python3 ../zap-converter.py

	rm zap.json

done < ./"$websites"

#Volvemos a la carpeta del repositorio
cd ..
