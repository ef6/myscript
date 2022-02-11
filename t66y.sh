#!/bin/bash
RELEASE=$(echo "$(dirname $(realpath $0))/release/t66y.html")
WWW="/mnt/mmcblk0p4/www/t66y.html"

link_www(){
	[ -e $RELEASE ] && ln -sf $RELEASE $WWW || echo "Not found htmlpage"
}

set_cron(){
# *  *  *  *  *-- 星期中星期几 (0 - 6) (星期天 为0)
# |  |  |  +----- 月份 (1 - 12) 
# |  |  +-------- 一个月中的第几天 (1 - 31)
# |  +----------- 小时 (0 - 23)
# +-------------- 分钟 (0 - 59)
# a,b 表示 a和b 时执行
# */n 表示每 n 单位间隔执行 默认每 1 单位时间间隔执行
# a-b 表示从 a到b 这段时间内每 1 单位时间间隔执行
    local click="3 3 */2 * *"
    local args=''
    crontab - <<- EOF
		$(crontab -l | sed "/$(realpath $0 | sed 's/\//\\\//g')/d")
		$click $(realpath $0) $args &
	EOF
}

set_head(){
    cat <<- EOF
		<title>Run at $(date "+[%m/%d %H:%M]")</title>
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
		<meta name="viewport" content="width=device-width,initial-scale=1.0,user-scalable=no,viewport-fit=cover">
		<link rel='stylesheet' href='https://to.redircdn.com/web/mob_style.css' type='text/css' />
		<style type="text/css">a:visited{color:red;}</style>
	EOF
}

fid2title(){ #|$1 fid int
	local args=$@; [ $1 ] || read -t 1 args
	case $args in
	  2 ) echo "步兵";;
	  4 ) echo "欧美";;
	  5 ) echo "动漫";;
	  15) echo "骑兵";;
	  25) echo "国产";;
	  26) echo "中文";;
	   *) echo "case 2, 4, 5, 15, 25, 26"; exit 1;;
	esac
}

set_title(){ #|$1 title string
	local args=$@; [ $1 ] || read -t 1 args
	cat <<- EOF  
		<div class="tac" style="padding:5px;"><h2>${args}</h2></div>
	EOF
}

get_row(){ #|$1 fid int
	local args=$@; [ $1 ] || read -t 1 args
	curl "https://t66y.com/thread0806.php?fid=${args}&page=[1-7]" -H 'user-agent: Mobile'  -H 'cookie: ismob=1' \
		| tr -d '\r\n' \
		| /mnt/sda1/bin/cascadia -q -i -o -c '.t_one'
}

sort_row(){ #$1 f file
	awk '{i=index($0,"tar\">"); printf("%d,", substr($0,i+12,6)); print $0}' $1\
		| sort -rn \
		| awk -F ",|&#39;" '$1>3000 || NR<=15 {$1=""; sub("<a>", "<a href=\"https://t66y.com/" $3 "\">"); sub("70px", "80px"); print $0}'
		#sub(/onclick=\".*?\"/,"" );
}

claw(){ #$1 fid int
	fid2title $1 | set_title
	sort_row <(get_row $1)
}

claws(){ #$@ fids []int
	for i in $@;do
		claw $i;
		sleep 10;
	done
}

sendmail(){
/mnt/sda1/bin/mailsend-go -debug -smtp smtp.zoho.com.cn -port 465 -ssl \
    -from "evan.bot@zoho.com.cn" -to "evan.fan@hotmail.com" \
    auth -user evan.bot@zoho.com.cn -pass "RuTJPgHQHkV5sr7" \
	-sub "t66y" \
	 body \
     -msg "A HTML should be displayed inline" \
    attach \
     -file "$RELEASE" -inline
}

[ $1 ] && { $@; exit 0; }

set_head > $RELEASE
claws 25 2 26 4 >> $RELEASE

#claw 25 2 26 4
#claw 5 15
#sendmail |logger -t "【t66y】"
