./dnsq -t=A -q=ipfs.io -f=raw -s=https://asia.dnscepat.id/dns-query
./dnsq -t=A -q=ipfs.io -f=raw -s=https://dns-unfiltered.adguard.com/dns-query 2>/dev/null

cd Navheader/
ln -s /usr/lib/lua/luci/view/themes/opentomcat/header.htm ./header.htm
opkg find *busybox*

chown nobody sync/ -R
chgrp nogroup sync/ -R

while `sleep 2`; do cpustat |awk '{printf("\r%.1f",$3)}'; done

docker search alpine

docker run -itd --name vm-a alpine /bin/sh
docker start vm-a && docker exec -it vm-a /bin/sh
docker container ls -a |awk '{print $NF}' |xargs docker container rm

wget https://download.fastgit.org/c0re100/qBittorrent-Enhanced-Edition/releases/download/release-4.3.8.10/qbittorrent-nox_aarch64-linux-musl_static.zip \
&& unzip qbittorrent*.zip \
&& rm qbittorrent*.zip

wget -q -O- -t1 https://api.github.com/repos/c0re100/qBittorrent-Enhanced-Edition/releases/latest | grep tag_name | awk -F ':|,|\"' '{print $5}'

#bash批量修改文件名称
for i in *.aspx;do mv "$i" "`echo $i |sed 's/.aspx//'`";done