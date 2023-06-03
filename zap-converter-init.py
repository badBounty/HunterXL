import json
import csv
 
csv_file = open('zap.csv', 'w')
csv_writer = csv.writer(csv_file)

with open('zap.json') as json_file:
    data = json.load(json_file)
 
vuls = data['site'][0]['alerts']

for vul in vuls:
        header = vul.keys()
        csv_writer.writerow(header)
        break

csv_file.close()