<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<nav class="navbar navbar-inverse navbar-fixed-top runoob-header" role="navigation">
	<div class="container">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
				<span class="sr-only">菜单切换</span> <span class="icon-bar"></span> <span class="icon-bar"></span> <span class="icon-bar"></span>
			</button>
			<a class="navbar-brand runoob-title" href="#">菜鸟工具</a>
		</div>
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul id="navbar" class="nav navbar-nav">
				<li class="dropdown hidden-sm"><a href="#" class="dropdown-toggle" data-toggle="dropdown" data-hover="dropdown" role="button" aria-expanded="false">zdbclient <span
						class="caret"></span></a>
					<ul class="dropdown-menu" role="menu">
						<li><a class="icon-th-list" href="${ctx }/dbs"> 数据连接</a></li>
						<li><a href="${ctx}/config/config"><span class="icon-cogs"></span> 数据源</a></li>
						<li><a class="icon-file" href="${ctx}/templates"> 代码模板</a></li>
						<li><a class="icon-code" href="${ctx}/code"> 代码高亮</a></li>
					</ul></li>
				<li><a href="${ctx}/tools/html.jsp">HTML格式化</a></li>
				<li><a href="${ctx}/tools/css.jsp">CSS格式化</a></li>
				<li><a href="${ctx}/tools/js.jsp">JS格式化</a></li>
				<li><a href="${ctx}/tools/xml.jsp">XML格式化</a></li>
				<li><a href="${ctx}/tools/json.jsp">JSON格式化</a></li>
				<li><a href="${ctx}/tools/xml2json.jsp">XML转换JSON</a></li>
				<li><a href="${ctx}/tools/md5.jsp">MD5加密</a></li>
				<li><a href="${ctx}/tools/rgb.jsp">RGB转16进制</a></li>
			</ul>
		</div>
	</div>
</nav>