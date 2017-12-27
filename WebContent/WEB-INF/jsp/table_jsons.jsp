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
#dataList pre{line-height: 18px;float: left;margin: 5px}
</style>
</head>
<body>
	<%@ include file="/WEB-INF/jsp/common/nav.jsp"%>
	<div class="admin">
		<div class="panel admin-panel">
		<div class="panel-head">
				数据连接：【<a href="${ctx}/${dbname}/tables">${dbname }</a> > ${tableName }
				<a class="button button-little border-blue" href="${ctx}/${dbname }/tables/${tableName }">结构</a>
				<a class="button button-little bg-blue" href="${ctx}/${dbname }/tables/${tableName }/datas">数据</a>
				<a class="button button-little border-blue" href="${ctx}/${dbname }/tables/${tableName }/code">代码</a>
				<a class="button button-little border-blue" href="${ctx}/${dbname }/tables/${tableName }/sqldatas">查询</a>
				】
			</div>
			<div style="overflow-x:scroll">
			<table class="table  table-condensed table-bordered" id="dataList">
				<thead>
					<tr>
						<th>json</th>
					</tr>
				</thead>
				
					<tr>
						<td>
						<c:forEach items="${datas }" var="data">
							<pre>${data }</pre>
						</c:forEach>
						</td>
					</tr>
			</table>
			</div>
		<div class="panel-foot text-center">
			<form id="pageForm" action="${ctx}/${dbname }/tables/${tableName}/jsons">
				<input type="hidden" name="orderColumn" value="${page.pd.orderColumn}" />
				<input type="hidden" name="orderType" value="${page.pd.orderType}" />
				<%@ include file="/WEB-INF/jsp/common/pagination.jsp"%>
			</form>
		</div>
		</div>
	</div>
</body>
</html>