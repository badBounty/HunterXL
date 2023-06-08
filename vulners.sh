#!/bin/bash

#vulners.sh  subdomains-webapp.txt spidering.txt http://pingb.in/p/03e8fef1e7d875c304b342e0b02
#->
#retirejs.csv
#xsstrike.txt
#openredirect.csv
#sqlmap.csv
#dalfox.csv
#nuclei.csv
#testssl.csv
#nikto.csv
#zap.csv

websites=$1

#La ruta principal es outputs.
cd outputs

#ZAP
CSVHEADERS=1
touch zap-runner.sh
while read subdomainzap; do
        echo "echo \"--------------Init ZAP for: $subdomainzap\"" >> zap-runner.sh
        
		#This can be run from WSL or a real Linux
		if [[ $(cat /proc/version) == *"WSL"* ]]; then
			echo "docker.exe run -v \"$(wslpath -w .)\":/zap/wrk owasp/zap2docker-stable zap-baseline.py -t $subdomainzap -s -j -T 10 -m 5 -a -J  zap.json" >> zap-runner.sh
        else
			echo "sudo docker run -v $(pwd):/zap/wrk owasp/zap2docker-stable zap-baseline.py -t $subdomainzap -s -j -T 10 -m 5 -a -J zap.json"  >> zap-runner.sh
        fi

        if [ $CSVHEADERS -eq 1 ]; then
			echo "echo --------------Init CSV Zap"  >> zap-runner.sh
			echo "python3 ../zap-converter-init.py" >> zap-runner.sh
			CSVHEADERS=0
        fi
		
		echo "echo --------------Init Converter JSON To CSV for: $subdomainzap" >> zap-runner.sh
        echo "python3 ../zap-converter.py" >> zap-runner.sh
		echo "rm zap.json" >> zap-runner.sh		
done < ./"$websites"

sh zap-runner.sh
rm zap-runner.sh

#Buscamos vuls en archivos JS
while read subdomain; do

    echo "--------------Init jsfinder for: $subdomain"

    folder=$(echo "$subdomain" |  sed -r 's/https:\/\///g'  |  sed -r 's/http:\/\///g'  |  sed -r 's/HTTPS:\/\///g'  |  sed -r 's/HTTP:\/\///g')

    mkdir "$folder"

    echo "$subdomain" | jsfinder -read -s -o ./"$folder"/js-list.txt

    cd "$folder"

    while read line; do wget "$line"; done < ./js-list.txt

    #rm js-list.txt

	echo "--------------Init retire for: $subdomain"
	retire --outputformat json --outputpath ../"$folder".retire.txt

	cd ..
	#rm -r ./"$folder"

done < ./"$websites"
cat *.retire.txt > retirejs.json
rm *.retire.txt
python3 ../retire-converter.py
rm retirejs.json

#ejecutamos xsstrike
echo "--------------Init xsstrike"
python3 ../tools/XSStrike/xsstrike.py --seeds $1 --crawl -l 3 --skip | tee xsstrike.txt

#creamos params
echo "--------------Creating params"
cat $2 | grep "=" | sort | uniq  | qsreplace FUZZ | tee params_raw.txt
while read line; do echo "^$line" >> tmp_grep.txt ; done < $1
cat params_raw.txt | grep -E -i "^$(paste -s -d "|" tmp_grep.txt)" | tee params.txt
rm tmp_grep.txt

#test de SSRF y Open Redirect. Check the blind payload to test SSRF. Check the file openredirect.txt to check vuls.
echo "--------------Init openredirec test"
echo "start,vulnerable,end" > openredirect.csv
cat params.txt | qsreplace $3 | sort | uniq | httpx -silent -status-code -location -json -fr | jq -r '. | .url + "," + .final_url' | awk -F, '{ #print $1==$2?$1 "," $2 ",SI": $1 "," $2 ",NO" }' | grep "SI" >> openredirect.csv

#SqlMap
echo "--------------Init sqlmap"
sqlmap --banner --batch --level=1 --results-file=sqlmap.csv -m params.txt --ignore-redirects

#dalfox
echo "--------------Init dalfox"
wget -nc https://raw.githubusercontent.com/danielmiessler/SecLists/master/Fuzzing/XSS/XSS-Jhaddix.txt
echo "<script>alert(1)</script>" >> XSS-Jhaddix.txt
dalfox file params.txt --waf-evasion --output dalfox.json --format json --skip-mining-all --only-custom-payload --custom-payload ./XSS-Jhaddix.txt
rm XSS-Jhaddix.txt

python3 ../dalfox-converter.py
rm dalfox.json

#Nuclei
echo "--------------Init nuclei"
nuclei -l ./"$websites" -j -o nuclei.json -t "$HOME/nuclei-templates"
python3 ../nuclei-converter.py
rm nuclei.json

#Testssl
echo "--------------Init testssl"
cat "$websites" | grep "^https" | tee https.txt
testssl -iL ./https.txt --csvfile testssl.csv
rm https.txt

#Nikto
echo "--------------Init nikto"
while read line; do nikto -maxtime 15m -host "$line" -Format csv -output ./$(cat /proc/sys/kernel/random/uuid).nik; done < ./"$websites"
cat *.nik > nikto.csv
rm *.nik