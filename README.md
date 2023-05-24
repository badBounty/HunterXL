# HunterXL

## Instalacion:
Se debe clonar este repositorio. Luego crear una carpeta "tools"

### Clonar e instalar en /tools: 
* https://github.com/wappalyzer/wappalyzer.git 
* https://github.com/maaaaz/nmaptocsv.git 
* https://github.com/punk-security/dnsReaper.git
* https://github.com/GerbenJavado/LinkFinder.git
* https://github.com/devanshbatham/ParamSpider.git

### Instalar en path:
* https://github.com/tomnomnom/httprobe
* https://github.com/projectdiscovery/httpx
* https://github.com/hakluke/hakrawler

### Ejecutar
Posicionarse en la carpeta HunterXL. Esta carpeta debe contener una carpeta denominada inputs. Todos los archivos de salida se creearan dentro de la carpeta outputs.

## Recon:
* subdomains.py -> Genera una lista de subdominios usando amass y altdns. In: domains.txt - Out: **subdomains.txt**.
* takeover.py -> usa dnsReaper para chequear subdomain takeover. In: **subdomains.txt** - Out: **vulnerabilities.txt**.
* protocols.py -> usa httprobe para obtener un listado de URLs. Luego usa httpx para sacar screenshots y response. In: **subdomains.txt** - Out: **subdomains-webapp.txt** y **httpx.txt** asi como folders **output/screenshots** y **output/response**

### Inputs:
* domains.txt -> Listado de dominios. **El archivo debe existir dentro de la carpeta inputs.**

### Outputs:
*Nota: Estos archivos se crean en la carpeta outputs.
* subdomains.txt -> Listado de subdominios.
* takeover.txt -> Listado de vuls de takeover.
* subdomains-webapp.txt -> Urls.
* output/screenshots ->  Captura de pantalla de los render web.
* output/response -> Respuestas HTTP de los sitios web.
* httpx.txt -> Resultados de los request a los sitios vivos, su estado de respuesta.

---

## External:
* portscan.py -> Ejecuta nmap tcp custom con scripts y usa nmaptocsv para generar el resultado. In: **subdomains.txt** - Out: **ports.csv**.

### Inputs:
* subdomains.txt.txt ->  Listado de subdominios. **El archivo debe existir dentro de la carpeta outputs.**

### Outputs:
*Nota: Si la carpeta de output configurada no existe se crea automaticamente.
* ports.csv -> Resultado de nmap tcp con IPs puertos abuertos y los resultados de los scripts de nmap.

---

## Web App:
* technologies.py -> usa wappalyzer. In: **subdomains-webapp.txt** - Out: **technologies.txt**.
* wafdetect.py -> detecta que posee waf con wafw00f y que no. In: **subdomains-webapp.txt** - Out: **wafdetect-nowaf.txt**.
* spider.py -> Ejecuta paramspider, linkfinder y hakrawler. In: **subdomains-webapp.txt** - Out: **paramspider.txt**, **linkfinder.txt** y **hakrawler.txt**.
* contdiscovery.py -> Usa gau y genera una lista de endpoints para los sitios web. Dps Usa dirsearch y actualiza la lista de endpoints para los sitios web sin waf. In: **subdomains-webapp.txt** y **wafdetect-nowaf.txt** - Out: **dirnfiles.txt**.
* vulnerabilities.py ->
  * Ejecuta Nuclei. In: **subdomains-webapp.txt** - Out: **nuclei.json**.
  * Ejecuta Dalfox. In: **paramspider** - Out: **dalfox.txt**.
  * Ejecuta OWASP ZAP. In: **subdomains-webapp.txt** - Out: **RANDOM.zap.json**
  * Ejecuta Nikto. In: **subdomains-webapp.txt** - Out: **RANDOM.nikto.xml**
  * Ejecuta Dastardly. In: **subdomains-webapp.txt** - Out: **dastardly.csv**
  * Ejecuta Testssl. In: **subdomains-webapp.txt** - Out: **RANDOM.testssl.csv** 
* defect_uploader.py -> Sube a defect dojo usando los resultados de Zap, Nikto, Testssl y Nuclei. Se debe configurar dentro las variables host y api_key. Borra los archivos de las vuls subidas.

### Inputs:
* subdomains-webapp.txt -> Urls. **El archivo debe existir dentro de la carpeta outputs.**

### Outputs:
* wafdetect-nowaf.txt -> Urls sin waf.
* dirnfiles.txt -> Endpoints.
* technologies.txt -> Info de tecnologias por sitio.
* dalfox.txt -> Resultado de dalfox con posibles XSS
* hakrawler.txt -> Resultado de varios endpoins resultado de crawlear el sitio.
* linkfinder.txt -> Resultado de endpoins de los archivos JS.
* paramspider.txt -> Resultado del crawler. Se tienen varios endpoints y los valores de los parametros salen con el valor FUZZ
* dastardly.csv -> Resultado de Dastardly, todos concatenados en formato CSV.
* RANDOM.zap.json -> Resultado de OWASP Zap, los nombres de los archivos son random.
* RANDOM.nikto.xml -> Resultado de Nikto, los nombres de los archivos son random.
* RANDOM.testssl.csv -> Resultado de Testssl, los nombres de los archivos son random.
* nuclei.json -> Salida de nuclei con posibles vuls.

---

## TODO:
* Crear aws.py para enumerar s3 y automatizar otras cosas.
* Sumar al vulnerabilities.py algo de SSRF y SQLi
* external.py -> Ejecuta ncrack para FTP, Telnet y SSH. Para SSH ejecuta ssh-audit.py y sshUsernameEnumExploit.py. In: **ports.csv**.
