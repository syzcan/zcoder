<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
<title>zcoder代码高亮</title>
<meta name="keywords" content="关键词" />
<meta name="description" content="描述" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<%@ include file="/WEB-INF/jsp/common/style.jsp"%>
<script type="text/javascript" src="${ctx }/tools/js/jquery.format.js"></script>
<script type="text/javascript" src="${ctx }/tools/js/bootstrap.min.js"></script>
<script type="text/javascript" src="${ctx }/tools/js/bootstrap-hover-dropdown.js"></script>
<script type="text/javascript" src="${ctx }/tools/js/codemirror.min.js"></script>
<script type="text/javascript" src="${ctx }/tools/js/css.js"></script>
<script type="text/javascript" src="${ctx }/tools/js/format.js"></script>
<script type="text/javascript" src="${ctx }/tools/js/htmlmixed.js"></script>
<script type="text/javascript" src="${ctx }/tools/js/javascript.js"></script>
<script type="text/javascript" src="${ctx }/tools/js/jsoneditor.min.js"></script>
<script type="text/javascript" src="${ctx }/tools/js/ObjTree.min.js"></script>
<script type="text/javascript" src="${ctx }/tools/js/xml.js"></script>
<script type="text/javascript" src="${ctx }/tools/js/json-format.js"></script>
<style>
.syntaxhighlighter{background:white!important;}
</style>
</head>
<body>
	<%@ include file="/WEB-INF/jsp/common/nav.jsp"%>
	<div class="admin">
		<div class="panel admin-panel">
			<div class="panel-head border-blue" id="buttonList">
				代码高亮： 
				<button type="button" class="button">java</button>
				<button type="button" class="button">python</button>
				<button type="button" class="button">xml</button>
				<button type="button" class="button">html</button>
				<button type="button" class="button">javascript</button>
				<button type="button" class="button">css</button>
				<button type="button" class="button">sql</button>
				<a href="javascript:;" class="icon-copy text-green text-large float-right"
					onclick="selectText()" title="复制代码"></a>
			</div>
		</div>
		<div>
			<textarea class="input" style="width: 100%; height: 300px;resize:none" placeholder="源代码"></textarea>
		</div>
		<div id="preview"></div>
	</div>
</body>
<script type="text/javascript">
	$(function(){
		$('#buttonList button').click(function(){
			var pre = '<pre class="brush:'+$(this).text()+';toolbar:false;quick-code:false">';
			$('#buttonList button').removeClass('active');
			$(this).addClass('active');
			//特殊字符转义
			code = $('textarea').val();
			//格式化
			if($(this).html()=='java'||$(this).html()=='javascript'){
				code = js_beautify(code, 1, '\t');
			}
			if($(this).html()=='xml'){
				code = $.format(code, {method : 'xml'});
			}
			if($(this).html()=='html'){
				code = style_html(code, 1, '\t');
			}
			if($(this).html()=='css'){
				code = CSSPacker['format'](code);
			}
			//特殊字符转义
			code = code.replace(/</g,"&lt;").replace(/>/g,"&gt;");
			$('#preview').html(pre+code+'</pre>');
			//代码高亮
			SyntaxHighlighter.highlight();
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
	//设置框取消焦点后，当前代码更新
	$('textarea').blur(function(){
		$('#buttonList button.active').click();
	});
</script>
</html>