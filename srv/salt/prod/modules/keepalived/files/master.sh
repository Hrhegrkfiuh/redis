#!/bin/bash
httpd_status=$(ps -ef | grep -Ev 'grep|$0' | grep -w httpd | wc -l)
if [ $httpd_status -lt 1 ];then
	systemctl stop keepalived
fi


