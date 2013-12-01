#!/bin/bash

mirrorInfoCollection="/opt/mirrortools/mirrorInfoCollection"
mirrorStatus="/opt/mirrortools/mirrorinfo/"
lscmd=`ls $mirrorStatus`
mirrorlist=`ls $mirrorStatus`
echo $mirrorlist
cd $mirrorInfoCollection
echo "start update mirror info"
for i in $mirrorlist
do
$mirrorInfoCollection/update.php $i 1;
#$mirrorInfoCollection/update.php openstack 1
done
echo "mirror info update ended"
cp -r ../mirrorstatus /var/www/
apt-mirror
echo "start update mirror info"
for i in $mirrorlist
do
$mirrorInfoCollection/update.php $i 0;
#$mirrorInfoCollection/update.php openstack 0
done
echo "mirror info update ended"
cp -r ../mirrorstatus /var/www/

