<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
<title>月光边境</title>
<meta name="keywords" content="关键词" />
<meta name="description" content="描述" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<%@ include file="/WEB-INF/jsp/common/style.jsp"%>
</head>
<body>
	<div class="margin">
		<div class="panel">
			<div class="panel-head">
				<form action="${r"${ctx}"}/${objectName}/list">
					<input type="button" class="button border-green" value="新增" onclick="openView('新增','${r"${ctx}"}/${objectName}/toAdd')" />
					<input type="button" class="button border-red" value="删除" onclick="deleteForm('dataForm',this)" action="${r"${ctx}"}/${objectName}/deleteAll" />
					<input name="keyword" value="${r"${page.pd.keyword }"}" type="text" style="margin-left: 50px" class="input input-auto border-main" placeholder="输入关键字"> 
					<input type="submit" value="搜索" class="button  bg-main" style="border-left: 0 none;margin-left: -10px;border-top-left-radius:0;border-bottom-left-radius:0" />
				</form>
			</div>
			<form id="dataForm" method="post">
				<table class="table table-hover">
					<thead>
						<tr>
							<th><input type="checkbox" class="checkall" name="checkall" checkfor="id" /></th>
							<#list normalColumns as columnField>
							<#if columnField.remark ?? && columnField.remark!="">
							<th>${columnField.remark}</th>
							<#else>
							<th>${columnField.field}</th>
							</#if>
							</#list>
							<th>操作</th>
						</tr>
					</thead>
					<c:forEach items="${r"${"}${objectName}s ${r"}"}" var="${objectName}">
						<tr>
							<td>
								<input type="checkbox" name="id" value="${r"${"}${objectName}.${primary.field} ${r"}"}" />
							</td>
							<#list normalColumns as columnField>
							<#if columnField.jdbcType=="TIMESTAMP">
							<td><fmt:formatDate value="${r"${"}${objectName}.${columnField.field} ${r"}"}" pattern="yyyy-MM-dd"/></td>
							<#else>
							<td>${r"${"}${objectName}.${columnField.field} ${r"}"}</td>
							</#if>
							</#list>
							<td>
								<a class="button border-green button-little" href="javascript:;" onclick="openDiv('<strong>${r"${"}${objectName}.${primary.field} ${r"}"}</strong>','${r"${ctx}"}/${objectName}/view?${primary.field}=${r"${"}${objectName}.${primary.field} ${r"}"}','760px','600px')">查看</a>
								<a class="button border-blue button-little" href="javascript:;" onclick="openView('修改','${r"${ctx}"}/${objectName}/toEdit?${primary.field}=${r"${"}${objectName}.${primary.field} ${r"}"}')">修改</a> 
								<a class="button border-yellow button-little" href="javascript:;" onclick="ajaxDeleteData('${r"${ctx}"}/${objectName}/delete?${primary.field}=${r"${"}${objectName}.${primary.field} ${r"}"}')">删除</a>
							</td>
						</tr>
					</c:forEach>
				</table>
			</form>
			<div class="panel-foot text-center">
				<form action="${r"${ctx}"}/${objectName}/list">
					<%@ include file="/WEB-INF/jsp/common/pagination.jsp"%>
				</form>
			</div>
		</div>
	</div>
</body>
</html>