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
							<button type="button" class="btn btn-success" id="submitBTN">
								<i class="fa fa-compress"></i> 压缩
							</button>
							<button type="button" class="btn btn-default" id="submitBTN2">
								<i class="fa fa-expand"></i> 解压
							</button>
							<label class="pull-right"><strong style="font-size: 16px"><i class="fa fa-cogs"></i> CSS 压缩/解压工具</strong></label>
						</form>
					</div>
					<div class="panel-body">
						<div class="col-md-12" id="warning" style="display: none;">
							<div class="alert alert-warning">
								<a href="#" class="close" data-dismiss="alert"> &times; </a>
								<p>
									<strong>警告！</strong>JSON 格式错误。
								</p>
								<p id="warning-info"></p>
							</div>
						</div>
						<form role="form" id="compiler-form">
							<div class="form-group">
								<div class="row">
									<div class="col-md-6">
										<textarea class="form-control" id="code" name="code" rows="10"></textarea>
									</div>
									<div class="col-md-6">
										<textarea placeholder="运行结果……" class="form-control" id="compiler-textarea-result" rows="10"></textarea>
									</div>
								</div>
							</div>

						</form>
					</div>
				</div>
			</div>


		</div>
		<style type="text/css">
.CodeMirror {
	height: 500px;
}
</style>
		<script>
			var editor1 = CodeMirror.fromTextArea(document
					.getElementById("code"), {
				lineNumbers : true,
				matchBrackets : true,
				mode : "text/css",
				indentUnit : 4,
				indentWithTabs : true,
			});
			var editor2 = CodeMirror.fromTextArea(document
					.getElementById("compiler-textarea-result"), {
				lineNumbers : true,
				lineWrapping : true,
				matchBrackets : true,
				mode : "text/css",
				indentUnit : 4,
				indentWithTabs : true,
			});

			$("#submitBTN").click(function() {

				loadingdata = '程序正在运行中……';
				$("#compiler-textarea-result").val(loadingdata);

				code = editor1.getValue();
				s = 'pack';
				output = CSSPacker[s](code);
				CSSPacker[s](document.getElementById('code').value)
				editor2.getDoc().setValue(output);
			});

			$("#submitBTN2").click(function() {
				loadingdata = '程序正在运行中……';
				$("#compiler-textarea-result").val(loadingdata);

				code = editor1.getValue();
				if (code) {
					s = 'format';
					result = CSSPacker[s](code);
					editor2.getDoc().setValue(result);
				}
			});
			$("#submitBTN3")
					.click(
							function() {
								var content = editor1.getValue();

								if (content.trim().length == 0) {
									return false;
								}

								try {
									var jsonStr = editor1.getValue();
									var json = JSON.parse(jsonStr);
									$("#warning")
											.html(
													"<div class=\"alert alert-success\">JSON 数据合法</div>")
											.show().delay(5000).fadeOut();
								} catch (e) {
									$("#warning").html(
											"<div class=\"alert alert-danger\">JSON 数据错误："
													+ e + "</div>").show()
											.delay(5000).fadeOut();
								}

							});

			function jsonToxml() {

				var content = editor1.getValue();

				if (content.trim().length == 0) {
					return false;
				}

				try {
					var jsonStr = editor1.getValue();
					var json = JSON.parse(jsonStr);
					var xotree = new XML.ObjTree();
					var xml = xotree.writeXML(json);
					xml = decodeSpecialCharacter(xml);

					editor2.setOption("mode", 'application/xml');
					formatXML = $.format(xml, {
						method : 'xml'
					});
					editor2.getDoc().setValue(formatXML);
				} catch (e) {
					$("#warning").html(
							"<div class=\"alert alert-danger\">JSON 数据错误：" + e
									+ "</div>").show().delay(5000).fadeOut();
				}
			}
			function decodeSpecialCharacter(str) {
				return str.replace(/\&amp;/g, '&').replace(/\&gt;/g, '>')
						.replace(/\&lt;/g, '<').replace(/\&quot;/g, '"');
			}

			function jsonTocsv() {

				var content = editor1.getValue();

				if (content.trim().length == 0) {
					return false;
				}

				try {
					var jsonStr = editor1.getValue();
					var json = JSON.parse(jsonStr);
					var csv = jsonTocsvbyjson(json);

					editor2.setOption("mode", 'text/x-q');
					editor2.getDoc().setValue(csv);

				} catch (e) {
					$("#warning").html(
							"<div class=\"alert alert-danger\">JSON 数据错误：" + e
									+ "</div>").show().delay(5000).fadeOut();
				}
			}
			function jsonTocsvbyjson(data) {

				arr = [];
				flag = true;

				var header = "";
				var content = "";
				var headFlag = true;

				try {

					var type1 = typeof data;

					if (type1 != "object") {
						data = processJSON($.parseJSON(data));
					} else {
						data = processJSON(data);
					}

				} catch (e) {
					setMessage("error",
							"Error in Convert : add proper input format");
					return false;
				}

				$.each(data,
						function(k, value) {
							if (k % 2 == 0) {
								if (headFlag) {
									if (value != "end") {
										header += value + ",";
									} else {
										// remove last colon from string
										header = header.substring(0,
												header.length - 1);
										headFlag = false;
									}
								}
							} else {
								if (value != "end") {
									var temp = data[k - 1];
									if (header.search(temp) != -1) {
										content += value + ",";
									}
								} else {
									// remove last colon from string
									content = content.substring(0,
											content.length - 1);
									content += "\n";
								}
							}

						});

				return (header + "\n" + content);
			}
			function processJSON(data) {

				$.each(data, function(k, data1) {

					var type1 = typeof data1;

					if (type1 == "object") {

						flag = false;
						processJSON(data1);
						arr.push("end");
						arr.push("end");

					} else {
						arr.push(k, data1);
					}

				});

				return arr;
			}

			function jsonToyaml() {

				var content = editor1.getValue();

				if (content.trim().length == 0) {
					return false;
				}

				try {
					var jsonStr = editor1.getValue();
					var yaml = json2yaml(jsonStr);
					editor2.setOption("mode", 'text/x-q');
					editor2.getDoc().setValue(yaml);
				} catch (e) {
					$("#warning").html(
							"<div class=\"alert alert-danger\">JSON 数据错误：" + e
									+ "</div>").show().delay(5000).fadeOut();
				}
				last_action = "jsonToyaml";
			}

			var spacing = " ";
			function json2yaml(obj) {

				if (typeof obj == 'string') {
					obj = JSON.parse(obj);
				}

				var ret = [];
				console.log(typeof obj);
				convert(obj, ret);
				return ret.join("\n");
			};

			function getType(obj) {
				var type = typeof obj;

				if (obj instanceof Array) {
					return 'array';
				} else if (type == 'string') {
					return 'string';
				} else if (type == 'boolean') {
					return 'boolean';
				} else if (type == 'number') {
					return 'number';
				} else if (type == 'undefined' || obj === null) {
					return 'null';
				} else {
					return 'hash';
				}
			}

			function convert(obj, ret) {
				var type = getType(obj);

				switch (type) {
				case 'array':
					convertArray(obj, ret);
					break;
				case 'hash':
					convertHash(obj, ret);
					break;
				case 'string':
					convertString(obj, ret);
					break;
				case 'null':
					ret.push('null');
					break;
				case 'number':
					ret.push(obj.toString());
					break;
				case 'boolean':
					ret.push(obj ? 'true' : 'false');
					break;
				}
			}
			function convertArray(obj, ret) {
				for (var i = 0; i < obj.length; i++) {
					var ele = obj[i];
					var recurse = [];
					convert(ele, recurse);

					for (var j = 0; j < recurse.length; j++) {
						ret.push((j == 0 ? "- \n   " : spacing) + recurse[j]);
					}
				}
			}

			function convertHash(obj, ret) {
				for ( var k in obj) {
					var recurse = [];
					if (obj.hasOwnProperty(k)) {
						var ele = obj[k];
						convert(ele, recurse);
						var type = getType(ele);
						if (type == 'string' || type == 'null'
								|| type == 'number' || type == 'boolean') {
							ret.push(normalizeString(k) + ': ' + recurse[0]);
						} else {
							ret.push(normalizeString(k) + ': ');
							for (var i = 0; i < recurse.length; i++) {
								ret.push(spacing + recurse[i]);
							}
						}
					}
				}
			}

			function normalizeString(str) {
				if (str.match(/^[\w]+$/)) {
					return str;
				} else {
					return JSON.stringify(str);
				}
			}

			function convertString(obj, ret) {
				ret.push(normalizeString(obj));
			}
		</script>
	</div>
</body>
</html>