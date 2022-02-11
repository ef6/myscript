#!/bin/bash

HOST=
TOKEN=
INI=$(echo "$(dirname $(realpath $0))/dynv6.ini")
. $INI
# *  *  *  *  *-- 星期中星期几 (0 - 6) (星期天 为0)
# |  |  |  +----- 月份 (1 - 12) 
# |  |  +-------- 一个月中的第几天 (1 - 31)
# |  +----------- 小时 (0 - 23)
# +-------------- 分钟 (0 - 59)
# a,b 表示 a和b 时执行
# */n 表示每 n 单位间隔执行 默认每 1 单位时间间隔执行
# a-b 表示从 a到b 这段时间内每 1 单位时间间隔执行
set_cron(){
    local click="0 * * * *"
    local args='| logger -t "[dynv6]"'
    crontab - <<- EOF
		$(crontab -l | sed "/$(realpath $0 | sed 's/\//\\\//g')/d")
		$click $(realpath $0) $args &
	EOF
}

get_local_ip(){
    ip -6 a | awk -F '[ /]+' '$2 ~ /inet6/ && $6 ~ /global/ {print $3}' | head -n1
}

get_local_ip_force(){
    for i in $(seq 10); do {
        address=$(get_local_ip)
        [ -n "${address}" ] && break || sleep 90
    } done
    [ -z "${address}" ] && { echo "IPv6 address not found"; exit 1; }
    echo $address
}

get_remote_ip(){
    nslookup -type=aaaa fxj-s.v6.army 8.8.8.8 | awk 'NR==6 {print $2}'
}

update_ip(){
    [ -z "${HOST}" -o -z "${TOKEN}" ] && {
        echo "Don't have authentication-token or your-name.dynv6.your-domain";
        exit 1;
    }
    [ -z $1 ] && {
        echo "Don't have update ip";
        exit 1;
    }
    curl -s "http://dynv6.com/api/update?hostname=${HOST}&ipv6=${1}&token=${TOKEN}"
}

[ $1 ] && { $@; exit 0; }

address=$(get_local_ip_force)
[ "${address}" = "$(get_remote_ip)" ] && echo "IPv6 address not change" || {
    echo "Update address ${address}" $(update_ip ${address});
}