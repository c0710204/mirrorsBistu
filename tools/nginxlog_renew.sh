#!/bin/bash
mv  /var/log/nginx/mirror.access.log /opt/mirrortools/log/nginx/access_`date +%s`.log
#killall -s USR1 nginx #使用USR1参数通知Nginx进程切换日志文件
service nginx restart
