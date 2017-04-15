<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
<title>*${tableName }</title>
<meta name="keywords" content="关键词" />
<meta name="description" content="描述" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<%@ include file="/WEB-INF/jsp/common/style.jsp"%>
<style type="text/css">
#dataList tr>td:first-child,#dataList tr>th:first-child{border-left: none;}
#dataList tr>td:last-child,#dataList tr>th:last-child{border-right: none;}
#dataList th{border-top: none;}
</style>
</head>
<body>
	<%@ include file="/WEB-INF/jsp/common/nav.jsp"%>
	<div class="admin">
		<div class="panel admin-panel">
		<div class="panel-head">
			<form action="${ctx}/${dbname}/tables/${tableName }/sqldatas" method="post">
				数据连接：【<a href="${ctx}/${dbname}/tables">${dbname }</a> > ${tableName }
				<a class="button button-little border-blue" href="${ctx}/${dbname }/tables/${tableName }">结构</a>
				<a class="button button-little border-blue" href="${ctx}/${dbname }/tables/${tableName }/datas">数据</a>
				<a class="button button-little border-blue" href="${ctx}/${dbname }/tables/${tableName }/code">代码</a>
				<button type="submit" class="button button-little bg-blue" >查询</button>
				】
				<input name="sql" value="${sql }" placeholder="sql" type="text" class="input margin-top">
				</form>
			</div>
			<div style="overflow-x:scroll">
			<table class="table table-hover table-condensed table-bordered" id="dataList">
				<thead>
					<tr>
						<th width="50px">序号</th>
						<c:forEach items="${datas[0] }" var="row" varStatus="vs">
							<th>${row.key }</th>
						</c:forEach>
					</tr>
				</thead>
				<c:forEach items="${datas }" var="rows" varStatus="vs">
					<tr>
						<td style="padding:0;text-align: center;">${vs.count }</td>
						<c:forEach items="${rows }" var="row" varStatus="vs">
							<td style="padding:0;min-width: 80px"><input style="width: 100%;height:25px;padding:0;border: 0" value="${row.value}"/></td>
						</c:forEach>
					</tr>
				</c:forEach>
			</table>
			</div>
		</div>
	</div>
</body>
</html>