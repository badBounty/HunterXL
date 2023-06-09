#!/bin/bash

#spidering.sh in_subdomains.txt -> spidering.txt
cd outputs

echo "------------Init katana"
katana -o katana.txt -silent -js-crawl -list $1

echo "------------Init gau"
cat $1 | gau --o  gau.txt

echo "------------Init hakrawler"
cat $1 | hakrawler -subs | tee hakrawler.txt

while read line;do echo "------------Init paramspider for: $line" && python3 ../tools/ParamSpider/paramspider.py -q --domain "$line" -o $(cat /proc/sys/kernel/random/uuid).pspider.txt --level high; done < $1
cd output
cat *.pspider.txt > ../paramspider.txt
rm  *.pspider.txt
cd ..

cat katana.txt hakrawler.txt gau.txt paramspider.txt | tee spider.txt
sort spider.txt | uniq | tee spidering.txt
#rm gau.txt
#rm hakrawler.txt
#rm katana.txt
#rm paramspider.txt
rm spider.txt

#while read line;do python3 ../tools/LinkFinder/linkfinder.py -i "$line"  -d -o cli | tee $(cat /proc/sys/kernel/random/uuid).linkf.txt; done < $1
#cat *.linkf.txt > linkfinder.txt
#rm  *.linkf.txt
