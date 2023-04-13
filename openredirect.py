import subprocess,os

from urllib.parse import urlparse

OUTPATH_DIRNFILES="outputs/dirnfiles.txt"
OUTPATH_OPENREDIRECT_URLS="outputs/openredirect-urls.txt"
OUTPATH_OPENREDIRECT_JSON="outputs/openredirect.json"
PAYLOAD="https://www.google.com/"
OUTPATH_VULNERABILITIES="outputs/vulnerabilities.txt"

def getDomain(url):
    return urlparse(url).netloc

getCmd=subprocess.Popen("cat "+OUTPATH_DIRNFILES+" | gf redirect archive | qsreplace | tee -a "+OUTPATH_OPENREDIRECT_URLS, shell=True)
getCmd.wait()

if(os.path.isfile(OUTPATH_OPENREDIRECT_URLS)):
    urlsList=open(OUTPATH_OPENREDIRECT_URLS,'r')
    while True:
        finalUrl=""
        url=""
        endpoint=urlsList.readline()
        if not endpoint:
            break
        openRedirect=subprocess.Popen("echo "+endpoint.strip()+" | qsreplace "+PAYLOAD+" | httpx -silent -status-code -location -json -fr | tee -a outputs/openredirect.json", shell=True)
        openRedirect.wait()
        finalUrl=subprocess.run(["json2csv","-i",OUTPATH_OPENREDIRECT_JSON,"-f","final-url","-H","-q",""], check=False, capture_output=True, text=True).stdout
        url=subprocess.run(["json2csv","-i",OUTPATH_OPENREDIRECT_JSON,"-f","url","-H","-q",""], check=False, capture_output=True, text=True).stdout
        os.remove(OUTPATH_OPENREDIRECT_JSON)
        print("URL FINAL: "+finalUrl)
        print("son iguales: %s", finalUrl==PAYLOAD)
        if(finalUrl):
            print("Existe final URL")
            if(finalUrl == PAYLOAD):
                row=getDomain(url)+","+url+",OpenRedirection,Medium"
                os.system("echo "+row+" >> "+OUTPATH_VULNERABILITIES)
                print("Cargue a vulnerabilidades")
        else:
            print("No existe final URL")
    urlsList.close()
    
os.remove(OUTPATH_OPENREDIRECT_URLS)
