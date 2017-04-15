<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
<title>zcoder</title>
<meta name="keywords" content="关键词" />
<meta name="description" content="描述" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<%@ include file="/tools/style.jsp"%>
<style>
.CodeMirror {
  font-family: monospace;
  height: 400px;
}
</style>
</head>
<body>
<%@ include file="/tools/nav.jsp"%>
	<div class="container">
	<br>
		<div class="row">
			<div class="col-md-12">
				<div class="panel panel-default">
					<div id="compiler" class="panel-heading">
						<form class="form-inline" role="form">
							<label> <strong style="font-size: 16px"><i class="fa fa-cogs"></i> XML 在线格式化</strong>
							</label>
						</form>
					</div>
					<div class="panel-body">
						<form role="form" id="compiler-form">
							<div class="form-group">
								<div class="row">
									<div class="col-md-12">
										<textarea class="form-control" id="code" name="code" rows="10"></textarea>
									</div>
									<div class="col-md-12">
										<form class="form-inline" role="form">
											<button type="button" class="btn btn-success" id="submitBTN">
												<i class="fa fa-expand"></i> 格式化
											</button>
											<button type="button" class="btn btn-default" id="submitBTN2">
												<i class="fa fa-compress"></i> 压缩
											</button>
										</form>
									</div>
								</div>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
	<script>
		var editor1 = CodeMirror.fromTextArea(document.getElementById("code"),
				{
					lineNumbers : true,
					matchBrackets : true,
					mode : "application/xml",
					indentUnit : 4,
					indentWithTabs : true,
				});

		$("#submitBTN").click(function() {
			var str = editor1.getValue();
			result = $.format(str, {
				method : 'xml'
			});
			editor1.getDoc().setValue(result);
		});

		$("#submitBTN2").click(function() {
			var str = editor1.getValue();
			result = $.format(str, {
				method : 'xmlmin'
			});
			editor1.getDoc().setValue(result);
		});
	</script>
</body>
</html>