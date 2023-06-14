# HunterXL
## Intro
Herramienta de pentest automatizada blackbox. Busca enumerar un dominio, identificar la superficie de ataque y correr unos controles basicos de seguridad para gatantizar que no haya ciertas vulnerabilidades ni malas prácticas de seguridad.

## Listado de Diccionarios:
Existen 2 archivos en la carpeta inputs que definen los diccionarios a utilizarse:
* subdomains-wordlists.txt: Indica URLs de donde descargar los diccionarios para enumerar subdominios por fuerza bruta. Se recomienda agregar uno o mas de estos:
  * https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/DNS/sortedcombined-knock-dnsrecon-fierce-reconng.txt
  * https://gist.githubusercontent.com/jhaddix/f64c97d0863a78454e44c2f7119c2a6a/raw/96f4e51d96b2203f19f6381c8c545b278eaa0837/all.txt
  * https://raw.githubusercontent.com/fuzzdb-project/fuzzdb/master/discovery/dns/dnsmapCommonSubdomains.txt
  * https://raw.githubusercontent.com/fuzzdb-project/fuzzdb/master/discovery/dns/alexaTop1mAXFRcommonSubdomains.txt
* dirnfiles-wordlists.txt: Indica URLs de donde descargar los diccionarios para hacer content discovery. Se recomienda agregar uno o mas de estos:
  * https://gist.githubusercontent.com/jhaddix/b80ea67d85c13206125806f0828f4d10/raw/c81a34fe84731430741e0463eb6076129c20c4c0/content_discovery_all.txt
  * https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/dirsearch.txt
  * https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/raft-large-files.txt
  * https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/directory-list-2.3-small.txt
  * https://raw.githubusercontent.com/tismayil/ohmybackup/master/files/files.txt
  * https://raw.githubusercontent.com/tismayil/ohmybackup/master/files/folders.txt
  * https://raw.githubusercontent.com/clarkvoss/AEM-List/main/paths
  * https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/AdobeCQ-AEM.txt
  * https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/nginx.txt
  * https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/oracle.txt
  * https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/common.txt  

Adicionalmente pueden usarse mas de estos repositorios:
* https://github.com/danielmiessler/SecLists
* https://github.com/fuzzdb-project/fuzzdb
* https://github.com/maxpowersi/MyCustomFuzzList

## Instalación:
Se debe clonar este repositorio. Luego crear una carpeta "tools". Existe un script **"check_tools.sh"** Puede ejecutarse para saber si las tools estan correctamente instaladas antes de ejecutar todo el flujo.

### Clonar e instalar en /tools: 
* https://github.com/maaaaz/nmaptocsv
* https://github.com/punk-security/dnsReaper
* https://github.com/GerbenJavado/LinkFinder
* https://github.com/devanshbatham/ParamSpider
* https://github.com/s0md3v/XSStrike

### Instalar en path:
* https://github.com/tomnomnom/httprobe
* https://github.com/projectdiscovery/httpx
* https://github.com/hakluke/hakrawler
* https://github.com/retirejs
* https://github.com/kacakb/jsfinder
* https://github.com/lc/gau
* https://github.com/projectdiscovery/katana
* https://github.com/sqlmapproject/sqlmap
* https://github.com/tomnomnom/qsreplace
* https://github.com/sullo/nikto
* https://github.com/drwetter/testssl.sh
* https://github.com/projectdiscovery/nuclei
* https://github.com/EnableSecurity/wafw00f
* https://github.com/infosec-au/altdns
* https://github.com/owasp-amass/amass
* nmap
* jq
* docker for Linux or docker.exe for WSL

## Ejecutar
Posicionarse en la carpeta HunterXL. Esta carpeta debe contener una carpeta denominada inputs. Todos los archivos de salida se creearan dentro de la carpeta outputs. luego ejecutar los scripts de alguno de los tres modulos Recon, External y Web App.

## Recon:
* subdomains.py -> Genera una lista de subdominios usando amass y altdns. Utiliza el archivo **inputs/subdomains-wordlists.txt** con URLs de donde descargar los diccionarios y hacerle un merge. In: domains.txt - Out: **subdomains.txt**.
* takeover.py -> usa dnsReaper para chequear subdomain takeover. In: **subdomains.txt** - Out: **takeover.csv**.
* protocols.py -> usa httprobe para obtener un listado de URLs. Luego usa httpx para sacar screenshots y response. In: **subdomains.txt** - Out: **subdomains-webapp.txt** y **httpx.csv** asi como folders **httpx/screenshots** y **httpx/response**.

### Inputs:
* domains.txt -> Listado de dominios. **El archivo debe existir dentro de la carpeta inputs.**

### Outputs:
* subdomains.txt -> Listado de subdominios.
* takeover.csv -> Listado de vuls de takeover.
* subdomains-webapp.txt -> Urls.
* httpx.csv -> Resultados de los request a los sitios vivos, su estado de respuesta.
* httpx/screenshots ->  Captura de pantalla de los render web.
* http/response -> Respuestas HTTP de los sitios web.x
---

## External:
* portscanner.py -> Ejecuta nmap tcp custom con scripts y usa nmaptocsv para generar el resultado. In: **subdomains.txt** - Out: **ports.csv**.

### Inputs:
* subdomains.txt ->  Listado de subdominios. **El archivo debe existir dentro de la carpeta outputs.**

### Outputs:
* ports.csv -> Resultado de nmap tcp con IPs puertos abuertos y los resultados de los scripts de nmap.

---

## Web App:
* wafdetect.py -> detecta que posee waf con wafw00f y que no. In: **subdomains-webapp.txt** - Out: **wafdetect-nowaf.txt**.
* contdiscovery.py -> Usa dirsearch y actualiza la lista de endpoints para los sitios web sin waf. Utiliza el archivo **inputs/dirnfiles-wordlists.txt** con URLs de donde descargar los diccionarios y hacerle un merge In: **wafdetect-nowaf.txt** - Out: **dirnfiles.txt**.
* spider.py -> Ejecuta gau, katana, paramspider, linkfinder, gospider y hakrawler, el resultado se filtra por sitios que no tengan WAF. In: **subdomains-webapp.txt** - Out: **linkfinder.txt** y **spidering.txt**.
* vulnerabilities.py ->
  * Ejecuta Nuclei. In: **subdomains-webapp.txt** - Out: **nuclei.csv**
  * Ejecuta Nikto. In: **subdomains-webapp.txt** - Out: **nikto.csv**
  * Ejecuta Testssl. In: **subdomains-webapp.txt** - Out: **testssl.csv** 
  * Ejecuta jsfinder y retire. In **subdomains-webapp.txt** - Out: **retire.csv** 
  * Ejecuta ZAP. In: **subdomains-webapp.txt** - Out: **zap.csv**.
  * Ejecuta XSSstrike. In: **wafdetect-nowaf.txt** - Out: **xssstrike.txt**.
  * Ejecuta Dalfox. In: **wafdetect-nowaf.txt** y **spidering.txt** - Out: **dalfox.csv**.
  * Ejecuta SQLmap sobre los resultados del spidering. In: **wafdetect-nowaf.txt** y **spidering.txt**  - Out: **sqlmap.csv**.
  * Chequea SSRFf y OpenRedirect: In: **spidering.txt** - Out: **openredirect.csv**.


### Inputs:
* subdomains-webapp.txt -> Urls. **El archivo debe existir dentro de la carpeta outputs.**

### Outputs:
* spidering.txt -> Salida de URLs por spidering.
* params.txt -> Filtrado del spidering, por URLs que tengan parametros y que no tengan WAF.
* wafdetect-nowaf.txt -> Urls sin WAF.
* dirnfiles.txt -> Endpoints para sitios sin WAF.
* nikto.csv -> Resultado de Nikto, todos concatenados en formato CSV.
* testssl.csv -> Resultado de Testssl, todos concatenados en formato CSV.
* nuclei.csv -> Salida de nuclei con posibles vuls.
* retire.csv -> Salida de retire, donde indica las bibliotecas vulnerables encontradas del alcance.
* xssstrike.txt -> Listado de URLs vulnerables a XSS **para sitios sin WAF**.
* dalfox.csv -> Resultado de dalfox con posibles XSS **para sitios sin WAF**.
* sqlmap.csv -> Resultado de inyectar en parametros GET del spidering **para sitios sin WAF**.
* openredirect.csv -> Listado de URLs vulnerbales a Open Redirect usando el resultado de spidering.
* zap.csv -> Salida de ZAP.

---
## Workflow
![alt tag](https://github.com/badBounty/HunterXL/blob/main/flujo.png?raw=true)

---
## Manual Security Checks 
El archivo **Manual Security Checks.xlsx** intenta sumar controles adicionales de un baseline de seguridad que no es cubierto por esta herramienta. Se recomienda realizar dichos checks de forma manual para que en conjunto con el Hunter XL se pueda garantizar un buen baseline de seguridad.

---
## Stand Alone
Existe una version para correr el HunterXL con un script para un unico sitio. Los archivos son hunter-pto-BB.sh para modo sin cookies y hunter-pto-GB.sh para modo autenticado
```
bash hunter-pto-BB.sh "https://www.example.com" "https://collaborator.com" "bak,php" "true" "folder_title"
bashhunter-pto-GB.sh "https://www.example.com" "https://collaborator.com" "bak,php" "true/false" "folder_title" "Cookie: galleta=valor; galleta2=valor"
bash hunter-pto-GB.sh "https://www.example.com" "https://collaborator.com" "bak,php" "true/false" "folder_title" "Authorization: Bearer JWT"
```
Este script dará como salida en la carpeta folder_title los siguientes archivos de interes:

* spidering.txt -> Salida de URLs por spidering.
* dirnfiles.txt -> Endpoints.
* nikto.csv -> Resultado de Nikto.
* testssl.csv -> Resultado de Testssl.
* nuclei.csv -> Salida de nuclei.
* retire.csv -> Salida de retire.
* xssstrike.txt -> Listado de URLs vulnerables a XSS usando el resultado de spidering.
* dalfox.csv -> Resultado de dalfox con posibles XSS usando el resultado de spidering.
* sqlmap.csv -> Resultado de inyectar en parametros usando el resultado de spidering.
* openredirect.csv -> Listado de URLs vulnerbales a Open Redirect usando el resultado de spidering.
* zap.csv -> Salida de ZAP.

---

## TODOs 
* Agregar aws.py -> Enumerar s3 y automatizar otros checks de AWS.
* Implementar https://github.com/mr-medi/HostPanic