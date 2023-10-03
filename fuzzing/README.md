# Fuzzing
## Intro
Repositorio de archivos txt de fuzzing y content discovery

## Listado de Diccionarios:
* Diccionarios de subdominios y permutaciones:
  * https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/DNS/sortedcombined-knock-dnsrecon-fierce-reconng.txt
  * https://gist.githubusercontent.com/jhaddix/f64c97d0863a78454e44c2f7119c2a6a/raw/96f4e51d96b2203f19f6381c8c545b278eaa0837/all.txt
  * https://raw.githubusercontent.com/fuzzdb-project/fuzzdb/master/discovery/dns/dnsmapCommonSubdomains.txt
  * https://raw.githubusercontent.com/fuzzdb-project/fuzzdb/master/discovery/dns/alexaTop1mAXFRcommonSubdomains.txt
* Diccionarios de content discovery generales:
  * https://gist.githubusercontent.com/jhaddix/b80ea67d85c13206125806f0828f4d10/raw/c81a34fe84731430741e0463eb6076129c20c4c0/content_discovery_all.txt
* Diccionarios de content discovery propios: 
  * content-dicovery.txt: basado en los siguientes y contenido propio:
	* https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/dirsearch.txt
	* https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/raft-large-files.txt
	* https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/directory-list-2.3-small.txt
	* https://raw.githubusercontent.com/tismayil/ohmybackup/master/files/files.txt
	* https://raw.githubusercontent.com/tismayil/ohmybackup/master/files/folders.txt
	* https://raw.githubusercontent.com/clarkvoss/AEM-List/main/paths
	* https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/AdobeCQ-AEM.txt
	* https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/common.txt  
* Diccionarios de oracle:
  * https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/oracle.txt
* Diccionarios de nginx:
  * https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/nginx.txt


Adicionalmente pueden usarse mas de estos repositorios:
* https://github.com/danielmiessler/SecLists
* https://github.com/fuzzdb-project/fuzzdb
* https://github.com/maxpowersi/MyCustomFuzzList

Para ejecutar dirsearch:

```
dirsearch -u "$https://sitio" -w "fuzzing.txt" -o "sitio.direarch.txt" --force-extensions -e "log,xml,{OTRAS}"
```
