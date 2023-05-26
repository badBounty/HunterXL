# HunterXL

## Instalacion:
Se debe clonar este repositorio. Luego crear una carpeta "tools"

### Clonar e instalar en /tools: 
* https://github.com/wappalyzer/wappalyzer.git 
* https://github.com/maaaaz/nmaptocsv.git 
* https://github.com/punk-security/dnsReaper.git
* https://github.com/GerbenJavado/LinkFinder.git
* https://github.com/devanshbatham/ParamSpider.git
* https://github.com/devanshbatham/ParamSpider
* https://github.com/GerbenJavado/LinkFinder

### Instalar en path:
* https://github.com/tomnomnom/httprobe
* https://github.com/projectdiscovery/httpx
* https://github.com/hakluke/hakrawler
* https://github.com/retirejs
* https://github.com/kacakb/jsfinder
* https://github.com/jaeles-project/gospider
* https://github.com/tomnomnom/gf
* https://github.com/hakluke/hakrawler
* https://github.com/lc/gau
* https://github.com/projectdiscovery/katana

### Ejecutar
Posicionarse en la carpeta HunterXL. Esta carpeta debe contener una carpeta denominada inputs. Todos los archivos de salida se creearan dentro de la carpeta outputs.

## Recon:
* subdomains.py -> Genera una lista de subdominios usando amass y altdns. In: domains.txt - Out: **subdomains.txt**.
* takeover.py -> usa dnsReaper para chequear subdomain takeover. In: **subdomains.txt** - Out: **vulnerabilities.txt**.
* protocols.py -> usa httprobe para obtener un listado de URLs. Luego usa httpx para sacar screenshots y response. In: **subdomains.txt** - Out: **subdomains-webapp.txt** y **httpx.txt** asi como folders **output/screenshots** y **output/response**
* technologies.py -> usa wappalyzer. In: **subdomains-webapp.txt** - Out: **technologies.txt**.

### Inputs:
* domains.txt -> Listado de dominios. **El archivo debe existir dentro de la carpeta inputs.**

### Outputs:
*Nota: Estos archivos se crean en la carpeta outputs.
* subdomains.txt -> Listado de subdominios.
* takeover.txt -> Listado de vuls de takeover.
* subdomains-webapp.txt -> Urls.
* httpx.txt -> Resultados de los request a los sitios vivos, su estado de respuesta.
* output/screenshots ->  Captura de pantalla de los render web.
* output/response -> Respuestas HTTP de los sitios web.
* technologies.txt -> Info de tecnologias por sitio.
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
* wafdetect.py -> detecta que posee waf con wafw00f y que no. In: **subdomains-webapp.txt** - Out: **wafdetect-nowaf.txt**.
* spider.py -> Ejecuta gau, katana, paramspider, linkfinder, gospider y hakrawler. In: **subdomains-webapp.txt** - Out: **linkfinder.txt** y **spidering.txt**.
* contdiscovery.py -> Usa dirsearch y actualiza la lista de endpoints para los sitios web sin waf. In: **wafdetect-nowaf.txt** - Out: **dirnfiles.txt**.
* vulnerabilities.py ->
  * Ejecuta Nuclei. In: **subdomains-webapp.txt** - Out: **nuclei.json**.
  * Ejecuta OWASP ZAP. In: **subdomains-webapp.txt** - Out: **zap.csv**
  * Ejecuta Nikto. In: **subdomains-webapp.txt** - Out: **nikto.csv**
  * Ejecuta Dastardly. In: **subdomains-webapp.txt** - Out: **dastardly.csv**
  * Ejecuta Testssl. In: **subdomains-webapp.txt** - Out: **testssl.csv** 
  * Ejecuta jsfinder y retire. In **subdomains-webapp.txt** - Out: **retirejs.txt** 
  * Ejecuta XSSstrike. In: **subdomains-webapp.txt** - Out: **xssstrike.txt**.
  * Ejecuta Dalfox. In: **spidering.txt** - Out: **dalfox.txt**.
  * Chequea SSRF y OpenRedirect: In: **spidering.txt** - Out: **openredirect.txt**.

### Inputs:
* subdomains-webapp.txt -> Urls. **El archivo debe existir dentro de la carpeta outputs.**
**
### Outputs:
* wafdetect-nowaf.txt -> Urls sin waf.
* dirnfiles.txt -> Endpoints.
* linkfinder.txt -> Resultado de endpoins de los archivos JS.
* dastardly.csv -> Resultado de Dastardly, todos concatenados en formato CSV.
* zap.csv -> Resultado de OWASP Zap, todos concatenados en formato CSV.
* nikto.csv -> Resultado de Nikto, todos concatenados en formato CSV.
* testssl.csv -> Resultado de Testssl, todos concatenados en formato CSV.
* nuclei.csv -> Salida de nuclei con posibles vuls.
* retirejs.txt -> Salida de retire, donde indica las bibliotecas vulnerables encontradas del alcance.
* spidering.txt -> Listado de endpoints y urls producto del spidering de varias tools.
* linkfinder.txt -> Listado de enpoints y urls encontradas en archivos JavaScript.
* xssstrike.txt -> Listado de URLs con parametros GET.
* dalfox.txt -> Resultado de dalfox con posibles XSS
* openredirect.txt -> Listado de URLs vulnerbales a Open Redirect.

---

## TODO:
* Crear aws.py para enumerar s3 y automatizar otras cosas.
* Sumar al vulnerabilities.py algo de SSRF y SQLi
* external.py -> Ejecuta ncrack para FTP, Telnet y SSH. Para SSH ejecuta ssh-audit.py y sshUsernameEnumExploit.py. In: **ports.csv**.
* Usar DefectDojo como triager.
