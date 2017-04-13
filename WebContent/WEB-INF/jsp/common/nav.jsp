<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div class="layout  bg-inverse " style="padding-bottom:40px">
	<div class="bg-main" style="z-index: 9;position: fixed;width:100%;">
		<div class="navbar">
			<!--描述：LOGO及系统名称-->
			<div class="navbar-head">
				<button class="button icon-navicon" data-target="#navbar1"></button>
				<a href="${ctx }/dbs"> <img src="http://www.pintuer.com/images/30-white.png"> <strong class="text-big hidden-l hidden-s">zcoder</strong></a>
			</div>
			<!--描述：导航-->
			<div class="navbar-body nav-navicon" id="navbar1">
				<ul class="nav nav-inline nav-menu">
					<li><a class="icon-cog" href="javascript:;">导航<span class="arrow"></span></a>
						<ul class="drop-menu">
							<li><a class="icon-th-list" href="${ctx }/dbs"> 数据连接</a></li>
							<li><a href="${ctx}/config/config"><span class="icon-cogs"></span> 数据源</a></li>
							<li><a class="icon-file" href="${ctx}/templates"> 代码模板</a></li>
							<li><a class="icon-code" href="${ctx}/code"> 代码高亮</a></li>
						</ul></li>
					<li><a class="icon-wrench" href="javascript:;">工具<span class="arrow"></span></a>
						<ul class="drop-menu">
							<li><a href="${ctx}/tools/html.jsp">HTML格式化</a></li>
							<li><a href="${ctx}/tools/css.jsp">CSS格式化</a></li>
							<li><a href="${ctx}/tools/js.jsp">JS格式化</a></li>
							<li><a href="${ctx}/tools/xml.jsp">XML格式化</a></li>
							<li><a href="${ctx}/tools/json.jsp">JSON格式化</a></li>
							<li><a href="${ctx}/tools/xml2json.jsp">XML转换JSON</a></li>
							<li><a href="${ctx}/tools/md5.jsp">MD5加密</a></li>
						</ul></li>
				</ul>
			</div>
		</div>
	</div>
</div>
<a class="icon-arrow-circle-up text-large" style="position: fixed;bottom: 20px;right: 20px" href="#"></a>