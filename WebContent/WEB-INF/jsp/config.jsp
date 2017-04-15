<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
<title>zcoder数据源设置</title>
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
			<div class="panel-head border-blue" id="buttonList">
				数据源设置
			</div>

		</div>
		<div id="preview">
			<textarea class="input" style="width: 100%;height: 500px">${content }</textarea>
		</div>
		<div class="panel-foot">
			<button type="button" class="button border-green" onclick="saveConfig()">保存</button>
		</div>
	</div>
</body>
<script type="text/javascript">
	function saveConfig(){
		$.ajax({
			url:'${ctx}/config/${name}/edit',
			type:'POST',
			dataType:'text',
			data:{
				content:$('#preview textarea').val()
			},
			success:function(data){
				if(data=='Y'){
					layer.msg('操作成功');
				}
			}
		});
	}
</script>
</html>