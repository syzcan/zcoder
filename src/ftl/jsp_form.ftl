<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/style.jsp"%>
<form action="${r"${ctx}"}/${objectName}/${r"${formType=='edit'?'edit':'add'}"}" class="form-x" method="post">
	<div class="panel">
		<div class="panel-body">
			<#list tableEntity.primaries as columnField>
			<input type="hidden" name="${columnField.field}" value="${r"${"}${objectName}.${columnField.field} ${r"}"}" />
			</#list>
			<#list tableEntity.columnFields as columnField>
			<div class="form-group">
				<div class="label">
					<label><#if columnField.remark ?? && columnField.remark!="">${columnField.remark}<#else>${columnField.field}</#if></label>
				</div>
				<div class="field">
					<#if columnField.columnType=="text">
					<script type="text/plain" id="${columnField.field}Editor" name="${columnField.field}" style="width:600px;height:240px;">${r"${"}${objectName}.${columnField.field} ${r"}"}</script>
					<script>UM.getEditor('${columnField.field}Editor');</script>				
					<#else>
					<input type="text" class="input input-auto" name="${columnField.field}" value="<#if columnField.jdbcType=="TIMESTAMP"><fmt:formatDate value="${r"${"}${objectName}.${columnField.field} ${r"}"}" pattern="yyyy-MM-dd"/><#else>${r"${"}${objectName}.${columnField.field} ${r"}"}</#if>" <#if columnField.canNull=='NO'>data-validate="required:请填写信息"</#if><#if columnField.jdbcType=="TIMESTAMP">onclick="laydate()"</#if> size="20" />
					</#if>
				</div>
			</div>
			</#list>
		</div>
		<div class="panel-foot text-right">
			<button class="button bg-green" type="button" onclick="saveForm(this)">保存</button>
		</div>
	</div>
</form>	
<script>
	function saveForm(obj) {
		//校验表单
		var $form = $(obj).parents('form');
		$form.ajaxSubmit(function() {
			formAjax();
		});
	}
</script>