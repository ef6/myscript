# myscript

## 重定向
```
$ cat <<EOF
This is a document
EOF
```
含义是here-document，表示传给给cmd的stdin的内容从这里开始是一个文档，内容碰到EOF为截止。

```
$ cat <<-EOF
	This is a document
	EOF
```
忽略前面的Tab


```
$ cat <<<"aaa"
```
含义是here-string，表示传给给cmd的stdin的内容从这里开始是一个字符串。

```
$ echo <(echo "12345")
/dev/fd/63
```
`<(echo "12345")`的输出就是文件`/dev/fd/63`，文件内容是字符串“12345“；/dev/fd/63是一个匿名pipe文件


## crondtabs
### 设定计划任务
```
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
```

 ## 判断
 ```
 # -z zero 字符串为空
 # -n non-zero 非空
 [ -z "${address}" ] && { echo "not found"; exit 1; }
 ``` 

## 从脚本外部执行函数
```
[ $1 ] && { $@; exit 0; }
```
## 使函数能被 | 传入参数
```
_echo(){
	local args=$@; [ $1 ] || read -t 1 args
	echo $args
}
```

## 逐行读取文件
```
while read line
do
	echo $line
done < file
```
