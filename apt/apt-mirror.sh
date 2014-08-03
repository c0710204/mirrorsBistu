#!/bin/bash
#echo "update offline"
#exit 0;
#!!!!!!!!!!!!!!!!!!!!!!!!!
DATE=$(date +%s)
logfile="$DATE.log";
mirrorRoot="/opt/mirrortools"
mirrorlog="$mirrorRoot/log/apt-mirror"
wwwroot="/var/web/host/Symfony/web/"
logfile="$mirrorlog/$logfile";
#mirrorupdate
cd $mirrorRoot;echo `php proxy mirrorupdate ` 1>>$logfile 2>>1;
#echo "renew nginx log" 1>>$logfile  2>>1
#cd $mirrorRoot/tools;./nginxlog_renew.sh 1>>$logfile  2>>1
#echo "update awstats page" 1>>$logfile  2>>1
#cd $mirrorRoot/tools;./awstatsbuild.sh 1>>$logfile  2>>1
#cp -r "/opt/mirrortools/log/awstats" "$wwwroot/awstats" 1>>$logfile  2>>1
