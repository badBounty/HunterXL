# HunterXL
## Bug Hunter v2

Scripts creados para encontrar bugs/vulnerabilidades haciendo tareas de ASM (attack surface management)

###Instalacion:

clonar: 
* https://github.com/wappalyzer/wappalyzer.git 
* https://github.com/maaaaz/nmaptocsv.git 
* https://github.com/punk-security/dnsReaper.git

mover: 
* puertos.txt -> nmaptocsv/

### Orden de corrida:
* subdomains.py -> Genera una lista de subdominios usando amass y altdns
* takeover.py -> usa dnsReaper para chequear subdomain takeover y escribe sobre vuls.txt
* protocols.py -> usa aquatone para obtener un listado de URLs
* wafdetect.py -> detecta que posee waf y que no. Genera una lista de eso y escribe sobre vuls.txt
* dirnfiles.py -> Usa gau y genera una lista de endpoints para los sitios web sin waf
* dirsearch.py -> Usa dirsearch y actualiza la lista de endpoints para los sitios web sin waf
* openredirect.py -> usa la lista generada para buscar openredirects y escribe sobre vuls.txt
* clickjacking.py -> chequea el xframe y escribe sobre vuls.txt
* vulnerabilities.py -> ejecuta nuclei y escribe sobre vuls.txt
* xxs.py


TODOS:
* Sumar nmap con esaneo de puertos y scripts, escribir sobre vuls en caso de ser necesario
* Sumar enumeracion de buckets de s3
* Sumar analizar links para llenar la lista de endpoints
* Sumar al escaneo de vulnerabilidades Nikto, Sslscan, Testssl, Wappalyzer y owasp zap , escribir sobre vuls en caso de ser necesario
