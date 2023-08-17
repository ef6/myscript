#! /usr/bin/python
# coding:utf-8
import requests as Req
from retrying import retry
from lxml import etree
import datetime
import json
import os
import shutil
import fire

WorkDir=os.path.dirname( os.path.abspath(__file__) )

# 日期
_today=datetime.date.today()
#ThisYear=_today.strftime("%Y")
Today=_today.strftime("%Y-%m-%d")
#Yesterday =( _today + datetime.timedelta(-1) ).strftime("%Y-%m-%d")

# 网络
#Domain="https://cl.1538y.xyz/"
Domain="https://cl.2980z.xyz/"
Url="thread0806.php"
ss=Req.Session()
ss.headers = {
    'user-agent': 'Mobile',
    'cookie': 'ismob=1'
}

@retry(stop_max_attempt_number=6)
def downPage(fid, page_num):
    r=ss.get(Domain+"thread0806.php",
        params={'fid':fid,'page':page_num}, 
        timeout=12)
    print(r)
    return r.content

def timestamp2string(timestamp):
    try:
        return datetime.datetime.fromtimestamp(timestamp).strftime("%Y-%m-%d %H:%M")
    except Exception as e:
        print(timestamp, e)
        return timestamp2string(0)

def cleanData(data):
    try:int(data["dl"][0])
    except:return 0
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
    return flash_data

def parse(html_page, data_struct):
    html=etree.HTML(html_page)
    items=html.xpath('//div[@class="list t_one"]')
    for i in items:
        flash_data=cleanData({ 
            "url"       : i.xpath('.//a/@href'),
            "title"     : i.xpath('.//a[@href]/text()'),
            "au"        : i.xpath('.//span/text()'),
            "timestamp" : i.xpath('.//span/@data-timestamp'), 
            "like"      : i.xpath('.//i[@class="icon-like"]/../text()'),
            "dl"        : i.xpath('.//i[@class="icon-dl"]/../text()'),
            "comm"      : i.xpath('.//i[@class="icon-comm"]/../text()')
        })
        data_struct["list"].append(flash_data)

def sortData(data_struct):
    def _sort(item):
        point={"dl":0,"like":0,"comm":0}
        for p in point.keys():
            try:point[p]=int(item[p])
            except:pass
        return point["dl"] + point["like"]*100 + point["comm"]*100
    data_struct["list"].sort(key=_sort,reverse=True)

def dumpJson(out, data_struct):
    with open(out, 'w') as f:
        f.write(json.dumps(data_struct))

def release(src,  dst):
    shutil.copy(src, dst)
    
def claw(fid=25):
    data_struct={
        "domain" : Domain,
        "date" : Today, 
        "list" : []
    }
    for i in range(10):
        parse(downPage(fid, i+1), data_struct)
    sortData(data_struct)
    data_struct["list"]=data_struct["list"][:30]
    return data_struct


def _test():
    with open("./fid25.html", 'wb') as f:
        f.write(down_page(25, 3))

def getNewDomain():
    page=ss.get('https://www.gfaqvij.xyz').text
    n=page.find('dn = ')
    new_code=page[n+6:n+10]
    new_url=[f"https://cl.{new_code}{x}.xyz" for x in ['x','y','z']]
    print(new_url)

def main(fid=25):
    OutFile=f"{WorkDir}/fid{fid}.{Today}.json"
    dumpJson(OutFile, claw(fid))
    release(OutFile, f"/root/www/fid{fid}.json")

if __name__ == '__main__':
    fire.Fire({'get':main,'domain':getNewDomain})
    #getNewDomain()
