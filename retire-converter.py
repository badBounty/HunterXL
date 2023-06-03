import json
import csv
 
csv_file = open('retire.csv', 'w')
json_file = open('retirejs.json')

headers=False
for line in json_file:
    
    if headers == False:
        head="file,component,version,vulnerabilities"
        csv_file.write(head)
        csv_file.write("\n")
        headers = True
    
    archivo_json = json.loads(line) 
    
    if len(archivo_json['data']) > 0:
        for archivo_vulnerable in archivo_json['data']:        
            csv_file.write(archivo_vulnerable['file'])
            csv_file.write(",")
            
            for result in archivo_vulnerable['results']:
                csv_file.write(result['component'])
                csv_file.write(",")
                
                csv_file.write(result['version'])
                csv_file.write(",")

                csv_file.write(json.dumps(result['vulnerabilities']).replace(",", " ")) 
                csv_file.write("\n")
 
csv_file.close()
json_file.close()