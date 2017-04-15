<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
<title>zcoder数据连接</title>
<meta name="keywords" content="关键词" />
<meta name="description" content="描述" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<%@ include file="/WEB-INF/jsp/common/style.jsp"%>
</head>
<body>
	<%@ include file="/WEB-INF/jsp/common/nav.jsp"%>
	<div class="admin">
		<div class="panel admin-panel">
			<table class="table table-hover">
				<thead>
					<tr>
						<th width="50px">序号</th>
						<th>链接名</th>
						<th>jdbc.driverClassName</th>
						<th>jdbc.url</th>
						<th>jdbc.username</th>
						<th>jdbc.password</th>
						<th>操作</th>
					</tr>
				</thead>
				<c:forEach items="${configData.dbs }" var="db" varStatus="vs">
					<tr>
						<td class="text-center">${vs.count }</td>
						<td>${db['dbname'] }</td>
						<td>${db['jdbc.driverClassName'] }</td>
						<td>${db['jdbc.url'] }</td>
						<td>${db['jdbc.username'] }</td>
						<td>${db['jdbc.password'] }</td>
						<td>
						<c:if test="${!empty db.dao }">
						<a class="button border-blue button-little"
							href="${ctx}/${db['dbname'] }/tables">查看</a>
							</c:if>
						<c:if test="${empty db.dao }">
							<span class="badge bg-red">连接失败</span>
						</c:if>
						</td>
					</tr>
				</c:forEach>
			</table>
		</div>
	</div>
</body>
</html>