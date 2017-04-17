<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<style>
.navbar-inverse .navbar-nav>.active>a, .navbar-inverse .navbar-nav>.active>a:focus, .navbar-inverse .navbar-nav>.active>a:hover{color:white;background-color: #5cb85c;}
</style>
<nav class="navbar navbar-inverse navbar-fixed-top runoob-header" role="navigation">
	<div class="container">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
				<span class="sr-only">菜单切换</span> <span class="icon-bar"></span> <span class="icon-bar"></span> <span class="icon-bar"></span>
			</button>
			<a class="navbar-brand runoob-title" href="${ctx }/dbs"><img src="${ctx }/static/image/logo.png" style="display: inline;"> zcoder</a>
		</div>
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul id="navbar" class="nav navbar-nav">
				<li class="${fn:indexOf(pageContext.request.requestURI,'tools/html.jsp')>0?'active':''}"><a href="${ctx}/tools/html.jsp">HTML格式化</a></li>
				<li class="${fn:indexOf(pageContext.request.requestURI,'tools/css.jsp')>0?'active':''}"><a href="${ctx}/tools/css.jsp">CSS格式化</a></li>
				<li class="${fn:indexOf(pageContext.request.requestURI,'tools/js.jsp')>0?'active':''}"><a href="${ctx}/tools/js.jsp">JS格式化</a></li>
				<li class="${fn:indexOf(pageContext.request.requestURI,'tools/xml.jsp')>0?'active':''}"><a href="${ctx}/tools/xml.jsp">XML格式化</a></li>
				<li class="${fn:indexOf(pageContext.request.requestURI,'tools/json.jsp')>0?'active':''}"><a href="${ctx}/tools/json.jsp">JSON格式化</a></li>
				<li class="${fn:indexOf(pageContext.request.requestURI,'tools/xml2json.jsp')>0?'active':''}"><a href="${ctx}/tools/xml2json.jsp">XML转换JSON</a></li>
				<li class="${fn:indexOf(pageContext.request.requestURI,'tools/md5.jsp')>0?'active':''}"><a href="${ctx}/tools/md5.jsp">MD5加密</a></li>
				<li class="${fn:indexOf(pageContext.request.requestURI,'tools/rgb.jsp')>0?'active':''}"><a href="${ctx}/tools/rgb.jsp">RGB转16进制</a></li>
			</ul>
		</div>
	</div>
</nav>