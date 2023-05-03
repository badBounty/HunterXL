# HunterXL
## Bug Hunter v2

Scripts creados para encontrar bugs/vulnerabilidades haciendo tareas de ASM (attack surface management)

###Instalacion:

clonar en /tools: 
* https://github.com/wappalyzer/wappalyzer.git 
* https://github.com/maaaaz/nmaptocsv.git 
* https://github.com/punk-security/dnsReaper.git

mover /tools/puertos.txt a /tools/nmaptocsv/

### Orden de corrida:
* subdomains.py -> Genera una lista de subdominios usando amass y altdns. Genera **subdomains.txt**.
* takeover.py -> usa dnsReaper para chequear subdomain takeover y escribe sobre **vulnerabilities.txt**.
* protocols.py -> usa aquatone para obtener un listado de URLs y curl para chequear contra el status 200. Genera **subdomains-webapp.txt**.
* technologies.py -> usa wappalyzer y llena el archivo de output **technologies.txt**.
* wafdetect.py -> detecta que posee waf y que no. Genera una lista de eso y escribe sobre **vulnerabilities.txt** y **wafdetect-nowaf.txt**.
* dirnfiles.py -> Usa gau y genera una lista de endpoints para los sitios web usando **subdomains.txt**. Genera **dirnfiles.txt**.
* dirsearch.py -> Usa dirsearch y actualiza la lista de endpoints para los sitios web sin waf usando **wafdetect-nowaf.txt**. Actualiza **dirnfiles.txt**.
* openredirect.py -> usa la lista generada *dirnfiles.txt** para buscar openredirects y escribe sobre **vulnerabilities.txt**.
* clickjacking.py -> chequea el xframe y escribe sobre **vulnerabilities.txt**.
* vulnerabilities.py -> ejecuta nuclei y escribe sobre  **vulnerabilities.txt**.
* xss.py -> Busca xss usando **dirnfiles.txt** y escribe sobre **vulnerabilities.txt**.


TODOS:
* Sumar nmap con esaneo de puertos y scripts, escribir sobre vuls en caso de ser necesario
* Sumar enumeracion de buckets de s3
* Sumar analizar links para llenar la lista de endpoints
* Sumar al escaneo de vulnerabilidades Nikto, Sslscan, Testssl, owasp zap , escribir sobre vuls en caso de ser necesario
