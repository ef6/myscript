#!/bin/bash 

n=0
while read line
do
	#echo $line | awk -F',' '{print $1}'
	_n=$(echo $line | awk -F',' '{print $1}')
	if [ $n -eq $_n ]; then
		path=$(echo $line | awk -F',' '{print $3}')
		echo $n,$path
	else
		n=$_n
	fi
done < ~/duplicate_file.csv

