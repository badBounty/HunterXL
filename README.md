# HunterXL
## Bug Hunter v2

Scripts creados para encontrar bugs/vulnerabilidades haciendo tareas de ASM (attack surface management)

### Instalacion:

clonar en /tools: 
* https://github.com/wappalyzer/wappalyzer.git 
* https://github.com/maaaaz/nmaptocsv.git 
* https://github.com/punk-security/dnsReaper.git

### Orden de corrida:
* subdomains.py -> Genera una lista de subdominios usando <u>amass</u> y <u>altdns</u>. Genera **subdomains.txt**.
* takeover.py -> usa <u>dnsReaper</u> para chequear subdomain takeover y escribe sobre **vulnerabilities.txt**.
* protocols.py -> usa <u>aquatone</u> para obtener un listado de URLs y <u>curl</u> para chequear contra el status 200. Genera **subdomains-webapp.txt**.
* technologies.py -> usa <u>wappalyzer</u> y **subdomains-webapp.txt**. Llena el archivo de output **technologies.txt**.
* wafdetect.py -> detecta que posee waf con <u>wafw00f</u> y que no. Genera una lista de eso y escribe sobre **vulnerabilities.txt** y **wafdetect-nowaf.txt**.
* dirnfiles.py -> Usa <u>gau</u> y genera una lista de endpoints para los sitios web usando **subdomains.txt**. Genera **dirnfiles.txt**.
* dirsearch.py -> Usa <u>dirsearch</u> y actualiza la lista de endpoints para los sitios web sin waf usando **wafdetect-nowaf.txt**. Actualiza **dirnfiles.txt**.
* openredirect.py -> usa la lista generada **dirnfiles.txt** para buscar openredirects con <u>regex</u> y escribe sobre **vulnerabilities.txt**.
* clickjacking.py -> chequea el xframe con <u>curl</u> y escribe sobre **vulnerabilities.txt**.
* vulnerabilities.py -> ejecuta <u>nuclei</u> con **subdomains-webapp.txt** y escribe sobre  **vulnerabilities.txt**.
* xss.py -> Busca xss con con <u>regex</u> usando **dirnfiles.txt** y escribe sobre **vulnerabilities.txt**.

### Outputs:
* subdomains.txt -> Listado de subdominios
* subdomains-webapp.txt -> Urls
* wafdetect-nowaf.txt -> Urls sin waf
* dirnfiles.txt -> Endpoints
* vulnerabilities.txt -> Listado de vuls
* technologies.txt -> Info de tecnologias por sitio<

### TODOS:
* Sumar nmap con esaneo de puertos y scripts, escribir sobre vuls en caso de ser necesario
* Sumar enumeracion de buckets de s3
* Sumar analizar links para llenar la lista de endpoints
* Sumar al escaneo de vulnerabilidades Nikto, Sslscan, Testssl, owasp zap , escribir sobre vuls en caso de ser necesario
