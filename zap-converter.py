import json
import csv
 
csv_file = open('zap.csv', 'a')
csv_writer = csv.writer(csv_file)

with open('zap.json') as json_file:
    data = json.load(json_file)
 
vuls = data['site'][0]['alerts']

for vul in vuls:
    csv_writer.writerow(vul.values())
 
csv_file.close()