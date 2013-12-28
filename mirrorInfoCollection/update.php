#!/usr/bin/php
<?php
	if ($_SERVER['argc']!=3)
	{
		echo "Usage:update mirror status\n";die;
	}
	$mirror=$_SERVER['argv'][1];
	$minfo=explode('.',$mirror);
	$mirror=$minfo[0];
	$statuscode=$_SERVER['argv'][2];
	$mirrorstatuspath='../mirrorstatus/'.$mirror.'.json';
	$mirrorinfopath='../mirrorinfo/'.$mirror.'.json';
	$mirrorstatus=json_decode(file_get_contents($mirrorstatuspath),1);
	if (file_exists($mirrorinfopath))
		$mirrorinfo=json_decode(file_get_contents($mirrorinfopath),1);
	else
	{
		system('mv ../mirrorinfo/.json ../mirrorinfo/'.$mirror.'.json');
		$mirrorinfo=json_decode(file_get_contents($mirrorinfopath),1);
	}
	/*
	status:
	0=online
	1=onsync
	2=sync unsuccess
	*/
	$mirrorstatus['status']=$statuscode;
	echo "\033[31m".$mirror."\033[0m\nsize:\t\t";
	$mirrorstatus['size']=system("du -sm ".$mirrorinfo['rootpath'].' |awk \'{print $1}\' ');
	if ($mirrorstatus['size']>1024) 
		$mirrorstatus['size']=(ceil($mirrorstatus['size']*100/1024)/100).'G';
	else
		$mirrorstatus['size']=$mirrorstatus['size'].'M';
	echo "file count:\t";
	date_default_timezone_set('Asia/Shanghai');
	$mirrorstatus['updatetime']=date("Y-m-d H:i");
	$mirrorstatus['filecount']=system("find ".$mirrorinfo['rootpath'].' |wc -l');
	file_put_contents($mirrorstatuspath, json_encode($mirrorstatus));
	
	
