<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
<title>月光边境-${dbname }</title>
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
			<div class="panel-head">
					数据连接：【${dbname }】 表数量： 【${tables.size() }】
					快速定位：<input name="tableName" placeholder="表名" type="text" class="input input-auto border-main">
			</div>
			<table class="table table-hover table-condensed">
				<thead>
					<tr>
						<th width="50px">序号</th>
						<th>表名</th>
						<th>备注</th>
						<th>行</th>
						<th>操作</th>
					</tr>
				</thead>
				<c:forEach items="${tables }" var="table" varStatus="vs">
					<tr>
						<td class="text-center">${vs.count }</td>
						<td class="tableName" id="${table.tableName }">${table.tableName }</td>
						<td>${table.comment }</td>
						<td>${table.totalResult }</td>
						<td>
							<a class="button border-blue button-little" href="${ctx}/${dbname }/tables/${table.tableName }" target="_blank">结构</a>
							<a class="button border-green button-little" href="${ctx}/${dbname }/tables/${table.tableName }/datas" target="_blank">数据</a>
							<a class="button border-yellow button-little" href="${ctx}/${dbname }/tables/${table.tableName }/code" target="_blank">代码</a>
							<a class="button border-red button-little" href="${ctx}/${dbname }/tables/${table.tableName }/sqldatas" target="_blank">查询</a>
						</td>
					</tr>
				</c:forEach>
			</table>
		</div>
	</div>
</body>
<script type="text/javascript">
$('input[name="tableName"]').keyup(function(){
	var $cur = $(this);
	var name = $.trim($(this).val());
	$('.tableName').each(function(){
		if($(this).attr('id').indexOf(name)==0){
			location.href = location.href.split('#')[0]+'#'+$(this).attr('id');
			return false;
		}
	});
});
</script>
</html>