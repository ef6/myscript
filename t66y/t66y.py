#! /usr/bin/python
# coding:utf-8
import requests as Req
from retrying import retry
from lxml import etree
import datetime
import json
import os

# 日期
_today=datetime.date.today()
#ThisYear=_today.strftime("%Y")
Today=_today.strftime("%Y-%m-%d")
#Yesterday =( _today + datetime.timedelta(-1) ).strftime("%Y-%m-%d")

# 网络
Domain="https://cl.3572y.xyz/"
Url="thread0806.php"
ss=Req.Session()
ss.headers = {
    'user-agent': 'Mobile',
    'cookie': 'ismob=1'
}

dataStruct={
    "domain" : Domain, 
    "list" : []
}

@retry(stop_max_attempt_number=6)
def clawDown(fid, page_num):
    r=ss.get(
        Domain+"thread0806.php",
        params={'fid':fid,'page':page_num}, 
        timeout=12
        )
    print(r)
    return r.content

def timestamp2string(timestamp):
    try:
        return datetime.datetime.fromtimestamp(timestamp).strftime("%Y-%m-%d %H:%M")
    except Exception as e:
        print(timestamp, e)
        return timestamp2string(0)

def cleanData(data):
    try:
        int(data["dl"][0])
    except:
        return 0

    head=lambda x:x[0] if len(x)>0 else ''
    flash_data= {
        "url"       : head(data["url"]),
        "title"     : head(data["title"]),
        "au"        : head(data["au"]),
        "time"      : '', 
        "timestamp" : head(data["timestamp"])[0:-1],
        "like"      : head(data["like"]),
        "dl"        : head(data["dl"]),
        "comm"      : head(data["comm"])
    }
    try:
        flash_data["time"]=timestamp2string(int(flash_data["timestamp"]))
    except Exception as e:
        print(flash_data["timestamp"], e)
    dataStruct["list"].append(flash_data)

def parse(html_page):
    html=etree.HTML(html_page)
    items=html.xpath('//div[@class="list t_one"]')
    for i in items:
        cleanData({ 
            "url"       : i.xpath('.//a/@href'),
            "title"     : i.xpath('.//a[@href]/text()'),
            "au"        : i.xpath('.//span/text()'),
            "timestamp" : i.xpath('.//span/@data-timestamp'), 
            "like"      : i.xpath('.//i[@class="icon-like"]/../text()'),
            "dl"        : i.xpath('.//i[@class="icon-dl"]/../text()'),
            "comm"      : i.xpath('.//i[@class="icon-comm"]/../text()')
        })

def sortData():
    def _sort(item):
        try:
            dl = int(item["dl"])
        except:
            dl =  0
        try:
            like = int(item["like"])
        except:
            like =  0
        try:
            comm = int(item["comm"])
        except:
            comm =  0
        return dl + like*100 + comm*100
    dataStruct["list"].sort(key=_sort,reverse=True)

def dumpJson(out):
    with open(out, 'w') as f:
        f.write(json.dumps(dataStruct))

def release(src,  dst):
    if os.path.exists(dst):
        os.remove(dst)
    os.symlink(src, dst)
    
def main():
    fid=25
    WorkDir=os.path.dirname( os.path.abspath(__file__) )
    OutFile=f"{WorkDir}/fid{fid}.{Today}.json"
    for i in range(7):
        parse(clawDown(fid, i+1))
    sortData()
    dataStruct["list"]=dataStruct["list"][:30]
    dumpJson(OutFile)
    release(OutFile, "/mnt/mmcblk0p4/www/data.json")

def _test():
    with open("./fid25.html", 'wb') as f:
        f.write(clawDown(25, 3))

def getNewDomain():
    page=ss.get('https://www.gfaqvij.xyz').text
    n=page.find('dn = ')
    new_code=page[n+6:n+10]
    new_url=[f"https://cl.{new_code}{x}.xyz" for x in ['x','y','z']]
    print(new_url)

if __name__ == '__main__':
    main()
    #getNewDomain()
