import json
import csv
 
csv_file = open('nuclei.csv', 'w')
json_file = open('nuclei.json')

headers=False
for line in json_file:
    
    if headers == False:
        head="host,template,name,description,severity,extracted-results,matched-at,curl-command"
        csv_file.write(head)
        csv_file.write("\n")
        headers = True
    
    data = json.loads(line) 
    csv_file.write(data['host'])
    csv_file.write(",")
    
    csv_file.write(data['template'])
    csv_file.write(",")
    
    csv_file.write(data['info']['name'])
    csv_file.write(",")
    
    csv_file.write(data['info']['description'])
    csv_file.write(",")
    
    csv_file.write(data['info']['severity'])
    csv_file.write(",")
    
    csv_file.write(json.dumps(data['extracted-results']))
    csv_file.write(",")
    
    csv_file.write(data['matched-at'])    
    csv_file.write(",")
    
    csv_file.write(data['curl-command'])    
    csv_file.write("\n")
 
csv_file.close()
json_file.close()