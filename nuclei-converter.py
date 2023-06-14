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
    csv_file.write("\"" + data['host'] + "\"")
    csv_file.write(",")
    
    csv_file.write("\"" + data['template'] + "\"")
    csv_file.write(",")
    
    csv_file.write("\"" + data['info']['name'] + "\"")
    csv_file.write(",")
    
    if "description" in data['info']:
       csv_file.write("\"" + data['info']['description'] + "\"")
    else:
       csv_file.write("N/A")
    csv_file.write(",")
    
    csv_file.write("\"" + data['info']['severity'] + "\"")
    csv_file.write(",")
   
     if "extracted-results" in data:
         csv_file.write("\"" + json.dumps(data['extracted-results']) + "\"")
    else:
        csv_file.write("N/A")
    csv_file.write(",")
    
    csv_file.write("\"" + data['matched-at'])    
    csv_file.write(",")
    
    if "curl-command" in data:
        csv_file.write("\"" + data['curl-command'] + "\"")
    else:
        csv_file.write("N/A")
    csv_file.write("\n")
 
csv_file.close()
json_file.close()