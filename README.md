# HunterXL
## Bug Hunter v2

Scripts creados para encontrar bugs/vulnerabilidades haciendo tareas de ASM (attack surface management)

### Instalacion:

Clonar e instalar en /tools: 
* https://github.com/wappalyzer/wappalyzer.git 
* https://github.com/maaaaz/nmaptocsv.git 
* https://github.com/punk-security/dnsReaper.git
* https://github.com/GerbenJavado/LinkFinder.git
* https://github.com/devanshbatham/ParamSpider.git

Instalar en path:
* https://github.com/tomnomnom/httprobe
* https://github.com/projectdiscovery/httpx
* https://github.com/hakluke/hakrawler

### Orden de ejecucion:
* subdomains.py -> Genera una lista de subdominios usando amass y altdns. Genera **subdomains.txt**.
* takeover.py -> usa dnsReaper para chequear subdomain takeover. In: **subdomains.txt** - Out: **vulnerabilities.txt**.
* protocols.py -> usa httprobe para obtener un listado de URLs. Luego usa httpx para sacar screenshots y response. In: **subdomains.txt** - Out: **subdomains-webapp.txt** y **httpx.txt** asi como folders **output/screenshots** y **output/response**
* technologies.py -> usa wappalyzer. In: **subdomains-webapp.txt** - Out: **technologies.txt**.
* wafdetect.py -> detecta que posee waf con wafw00f y que no. In: **subdomains-webapp.txt** - Out: **wafdetect-nowaf.txt**.
* spider.py -> Ejecuta paramspider, linkfinder y hakrawler. In: **subdomains-webapp.txt** - Out: **paramspider.txt**, **linkfinder.txt** y **hakrawler.txt**.
* contdiscovery.py -> Usa gau y genera una lista de endpoints para los sitios web. Dps Usa dirsearch y actualiza la lista de endpoints para los sitios web sin waf. In: **subdomains.txt** y **wafdetect-nowaf.txt** - Out: **dirnfiles.txt**.
* vulnerabilities.py ->
  * Ejecuta Nuclei. In: **subdomains-webapp.txt** - Out: **nuclei.json**.
  * Ejecuta Dalfox. In: **paramspider** - Out: **dalfox.txt**.
  * Ejecuta OWASP ZAP. In: **subdomains-webapp.txt** - Out: **RANDOM.zap.json**
  * Ejecuta Nikto. In: **subdomains-webapp.txt** - Out: **RANDOM.nikto.xml**
  * Ejecuta Dastardly. In: **subdomains-webapp.txt** - Out: **RANDOM.dastardly.xml**
  * Ejecuta Testssl. In: **subdomains-webapp.txt** - Out: **RANDOM.testssl.csv** 
* portscan.py -> Ejecuta nmap tcp custom con scripts y usa nmaptocsv para generar el resultado. In: **subdomains.txt** - Out: **ports.csv**.
* defect_uploader.py -> Sube a defect dojo usando los resultados de Zap, Nikto, Testssl y Nuclei. 
```
defect_uploader.py host api_key
```

### Inputs:
* domains.txt -> Listado de dominios.

### Outputs:
*Nota: Todos los outpus se guardan sobre la carpeta outputs, se recomienda crear una nueva antes de cada ejecucion.*
* subdomains.txt -> Listado de subdominios.
* subdomains-webapp.txt -> Urls.
* wafdetect-nowaf.txt -> Urls sin waf.
* dirnfiles.txt -> Endpoints.
* vulnerabilities.txt -> Listado de vuls de takeover.
* technologies.txt -> Info de tecnologias por sitio.
* ports.csv -> Resultado de nmap tcp con IPs puertos abuertos y los resultados de los scripts de nmap.
* output/screenshots ->  Captura de pantalla de los render web.
* output/response -> Respuestas HTTP de los sitios web.
* dalfox.txt -> Resultado de dalfox con posibles XSS
* hakrawler.txt -> Resultado de varios endpoins resultado de crawlear el sitio.
* linkfinder -> Resultado de endpoins de los archivos JS.
* paramspider.txt -> Resultado del crawler. Se tienen varios endpoints y los valores de los parametros salen con el valor FUZZ
* RANDOM.dastardly.xml -> Resultado de Dastardly, los nombres de los archivos son random.
* RANDOM.zap.json -> Resultado de OWASP Zap, los nombres de los archivos son random.
* RANDOM.nikto.xml -> Resultado de Nikto, los nombres de los archivos son random.
* RANDOM.testssl.csv -> Resultado de Testssl, los nombres de los archivos son random.
* nuclei.json -> Salida de nuclei con posibles vuls.

### TODO:
* Crear aws.py para enumerar s3 y automatizar otras cosas.
* Sumar al vulnerabilities.py algo de SSRF y SQLi
* Crear external.py que realice
   * Agregar ncrack para FTP, SSH y Telnet
   * Agregar para FTP nmap banner,ftp-anon,ftp-bounce,ftp-syst
   * Agregar para SSH nmap banner,ssh-auth-methods,sshv1 ssh-audit.py y sshUsernameEnumExploit.py
   * Agregar para Telnet nmap banner,telnet-ntlm-info
   * Agregar para DNS nmap banner,dns-cache-snoop,dns-recursion
