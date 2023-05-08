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
* xss.py -> Busca xss con con <u>regex</u> usando **dirnfiles.txt** y escribe sobre **vulnerabilities.txt**.
* vulnerabilities.py -> ejecuta <u>nuclei</u> con **subdomains-webapp.txt**.

### Outputs:
* subdomains.txt -> Listado de subdominios.
* subdomains-webapp.txt -> Urls.
* wafdetect-nowaf.txt -> Urls sin waf.
* dirnfiles.txt -> Endpoints.
* vulnerabilities.txt -> Listado de vuls de takeover, wafdetect, openredirect, clickjacking y xss.
* technologies.txt -> Info de tecnologias por sitio.
* nuclei.json -> Salida de nuclei.
* aquatone -> Salida de aquatone con screenshots.

### TODOS:
* Vulnerabilities no tienen que borrar los outputs de las tools, y tampoco llenar el vuls.txt
* Dejar las screenshot de aquatone
* Sumar nmap con escaneo de puertos y scripts en un portscanner.py. Guardar la salida de nmap en xml y ademas convertirla a csv con nmaptocsv
* Sumar tool de ssl a vulnerabilities testssl y sslscan. Dejar los outputs.
* Sumar al escaneo de vulnerabilidades nikto, owasp zap ,dastardly con contenedores.
* Una vez que este todo ejecutando lo anterior bien, generar un script subir_resultados.py que suba todos los outputs a defectdojo.
* Sumar enumeracion de buckets de s3 un s3.py luego del subdomains.py. Generar un output s3.txt
* Sumar analizar links para llenar la lista de endpoints, crear un link.py y que los links se sume a dirnfiles.txt
