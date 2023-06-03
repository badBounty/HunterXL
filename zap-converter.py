import json
import csv
 
csv_file = open('zap.csv', 'a')
csv_writer = csv.writer(csv_file)

with open('zap.json') as json_file:
    data = json.load(json_file)

for sitio in data['site']:
    if len(sitio['alerts']) > 0:    
        vuls = sitio['alerts']
        for vul in vuls:
            csv_writer.writerow(vul.values())
 
csv_file.close()