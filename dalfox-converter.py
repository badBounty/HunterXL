import json
import csv
 
csv_file = open('dalfox.csv', 'w')
csv_writer = csv.writer(csv_file)

with open('dalfox.json') as json_file:
    data = json.load(json_file)
 
vuls = data

header_in_place=False
for vul in vuls:
    if header_in_place == False:
        header = vul.keys()
        csv_writer.writerow(header)
        header_in_place = True
        
    csv_writer.writerow(vul.values())
 
csv_file.close()