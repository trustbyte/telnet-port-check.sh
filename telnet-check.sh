#!/bin/bash

server=$1;
port=$2;

if [ $# -lt 2 ];then
  echo "$0 <server> <port>"
	echo "$0 nagios 80"
	exit 1;
fi
	s=$(date +%s.%N)
	check_port=$(nc -z $server $port 2>&1; echo -n "|EXIT:"$?)
	IFS="|";
	exit_code=$(echo -e $check_port|grep "EXIT:"|awk -F":" '{print $2}')
	result=$(echo $check_port|grep -v "EXIT:")
   	f=$(date +%s.%N)
        sum=$(echo $f|awk -v s=$s '{$3 = $1 - 's';  printf "%f", $3}')

if [[ $exit_code == 0 ]]; then
	echo "$result|time="$sum"s;;;0 "
	exit $exit_code
else
	echo "NC $server $port failed - critical|time="$sum"s;;;0 "
	exit $exit_code
fi
