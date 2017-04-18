<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath }" />
<!DOCTYPE html>
<html lang="zh-cn">
<head>
<title>月光边境</title>
<meta name="keywords" content="关键词" />
<meta name="description" content="描述" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<link rel="stylesheet" href="${ctx }/static/css/pintuer.css" />
<link rel="shortcut icon" href="${ctx }/static/image/favicon.ico"/>
<script type="text/javascript" src="${ctx }/static/js/jquery.min.js"></script>
<script type="text/javascript" src="${ctx }/static/js/pintuer.js"></script>
<script type="text/javascript" src="${ctx }/plugins/layer/layer.js"></script>

<link rel="stylesheet" href="${ctx }/tools/css/codemirror.css" />
<link rel="stylesheet" href="${ctx }/tools/css/jsoneditor.min.css" />
<link rel="stylesheet" href="${ctx }/tools/css/font-awesome.min.css" />
<script type="text/javascript" src="${ctx }/tools/js/jquery.format.js"></script>
<script type="text/javascript" src="${ctx }/tools/js/codemirror.min.js"></script>
<script type="text/javascript" src="${ctx }/tools/js/jsoneditor.min.js"></script>
<script type="text/javascript" src="${ctx }/tools/js/ObjTree.min.js"></script>
<script type="text/javascript" src="${ctx }/tools/js/json-format.js"></script>
<script type="text/javascript" src="${ctx }/tools/js/xml.js"></script>
<script type="text/javascript" src="${ctx }/tools/js/htmlmixed.js"></script>

<script type="text/javascript" src="${ctx }/tools/js/foldcode.js"></script>
<script type="text/javascript" src="${ctx }/tools/js/foldgutter.js"></script>
<script type="text/javascript" src="${ctx }/tools/js/brace-fold.js"></script>
<script type="text/javascript" src="${ctx }/tools/js/xml-fold.js"></script>
<script type="text/javascript" src="${ctx }/tools/js/indent-fold.js"></script>
<script type="text/javascript" src="${ctx }/tools/js/markdown-fold.js"></script>
<script type="text/javascript" src="${ctx }/tools/js/comment-fold.js"></script>
<style type="text/css">
.jsoneditor-poweredBy {
	display: none;
}

div.jsoneditor-menu {
	background-color: #96b97d;
	border: 1px solid #96b97d;
}

div.jsoneditor {
	border: 1px solid #96b97d;
}

.CodeMirror {
	border: 1px solid #ddd;
	font-family: monospace;
	height: 400px;
}
</style>
</head>
<body>
	<div class="container">
		<div class="panel-head">
			<select class="input input-auto border-main" id="type">
				<option value="GET">GET</option>
				<option value="POST">POST</option>
				<option value="PUT">PUT</option>
				<option value="DELETE">DELETE</option>
			</select>
			<input id="url" type="text" value="http://192.168.222.128:8080/common/tables.json" style="margin-left: -5px;" size="80" class="input input-auto border-main" placeholder="Enter Request URL"/> 
			<input type="button" value="Send" onclick="sendRequest()" class="button bg-main" style="border-left: 0 none;margin-left: -10px;border-top-left-radius:0;border-bottom-left-radius:0" />
			<input type="button" value="Params" class="button bg-blue" />
		</div>
		<div class="">
			<table class="table" id="pathParam">
				<tr>
					<td><input type="text" placeholder="key" class="input auto" /></td>
					<td><input type="text" placeholder="value" class="input auto" /></td>
					<td><a href="javascript:;" onclick="addPathParam()" class="icon-plus-circle text-green text-big"></a></td>
				</tr>
			</table>
		</div>
		<div class="tab">
			<div class="tab-head">
				<ul class="tab-nav">
					<li class="active"><a href="#tab-header">Headers</a></li>
					<li><a href="#tab-body">body</a></li>
				</ul>
			</div>
			<div class="tab-body">
				<div class="tab-panel active" id="tab-header">
					<table class="table" id="headerParam">
						<tr>
							<td><input type="text" placeholder="key" class="input auto" /></td>
							<td><input type="text" placeholder="value" class="input auto" /></td>
							<td><a href="javascript:;" onclick="addHeaderParam()" class="icon-plus-circle text-green text-big"></a></td>
						</tr>
					</table>
				</div>
				<div class="tab-panel" id="tab-body">
					<table class="table" id="bodyParam">
						<tr>
							<td><input type="text" placeholder="key" class="input auto" /></td>
							<td><input type="text" placeholder="value" class="input auto" /></td>
							<td><a href="javascript:;" onclick="addBodyParam()" class="icon-plus-circle text-green text-big"></a></td>
						</tr>
					</table>
				</div>
			</div>
		</div>
		<div class="panel">
				<div class="tab">
					<div class="tab-head bg padding-top">
						<ul class="tab-nav">
							<li class="active"><a href="#tab-Body">Body</a></li>
							<li><a href="#tab-Cookies">Cookies</a></li>
							<li><a href="#tab-Headers">Headers</a></li>
						</ul>
					</div>
					<div class="tab-body padding">
						<div class="tab-panel active" id="tab-Body" style="height: 400px;">
<!-- 						<textarea id="response" class="input" style="width: 100%;height: 400px;resize:none"></textarea> -->
							<div id="jsonEditor" style="width: 100%;height: 400px;display: none"></div>
							<textarea id="xmlEditor" style="width: 100%;height: 400px;resize:none"></textarea>
						</div>
						<div class="tab-panel" id="tab-Cookies" style="height: 400px;">
						</div>
						<div class="tab-panel" id="tab-Headers" style="height: 400px;">
						</div>
					</div>
				</div>
		</div>
	</div>
</body>
<script type="text/javascript">
	var jsonEditor = new JSONEditor($('#jsonEditor')[0], {mode:'code'});
	jsonEditor.setText('');
	var xmlEditor = CodeMirror.fromTextArea($('#xmlEditor')[0], {
		lineNumbers : true,
		matchBrackets : true,
		mode : "application/xml",
		indentUnit : 4,
		indentWithTabs : true,
		foldGutter: true,
	    gutters: ["CodeMirror-linenumbers", "CodeMirror-foldgutter"]
	  });
	//发送请求
	function sendRequest(){
		var type = $('#type').val();
		var url = $('#url').val();
		var reg = /^[a-zA-z]+:\/\/[^\s]*$/;
		if(!reg.test(url)){
			layer.msg('请求地址格式错误');
			return;
		}
		var data = {};
		data.type = type;
		data.url = url;
		$.post('${ctx}/restclient/request.json',data).done(function(data){
			if(data.errMsg=='success'){
				var response = data.data;
				var cookies = response.cookies;
				var headers = response.headers;
				var body = response.body;
				if(headers['Content-Type']=='application/json;charset=UTF-8'){
					body = JSON.stringify($.parseJSON(body), null, 2);
					jsonEditor.setText(body);
					$('#jsonEditor').show();
					$('.CodeMirror').hide();
				}else if(headers['Content-Type']=='application/xml;charset=UTF-8'){
					body = $.format(body, {method : 'xml'});
					xmlEditor.getDoc().setValue(body);
					$('#jsonEditor').hide();
					$('.CodeMirror').show();
					xmlEditor.foldCode();
				}else{
					xmlEditor.getDoc().setValue(body);
					$('#jsonEditor').hide();
					$('.CodeMirror').show();
					xmlEditor.foldCode();
				}
				$('#tab-Cookies').html('No cookies were returned by the server');
				$('#tab-Headers').html('');
				for(key in cookies){
					$('#tab-Cookies').append('<p><strong>'+key+':</strong> '+cookies[key]+'</p>');
				}
				for(key in headers){
					$('#tab-Headers').append('<p><strong>'+key+':</strong> '+headers[key]+'</p>');
				}
			}else{
				layer.msg(data.errMsg);			
			}
		});
	}
	function addPathParam(){
		addParam('pathParam');
	}
	function addHeaderParam(){
		addParam('headerParam');
	}
	function addBodyParam(){
		addParam('bodyParam');
	}
	function addParam(id){
		var $tr = $('#'+id).children().first().clone();
		$tr.find('a').attr('onclick','').click(function(){
			$(this).parent().parent().remove();
		}).attr('class','icon-minus-circle text-red text-big');
		$tr.find('input').val('');
		$('#'+id).append($tr);
	}
</script>
</html>