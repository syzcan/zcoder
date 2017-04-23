<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath }" />
<!DOCTYPE html>
<html lang="zh-cn">
<head>
<title>zcoder-rest客户端</title>
<meta name="keywords" content="关键词" />
<meta name="description" content="描述" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<link rel="stylesheet" href="${ctx }/static/css/pintuer.css" />
<link rel="shortcut icon" href="${ctx }/static/image/favicon.ico"/>
<script type="text/javascript" src="${ctx }/static/js/jquery.min.js"></script>
<script type="text/javascript" src="${ctx }/static/js/pintuer.js"></script>
<script type="text/javascript" src="${ctx }/plugins/layer/layer.js"></script>
<script type="text/javascript" src="${ctx }/plugins/layer/extend/layer.ext.js"></script>

<link rel="stylesheet" href="${ctx }/tools/css/codemirror.css" />
<link rel="stylesheet" href="${ctx }/tools/css/jsoneditor.min.css" />
<link rel="stylesheet" href="${ctx }/tools/css/font-awesome.min.css" />
<script type="text/javascript" src="${ctx }/tools/js/jquery.format.js"></script>
<script type="text/javascript" src="${ctx }/tools/js/codemirror.min.js"></script>
<script type="text/javascript" src="${ctx }/tools/js/jsoneditor.min.js"></script>
<script type="text/javascript" src="${ctx }/tools/js/ObjTree.min.js"></script>
<script type="text/javascript" src="${ctx }/tools/js/json-format.js"></script>
<script type="text/javascript" src="${ctx }/tools/js/xml.js"></script>
<script type="text/javascript" src="${ctx }/tools/js/format.js"></script>
<script type="text/javascript" src="${ctx }/tools/js/htmlmixed.js"></script>

<script type="text/javascript" src="${ctx }/tools/js/foldcode.js"></script>
<script type="text/javascript" src="${ctx }/tools/js/foldgutter.js"></script>
<script type="text/javascript" src="${ctx }/tools/js/brace-fold.js"></script>
<script type="text/javascript" src="${ctx }/tools/js/xml-fold.js"></script>
<script type="text/javascript" src="${ctx }/tools/js/indent-fold.js"></script>
<script type="text/javascript" src="${ctx }/tools/js/markdown-fold.js"></script>
<script type="text/javascript" src="${ctx }/tools/js/comment-fold.js"></script>

<link rel="stylesheet" href="${ctx }/plugins/webuploader/webuploader.css" />
<script type="text/javascript" src="${ctx }/plugins/webuploader/webuploader.min.js"></script>
<style type="text/css">
#rest-panel{font-size: 13px}
div.jsoneditor-menu {
	background-color: #0ae;
	border: 1px solid #0ae;
	display: none;
}

div.jsoneditor {
	border: 1px solid #ddd;
}
div.ace-jsoneditor .ace_gutter{
	background: #f7f7f7;
	color: #999;
}
div.jsoneditor-outer{
	margin-top: 0;
	padding-top: 0;
}
.ace_gutter-layer{
	border-right: 1px solid #ddd;
}

.CodeMirror {
	border: 1px solid #ddd;
	height: 200px;
	font-family: droid sans mono, consolas, monospace, courier new, courier, sans-serif;
	font-size: 13px;
	line-height: 1.3;
}
#response .CodeMirror {
	height: 400px;
}
.CodeMirror-foldgutter{
	width: 11px;
}
.tab .tab-nav li a{padding:5px 20px}
.icon-arrow-circle-up{display: none}
.webuploader-pick{padding-top:6px;border-radius:0}
.filePicker{
display: none;height: 30px;border-bottom:1px solid #ddd;overflow: hidden;
}
.fileSpan{
	margin-left:10px;
    top: 6px;
    position: absolute;
}
.table td{border:none;padding:0 5px}
.table .input{border-top:none;border-left:none;border-right:none;box-shadow:none;border-radius:0;background: none;height: 30px;font-size:13px}
</style>
</head>
<body>
	<%@ include file="/WEB-INF/jsp/common/nav.jsp"%>
	<div id="rest-panel" class="margin">
		<div class="border">
		<div class="padding bg">
			<select class="input input-auto border-main" id="method" style="border-top-right-radius:0;border-bottom-right-radius:0">
				<option value="GET">GET</option>
				<option value="POST">POST</option>
				<option value="PUT">PUT</option>
				<option value="DELETE">DELETE</option>
			</select>
			<input id="url" type="text" value="" style="margin-left: -5px;border-radius:0;width: 60%" class="input input-auto border-main" placeholder="Enter Request URL"/> 
			<input type="button" value="Send" onclick="sendRequest()" class="button bg-main" style="border-left: 0 none;margin-left: -5px;border-top-left-radius:0;border-bottom-left-radius:0" />
			<input type="button" value="Params" class="button border-main" onclick="showPathParam(this)" />
			<div class="padding-small">
			<table class="table table-condensed table-hover" style="display: none">
				<tbody id="pathParam">
					<tr>
						<td><input type="text" placeholder="key" class="input" /></td>
						<td><input type="text" placeholder="value" class="input" /></td>
						<td><a href="javascript:;" onclick="addPathParam()" class="icon-plus-circle text-green text-big"></a></td>
					</tr>
				</tbody>
			</table>
			</div>
		</div>
		<div class="tab">
			<div class="tab-head bg">
				<ul class="tab-nav">
					<li class="active"><a href="#tab-header">Headers</a></li>
					<li><a href="#tab-body" style="display: none;">body</a></li>
				</ul>
			</div>
			<div class="tab-body">
				<div class="tab-panel padding active" id="tab-header" style="margin-top: -10px">
					<table class="table table-condensed table-hover">
						<tbody id="headerParam">
							<tr>
								<td><input type="text" placeholder="key" class="input" /></td>
								<td><input type="text" placeholder="value" class="input" /></td>
								<td><a href="javascript:;" onclick="addHeaderParam()" class="icon-plus-circle text-green text-big"></a></td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="tab-panel padding" id="tab-body" style="margin-top: -10px">
					<input class="margin-left" type="radio" name="bodyType" value="form-data" checked="checked" /> form-data
					<input class="margin-left" type="radio" name="bodyType" value="x-www-form-urlencoded" /> x-www-form-urlencoded
					<input class="margin-left" type="radio" name="bodyType" value="raw" /> raw 
					<select id="rawType" style="display: none">
						<option value="text/plain;charset=UTF-8">text/plain</option>
						<option value="application/xml;charset=UTF-8">application/xml</option>
						<option value="application/json;charset=UTF-8">application/json</option>
					</select>
					<div style="margin-top: 10px">
					<table class="table table-condensed table-hover">
						<tbody id="form-data">
							<tr>
								<td width="45%"><input type="text" placeholder="key" class="input" /></td>
								<td width="45%">
								<input type="text" placeholder="value" class="input" />
								<div class="filePicker" id="filePicker">选择文件</div>
								</td>
								<td width="50px">
									<select class="input input-auto fieldType">
										<option value="text">text</option>
										<option value="file">file</option>
									</select>
								</td>
								<td width="50px"><a href="javascript:;" onclick="addBodyParam('form-data')" class="icon-plus-circle text-green text-big"></a></td>
							</tr>
						</tbody>
					</table>
					</div>
					<div style="margin-top: 10px;display: none;">
					<table class="table table-condensed table-hover">
						<tbody id="x-www-form-urlencoded">
							<tr>
								<td><input type="text" placeholder="key" class="input" /></td>
								<td><input type="text" placeholder="value" class="input" /></td>
								<td><a href="javascript:;" onclick="addBodyParam('x-www-form-urlencoded')" class="icon-plus-circle text-green text-big"></a></td>
							</tr>
						</tbody>
					</table>
					</div>
					<div id="raw" style="margin-top: 10px;display: none;">
						<div id="rawEditorJson" class="raw-item" style="width: 100%;height: 200px;display: none;"></div>
						<textarea id="rawEditor" class="raw-item" style="width: 100%;height: 200px;resize:none"></textarea>
					</div>
				</div>
			</div>
		</div>
		</div>
		<div class="border margin-top" id="response" style="position: relative;">
				<div id="statusMsg" style="position: absolute;right: 20px;top:18px;display: none">Status: <span class="text-blue margin-right"></span> Time: <span class="text-blue"></span></div>
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
						<div class="tab-panel" id="tab-Cookies" style="height: 400px;margin-left: 5px">
						</div>
						<div class="tab-panel" id="tab-Headers" style="height: 400px;margin-left: 5px;overflow-y: scroll;">
						</div>
					</div>
				</div>
		</div>
	</div>
</body>
<script type="text/javascript">
var jsonEditor = new JSONEditor($('#jsonEditor')[0], {
    mode: 'code'
});
jsonEditor.setText('');
var xmlEditor = getCodeEditor('xmlEditor','XML');
var rawEditor;
function getCodeEditor(id,type){
	var mode = '';
	if(type=='XML'){
		mode = 'application/xml';
	}
	return CodeMirror.fromTextArea($('#'+id)[0], {
	    lineNumbers: true,
	    matchBrackets: true,
	    mode: mode,
	    indentUnit: 4,
	    indentWithTabs: true,
	    foldGutter: true,
	    gutters: ["CodeMirror-linenumbers", "CodeMirror-foldgutter"]
	}); 
}
//发送请求
function sendRequest() {
    var method = $('#method').val();
    var url = $.trim($('#url').val());
    var bodyType = $('input[name="bodyType"]:checked').val();
    var reg = /^[a-zA-z]+:\/\/[^\s]*$/;
    if(url==''){
    	layer.msg('请填写请求地址');
    	return;
    }
    if (!reg.test(url)) {
        layer.msg('请求地址格式错误');
        return;
    }
    var data = {};
    var headers = {};
    var params = {};
    data.method = method;
    data.url = url;
    $('#headerParam tr').each(function(){
    	var key = $.trim($(this).find('input[placeholder="key"]').val());
		var value = $.trim($(this).find('input[placeholder="value"]').val());
		if(key!='' && value!=''){
			headers[key] = value;
		}
    });
    if(bodyType=='raw'){
    	var rawType = $('#rawType').val();
    	headers['Content-Type'] = rawType;
    	var value = '';
    	//CodeMirror取值用getValue
		if(typeof rawEditor.getValue === 'function'){
			value = rawEditor.getValue();
		}else{//JsonEditor取值用getText
			value = rawEditor.getText();
		}
    	params['payload'] = value;
    }else{
    	headers['Content-Type'] = bodyType;
    	$('#'+bodyType).find('tr').each(function(){
    		var key = $.trim($(this).find('input[placeholder="key"]').val());
    		var value = $.trim($(this).find('input[placeholder="value"]').val());
    		var fieldType = $(this).find('select').val();
    		if(key!=''){
    			if(bodyType=='form-data'){
	    			params[key] = fieldType + '|' + value;
    			}else{
	    			params[key] = value;
    			}
    		}
    	});
    }
    data.headers = headers;
    data.params = params;
    layer.load(1);
    var startTime = new Date();
    $.ajax({
		url : '${ctx}/restclient/request.json',
		contentType : 'application/json',
		type : 'POST',
		dataType : 'json',
		data : JSON.stringify(data),
		success : function(data) {
			layer.closeAll();
	        if (data.errMsg == 'success') {
	            var response = data.data;
	            var cookies = response.cookies;
	            var headers = response.headers;
	            var body = response.body;
	            if (headers['Content-Type'].indexOf('application/json')>-1) {
	                body = JSON.stringify($.parseJSON(body), null, 2);
	                jsonEditor.setText(body);
	                $('a[href="#tab-Body"]').click();
	                $('#jsonEditor').show();
	                $('#response .CodeMirror').hide();
	            } else {
	            	if (headers['Content-Type'].indexOf('application/xml')>-1) {
		                body = $.format(body, {
		                    method: 'xml'
		                });
		            } else if (headers['Content-Type'].indexOf('text/html')>-1) {
		                body = style_html(body, 1, '\t');
		            } else if (headers['Content-Type'].indexOf('image/')>-1) {
		                body = '<img src="'+url+'"/>';
		                layer.photos({
		                    photos: {
		                    	"data": [{"src": url }]
		                    }
		                });
		            }
		            xmlEditor.setValue(body);
		            $('a[href="#tab-Body"]').click();
		            $('#response .CodeMirror').show();
		            $('#jsonEditor').hide();
		            xmlEditor.setCursor(0);
	            }
	            $('#tab-Cookies').html('');
	            $('#tab-Headers').html('');
	            var cookieCount = 0;
	            var headerCount = 0;
	            for (key in cookies) {
	                $('#tab-Cookies').append('<p><strong>' + key + ':</strong> ' + cookies[key] + '</p>');
	                cookieCount++;
	            }
	            for (key in headers) {
	                $('#tab-Headers').append('<p><strong>' + key + ':</strong> ' + headers[key] + '</p>');
	                headerCount++;
	            }
	            if($('#tab-Cookies').html()==''){
	            	$('#tab-Cookies').html('No cookies were returned by the server');
	            }
	            if(cookieCount>0){
	            	$('a[href="#tab-Cookies"]').html('Cookies <span class="text-blue">('+cookieCount+')</span>');
	            }else{
	            	$('a[href="#tab-Cookies"]').html('Cookies');
	            }
	            if(headerCount>0){
	            	$('a[href="#tab-Headers"]').html('Headers <span class="text-blue">('+headerCount+')</span>');
	            }else{
	            	$('a[href="#tab-Headers"]').html('Headers');
	            }
	            var time = new Date().getTime()-startTime.getTime();
	            $('#statusMsg').show();
	            $('#statusMsg').find('span:eq(0)').html(response.statusCode+' '+response.statusText);
	            $('#statusMsg').find('span:eq(1)').html(time+' ms');
	        } else {
	            //layer.msg(data.errMsg);
	            xmlEditor.setValue(data.errMsg);
                $('a[href="#tab-Body"]').click();
                $('#response .CodeMirror').show();
                $('#jsonEditor').hide();
                xmlEditor.setCursor(0);
	        }
		}   
    });
}
function addPathParam() {
    addParam('pathParam');
    $('#pathParam a.icon-minus-circle').click(function(){
    	$(this).parent().parent().remove();
	    updatePathParam();
    });
}
function addHeaderParam() {
    addParam('headerParam');
}
function addBodyParam(id) {
    //addParam('bodyParam');
    addParam(id);
    if(id=='form-data'){
    	$('#form-data tr').last().find('select').val('text').change();
    	var filePickerId = 'filePicker'+new Date().getTime();
    	$('#form-data tr').last().find('.filePicker').attr('id',filePickerId).html('选择文件');
    }
}
function addParam(id) {
    var $tr = $('#' + id).children().first().clone(true);
    $tr.find('a').attr('onclick', '').click(function() {
        $(this).parent().parent().remove();
    }).attr('class', 'icon-minus-circle text-red text-big');
    $tr.find('input').val('');
    $('#' + id).append($tr);
}
function showPathParam(obj){
	if($('#pathParam').parent().css('display')!='none'){
		$('#pathParam').parent().hide();
	}else{
		$('#pathParam').parent().show();
	}
}
function updatePathParam(){
	var url = $('#url').val().split('\?')[0];
	var query = '';
	$('#pathParam tr').each(function(){
		var key = $.trim($(this).find('input[placeholder="key"]').val());
		var value = $.trim($(this).find('input[placeholder="value"]').val());
		if(key!=''){
			query += key+'='+value+"&";
		}
	});
	if(query!=''){
		url += '?'+query.substring(0,query.length-1);
	}
	$('#url').val(url);
}

$(function(){
	//修改pathParam参数项更新到地址栏
	$('#pathParam input[placeholder="key"]').keyup(function(){
		$('#pathParam tr:gt(0)').each(function(){
			if($.trim($(this).find('input:eq(0)').val())==''){
				$(this).remove();
			}
		});
		updatePathParam();
	});
	$('#pathParam input[placeholder="value"]').keyup(function(){
		updatePathParam();
	});
	//修改地址栏动态更新pathParam参数项
	$('#url').keyup(function(){
		var url = $('#url').val();
		$('#pathParam input').val('');
		var params = getQueryString(url);
		if($('#pathParam tr').length > params.length && params.length!=0){
			$('#pathParam tr:gt('+(params.length-1)+')').remove();
		} else if($('#pathParam tr').length < params.length){
			for(var i=1;i<=params.length-$('#pathParam tr').length;i++){
				addPathParam();
			}
		}
		$.each(params,function(i,n){
			var arr = n.split('=');
			var key = arr[0];
			var value = arr.length>1?arr[1]:0;
			$('#pathParam tr').eq(i).find('input[placeholder="key"]').val(key);
			$('#pathParam tr').eq(i).find('input[placeholder="value"]').val(value);
		});
	});
	//选择请求方法,GET不显示body参数框
	$('#method').change(function(){
		if($(this).val()=='GET'){
			$('a[href="#tab-header"]').click();
			$('a[href="#tab-body"]').hide();
		}else{
			$('a[href="#tab-body"]').show();
		}
	});
	//切换bodyParam
	$('input[name="bodyType"]').click(function(){
		$('#tab-body>div').hide();
		$('#tab-body>div').eq($(this).index()).show();
		if($(this).val()=='raw'){
			if(rawEditor==undefined){
				rawEditor = getCodeEditor('rawEditor','Text');
			}
			$('#rawType').show();
		}else{
			$('#rawType').hide();
		}
	});
	//下拉框切换fieldType
	$('.fieldType').change(function(){
		if($(this).val()=='file'){
			$(this).parent().prev().find('input').hide();
			var $filePicker = $(this).parent().prev().find('div');
			$filePicker.show().find('.fileSpan').html('');
			if($filePicker.html()=='选择文件'){
				createWebUploader($filePicker.attr('id'));
			}
		}else{
			$(this).parent().prev().find('input').show().val('');
			$(this).parent().prev().find('div').hide();
		}
	});
	// 切换raw输入框展示
	$('#rawType').change(function(){
		var value = '';
		if(typeof rawEditor.getValue === 'function'){
			value = rawEditor.getValue();
		}else{
			value = rawEditor.getText();
		}
		$('#raw').children().filter('[class!=raw-item]').remove();
		$('#rawEditorJson').html('');
		if($(this).val().indexOf('application/xml')>-1){
			$('#rawEditor').show();
			$('#rawEditorJson').hide();
			rawEditor = getCodeEditor('rawEditor','XML');
			rawEditor.getDoc().setValue(value);
		}else if($(this).val().indexOf('text/plain')>-1){
			$('#rawEditor').show();
			$('#rawEditorJson').hide();
			rawEditor = getCodeEditor('rawEditor','Text');
			rawEditor.getDoc().setValue(value);
		}else{
			$('#rawEditor').hide();
			$('#rawEditorJson').show();
			rawEditor = new JSONEditor($('#rawEditorJson')[0], {
			    mode: 'code'
			});
			rawEditor.setText(value);
		}
	});
});
//获取QueryString的数组
function getQueryString(url){
     var result = url.match(new RegExp("[\?\&][^\?\&]+=[^\?\&]*","g")); 
     if(result == null){
         return "";
     }
     for(var i = 0; i < result.length; i++){
         result[i] = result[i].substring(1);
     }
     return result;
}
function createWebUploader(id){
	var uploader = WebUploader.create({
		auto : true,
		swf : '${ctx }/plugins/webuploader/Uploader.swf',
		server : '${ctx }/restclient/uploadFile.json',
		pick : {id:'#'+id,multiple:false},
		accept : {
			title : 'Images',
			extensions : 'gif,jpg,jpeg,bmp,png',
			//直接用image/*在chrome下出现迟钝
			mimeTypes : 'image/gif,image/jpg,image/jpeg,image/bmp,image/png'
		}
	});
	// 上传开始弹出加载层
	uploader.on('uploadStart', function(file) {
		layer.load(1);
	});
	// 文件上传过程中创建进度条实时显示。
	uploader.on('uploadProgress', function(file, percentage) {
		var progress = '<div style="padding-top: 40px;text-align:center">'+parseInt(percentage*100)+'%</div>';
		$('.layui-layer[type="loading"] .layui-layer-content').html(progress);
	});
	// 文件上传成功
    uploader.on( 'uploadSuccess', function(file,data) {
    	layer.closeAll();
        $('#'+id).siblings('input').val(data.fileName+"|"+data.url);
        var $span = $('#'+id).find('.fileSpan');
        if($span.length > 0){
        	$span.html(data.fileName);
        }else{
        	$('#'+id).append('<span class="fileSpan">'+data.fileName+'</span>');
        }
	});
	uploader.on('uploadError', function(file,reason) {
		layer.closeAll();
		layer.msg('上传失败:'+reason);
	});
}
//根据传递参数快速构建页面
$(function(){
	var operation = '${param.operation}';
	if(operation==''){
		return;
	}
	$('#method').val('POST').trigger('change');
	$('a[href="#tab-body"]').click();
	$('input[name="bodyType"][value="x-www-form-urlencoded"]').click();
	$('#x-www-form-urlencoded input:eq(0)').val('craw_url');
	$('#x-www-form-urlencoded input:eq(1)').focus();
	$('#x-www-form-urlencoded a.icon-plus-circle').click().click();
	var domain = location.href.split('/restclient')[0];
	//爬取详情，爬取列表
	if(operation=='craw_detail'){
		$('#url').val(domain+'/craw/data.json');
	} else if(operation=='craw_list'){
		$('#url').val(domain+'/craw/list.json');
		$('#x-www-form-urlencoded tr:eq(1) input:eq(0)').val('craw_item');
		$('#x-www-form-urlencoded tr:eq(2) input:eq(0)').val('craw_next');
		$('#x-www-form-urlencoded a.icon-plus-circle').click().click();
	}
});
</script>
</html>