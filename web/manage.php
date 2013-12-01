<?php
include ("libs/Smarty.class.php");
//include("index.html");
$sites=array();
/*
if (isset($_GET['action']))
{
	if (($_GET['action']=='delete')&&(isset($_GET['name']))&&(file_exists("./mirrorinfo/".$_GET['name'].".json")))
	{
		unlink("./mirrorinfo/".$_GET['name'].".json");
	}
}
*/

foreach (glob("./mirrorinfo/*.json") as $site) {
	$site_name=basename($site,".json");
	$siteinfo=json_decode(file_get_contents("./mirrorinfo/".$site_name.".json"),1);
	$siteinfo["status"]=json_decode(file_get_contents("./mirrorstatus/".$site_name.".json"),1);
	array_push($sites, $siteinfo);	
}




$smarty = new Smarty;

//$smarty->force_compile = true;
$smarty->debugging = false;
$smarty->caching = true;
$smarty->cache_lifetime = 10;
$smarty->assign("sites",$sites);
$smarty->display("manage.tpl");
