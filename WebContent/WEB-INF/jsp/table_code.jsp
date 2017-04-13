<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
<title>${tableName }-代码生成</title>
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
			<div class="panel-head" id="buttonList">
				数据连接：【<a href="${ctx}/${dbname}/tables">${dbname }</a> > ${tableName }<c:if test="${empty tableEntity.primary}"><strong class="text-red">【无主键】 </strong></c:if>
				<a class="button button-little border-blue" href="${ctx}/${dbname }/tables/${tableName }">结构</a>
				<a class="button button-little border-blue" href="${ctx}/${dbname }/tables/${tableName }/datas">数据</a>
				<a class="button button-little bg-blue" href="${ctx}/${dbname }/tables/${tableName }/code">代码</a>
				<a class="button button-little border-blue" href="${ctx}/${dbname }/tables/${tableName }/sqldatas">查询</a>
				】
				packageName：<input id="packageName" type="text" class="input input-auto border-main" value="${configData.packageName }">
				objectName：<input id="objectName" type="text" class="input input-auto border-main" value="${tableEntity.objectName }">
				className：<input id="className" type="text" class="input input-auto border-main" value="${tableEntity.className }">
				<br><br>
				<c:forEach items="${templates }" var="template" varStatus="vs">
				<button type="button" class="button border-blue ${vs.count==1?'active':'' }"
					data-url="${ctx}/${dbname }/tables/${tableName }/code/${template }.json" data-type="${template.indexOf('Xml')>-1?'xml':(template.indexOf('jsp')>-1?'html':'java') }">${template }</button>
				</c:forEach>
				<a href="javascript:;" class="button border-yellow" onclick="beetlCode('${ctx}/${dbname }/tables/${tableName }/beetlCode')">beetlCode</a>
				<a href="javascript:;" class="icon-copy text-green text-large float-right" onclick="selectText()" title="复制代码"></a>
				<a href="javascript:;" class="icon-cloud-download text-red text-large float-right margin-right" onclick="downCode()" title="下载代码"></a>
			</div>

		</div>
		<div>
			<textarea class="input" style="width: 100%; height: 300px; resize:none;display: none;" placeholder="beetl模板代码"></textarea>
		</div>
		<div id="preview">
		</div>
	</div>
</body>
<%-- <c:if test="${!empty tableEntity.primary}"> --%>
<script type="text/javascript">
	$(function(){
		$('#buttonList button').click(function(){
			var pre = '<pre class="brush:'+$(this).attr('data-type')+';toolbar:false;quick-code:false">';
			$('#buttonList button').removeClass('active');
			$(this).addClass('active');
			$('textarea').hide();
			$.ajax({
				url:$(this).attr('data-url')+'?objectName='+$.trim($('#objectName').val())+'&className='+$.trim($('#className').val())+'&packageName='+$.trim($('#packageName').val()),
				type:'post',
				dataType:'text',
				success:function(data){
					//特殊字符转义
					data = data.replace(/</g,"&lt;").replace(/>/g,"&gt;");
					$('#preview').html(pre+data+'</pre>');
					//代码高亮
					SyntaxHighlighter.highlight();
				}
			});
		});
		$('#buttonList button:eq(0)').click();
	});
	//选中代码div并复制到粘贴板
	function selectText() {
	    var text = $('.container')[0];
	    if (document.body.createTextRange) {
	        var range = document.body.createTextRange();
	        range.moveToElementText(text);
	        range.select();
	    } else if (window.getSelection) {
	        var selection = window.getSelection();
	        var range = document.createRange();
	        range.selectNodeContents(text);
	        selection.removeAllRanges();
	        selection.addRange(range);
	    } else {
	        alert("none");
	    }
	    document.execCommand("Copy"); //执行浏览器复制命令
	}
	function downCode(){
			location.href='${ctx}/${dbname }/tables/${tableName}/downCode?objectName='+$.trim($('#objectName').val())+'&className='+$.trim($('#className').val())+'&packageName='+$.trim($('#packageName').val());
	}
	//设置框取消焦点后，当前代码更新
	$('#buttonList input').blur(function(){
		$('#buttonList button.active').click();
	});
	
	function beetlCode(url){
		$('textarea').show();
		if($.trim($('textarea').val())==''){
			$('textarea').focus();
			return;
		}
		var pre = '<pre class="brush:xml;toolbar:false;quick-code:false">';
		$.ajax({
			url:url,
			type:'post',
			dataType:'text',
			data:{
				btl:$('textarea').val()
			},
			success:function(data){
				//特殊字符转义
				data = data.replace(/</g,"&lt;").replace(/>/g,"&gt;");
				$('#preview').html(pre+data+'</pre>');
				//代码高亮
				SyntaxHighlighter.highlight();
			}
		});
	}
</script>
<%-- </c:if> --%>
</html>