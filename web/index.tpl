<!doctype html>
<html>
<head>
	<meta content="text/html; charset=UTF-8" http-equiv="Content-Type">
	<meta name="google-translate-customization" content="275efe018e191117-4ad5760d63e54508-g1acd9273226ae414-1d"></meta>
	<link href="files/mirrors.tuna.css" rel="stylesheet" type="text/css" />
	<link href="files/humane/bigbox.css" rel="stylesheet" type="text/css" />
	<link rel="stylesheet" href="files/jquery-ui.css"></script>
	<script type="text/javascript" src="files/jquery-latest.js"></script>
	<script type="text/javascript" src="files/jquery.tablesorter.min.js"></script>
	<script type="text/javascript" src="files/sort-status-table.js"></script>
	<script type="text/javascript" src="files/jquery-ui.js"></script>
	<script type="text/javascript" src="files/humane/humane.js"></script>
	<title>北京信息科技大学开源镜像站</title>

</head>
<body>
<div id="wrapper">
<div id="header">
<h1>北京信息科技大学开源镜像站</h1>
<div class="tagline">
Portal of BISTU Open Source Software Mirror Sites
</div>
</div> <!-- end of header div -->
<div id="content">
<h2>简介</h2>
<p>
欢迎来到北京信息科技大学开源镜像网站，它由北京信息科技大学<a href="http://iflab.org">ifLAB</a>小组维护管理。
</p>
<!--
<p>本站可以在校内外通过 IPv4/IPv6 使用。本站域名有：</p>
<ul>
<li><a href="http://mirrors.tuna.tsinghua.edu.cn/">http://mirrors.tuna.tsinghua.edu.cn/</a> 支持 IPv4/IPv6</li>
<li><a href="http://mirrors.6.tuna.tsinghua.edu.cn/">http://mirrors.6.tuna.tsinghua.edu.cn/</a> 只解析 IPv6</li>
<li><a href="http://mirrors.4.tuna.tsinghua.edu.cn/">http://mirrors.4.tuna.tsinghua.edu.cn/</a> 只解析 IPv4</li>
</ul>

<p><strong>镜像使用所需配置参见 <a href="http://wiki.tuna.tsinghua.edu.cn/MirrorUseHowto">Wiki</a></strong>。</p>

<p>如果您有任何问题或建议，请在我们的 <a href="http://issues.tuna.tsinghua.edu.cn">issue tracker</a>
 上提交 bug，或者访问我们的<a
 href="https://groups.google.com/forum/#%21forum/thu-opensource-mirror-admin">Google
Groups</a>，或直接向 Google Groups 的邮件列表 thu-opensource-mirror-admin <span class="nospam">[SPAM]</span> AT googlegroups <span class="nospam">[SPAM]</span> DOT com 寄信。
</p>
-->

<div class="mirrors-stat">
<h2>状态统计</h2>
<div id="status-table">
<h3>各镜像状态表<a href="#status-table-footnote" title="到表尾脚注">↓</a></h3>
<table class="tablesorter" id="status-main-table">
	<thead>
	<tr>
		<th><img height="16" width="16" src="files/official-header.png"
				alt="Is an official mirror?"/></th>
		<th>名称</th>
		<th>维护者</th>
		<th>状态</th>
		<th>大小</th>
		<th>文件总数</th>
		<th>同步完成时间</th>
		<th>请求次数</th>
		<th>请求数据量</th>
	</tr>
	</thead>
	<tbody>

	{foreach item=site from=$sites}
	<tr>
	<td class="{$site.official}"><img height="16" width="16" src="files/{$site.official}.png" alt="{$site.official}"/></td>

		<td>
		<a name="{$site.name}" href="{$site.href}" title="{$site.intro}">
				{$site.title}			</a>
		</td>
		<td><a href='{$site.worker_link}' target='_blank'>{$site.worker_name}</a></td>
		
					{if $site.status.status == 0 }<td class="sync-state sync-ed">同步完成</td>{/if}
					{if $site.status.status == 3 }<td class="sync-state sync-unknown">未知</td>{/if}
					{if $site.status.status == 2 }<td class="sync-state sync-fail">同步失败</td>{/if}
					{if $site.status.status == 1 }<td class="sync-state sync-ing">正在同步</td>{/if}
		
		<td class="size">{$site.status.size}</td>
		<td class="files_count">{$site.status.filecount}</td>
		<td>{$site.status.updatetime}</td>
		<td class="req_files_count">{$site.status.reqcount}</td>
		<td class="req_size">{$site.status.reqsize}</td>
	</tr>
	{/foreach}


	<!--

	<tr>
	<td class="official"><img height="16" width="16" src="files/non-official.png" alt="non-official"/></td>

		<td>
		<a name="ubuntu" href="ubuntu/" title="基于 Debian 的以桌面应用为主的 Linux 发行版。">
				ubuntu			</a>
		</td>
		<td><a href='http://www.guxiang.net.cn/' target='_blank'>c0710204</a></td>
					<td class="sync-state sync-__ubuntu__state_en__">__ubuntu__state_zh__</td>
		
		<td class="size">__ubuntu__size__</td>
		<td class="files_count">__ubuntu__filecount__</td>
		<td>5/29/2013</td>
				<td class="req_files_count">N/A</td>
		<td class="req_size">N/A</td>
	</tr>

	<tr>
	<td class="official"><img height="16" width="16" src="files/non-official.png" alt="non-official"/></td>

		<td>
		<a name="openstack" href="openstack/" title="">
				openstack			</a>
		</td>
		<td><a href='http://www.guxiang.net.cn/' target='_blank'>c0710204</a></td>
					<td class="sync-state sync-__ubuntu__state_en__">__ubuntu__state_zh__</td>
		
		<td class="size">__openstack__size__</td>
		<td class="files_count">__openstack__filecount__</td>
		<td>5/29/2013</td>
				<td class="req_files_count">N/A</td>
		<td class="req_size">N/A</td>
	</tr>
	-->
	</tbody>
</table> <!-- id="status-main-table" -->
<div id="status-table-footnote">
<ul>
<li>第一列显示是否为发行版/项目的官方软件源。</li>
<li>对于正在同步和同步失败的镜像，大小、文件总数、同步完成时间等信息取自最近一次成功同步时的日志。</li>
<li>请求次数/数据量取自最近七日的 HTTP 请求。</li>
</ul>
</div> <!-- end of status-table-footnote div -->
</div> <!-- end of status-table div -->
</div> <!-- end of content div -->

<div id="footer">
<div class="tuna-logo">
<p>Powered by <a href="http://iflab.org/">ifLab.org</a>
</p>
</div>
<div class="ack">
<p>本站的网络和硬件由北京信息科技大学网管中心提供支持。</p>
</div>
</div> <!-- end of footer div -->
<!--

-->
</div> <!-- end of div wrapper -->
</body>
</html>
<!-- vi: se noet ts=4: -->
