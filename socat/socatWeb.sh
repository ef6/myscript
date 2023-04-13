#! /bin/bash
# socat -d TCP-LISTEN:12300,reuseaddr,fork SYSTEM:"bash ./socatWeb.sh"
cat << _EOF
HTTP/1.1 200
Content-Type:text/html

<html>
<head>
  <title>socat web</title>
  <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
  <meta name="description" content="now is $(date)">
</head>
<body>
<h1>正在抓取</h1>
</body>
</html>

_EOF

/mnt/mmcblk0p4/myscript/t66y.sh 
sleep 2

cat << _EOF
<meta http-equiv="refresh" content="0, URL=http://fxj-s.v6.army:8888/t66y.html">
_EOF