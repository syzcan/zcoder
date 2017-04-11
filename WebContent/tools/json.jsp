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
<%@ include file="/tools/style.jsp"%>
</head>
<body>
<%@ include file="/tools/nav.jsp"%>
	<div class="container"><br>
		<style type="text/css">
.jsoneditor-poweredBy {
	display: none;
}

div.jsoneditor-menu {
	background-color: #96b97d;
}

div.jsoneditor {
	border: 1px solid #96b97d;
}

@media ( min-width : 768px) {
	.col-sm-2 {
		width: 4%;
		margin-left: -15px;
	}
	.col-sm-5 {
		width: 48%
	}
}
</style>
		<div class="row">

			<div class="col-md-12">

				<div class="panel panel-default">
					<div class="panel-heading">
						<form class="form-inline" role="form">
							<button type="button" class="btn btn-success" id="submitBTN" onclick="beautify();">
								<i class="fa fa-expand"></i> 格式化
							</button>
							<button type="button" class="btn btn-default" id="submitBTN2" onclick="minify();">
								<i class="fa fa-compress"></i> 压缩
							</button>
							<button type="button" class="btn btn-warning" id="submitBTN3">验证</button>
							<button type="button" class="btn btn-warning" onclick="jsonToxml();">JSON 转 XML</button>
							<button type="button" class="btn btn-warning" onclick="jsonTocsv();">JSON 转 CSV</button>
							<button type="button" class="btn btn-warning" onclick="jsonToyaml();">JSON 转 YAML</button>
							<label class="pull-right"><strong style="font-size: 16px"><i class="fa fa-cogs"></i> JSON 压缩/解压工具</strong></label>
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
						<div class="row">
							<div class="col-sm-5">
								<div id="jsoneditor1" style="height: 500px; width: 100%"></div>
							</div>
							<div class="col-sm-2">
								<button id="toTree">
									<span class="glyphicon glyphicon-arrow-right"></span>
								</button>
								<p></p>
								<p>
									<button id="toCode">
										<span class="glyphicon glyphicon-arrow-left"></span>
									</button>
								</p>
							</div>
							<div class="col-sm-5">
								<div id="jsoneditor2" style="height: 500px; width: 100%"></div>
							</div>
						</div>


					</div>
					<div class="panel-footer"></div>
				</div>
			</div>

		</div>
		<script>
			// create the editor
			var container1 = document.getElementById('jsoneditor1');
			var container2 = document.getElementById('jsoneditor2');

			var optionsOutput1 = {
				mode : 'code',
				error : function(err) {
					alert('EF1 ->' + err.toString());
				}
			};

			var optionsOutput2 = {
				mode : 'tree',
				modes : [ 'view', 'form', 'text', 'code', 'tree' ], // allowed modes
				error : function(err) {
					alert('EF1 ->' + err.toString());
				}
			};
			var json = {
				"sites" : {
					"site" : [ {
						"id" : "1",
						"name" : "菜鸟教程",
						"url" : "www.runoob.com"
					}, {
						"id" : "2",
						"name" : "菜鸟工具",
						"url" : "c.runoob.com"
					}, {
						"id" : "3",
						"name" : "Google",
						"url" : "www.google.com"
					} ]
				}
			};

			var editor1 = new JSONEditor(container1, optionsOutput1, json);
			var editor2 = new JSONEditor(container2, optionsOutput2, json);
			editor2.expandAll();
			$("#toTree").click(function() {
				var jsonStr = editor1.getText();
				editor2.setText(jsonStr);
				editor2.setMode("tree");
				editor2.expandAll();
			});
			$("#toCode").click(function() {
				var jsonStr = editor2.getText();
				var jsonObject = JSON.parse(jsonStr);
				editor1.setText(JSON.stringify(jsonObject, null, 2));
				editor1.setMode("code");
			})

			function beautify() {
				var content = editor1.getText();

				if (content.trim().length == 0) {
					return false;
				}
				try {

					var jsonStr = editor1.getText();

					var jsonObject = JSON.parse(jsonStr);
					editor1.setMode("code");
					editor1.setText(JSON.stringify(jsonObject, null, 2));

					editor2.setText(JSON.stringify(jsonObject, null, 0));
					editor2.setMode("tree");
					editor2.expandAll()

				} catch (e) {
					$("#warning").html(
							"<div class=\"alert alert-danger\">JSON 数据错误：" + e
									+ "</div>").show().delay(5000).fadeOut();
				}
			}
			function minify() {

				var content = editor1.getText();

				if (content.trim().length == 0) {
					return false;
				}

				try {
					var jsonStr = editor1.getText();

					var jsonObject = JSON.parse(jsonStr);

					editor1.setMode("code");
					editor1.setText(JSON.stringify(jsonObject, null, 0));
					editor2.setText(JSON.stringify(jsonObject, null, 0));
					editor2.setMode("tree");

					editor2.expandAll()
				} catch (e) {
					$("#warning").html(
							"<div class=\"alert alert-danger\">JSON 数据错误：" + e
									+ "</div>").show().delay(5000).fadeOut();
				}
			}
			$("#submitBTN3")
					.click(
							function() {
								var content = editor1.getText();

								if (content.trim().length == 0) {
									return false;
								}

								try {
									var jsonStr = editor1.getText();
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

				var content = editor1.getText();

				if (content.trim().length == 0) {
					return false;
				}

				try {
					var jsonStr = editor1.getText();
					var json = JSON.parse(jsonStr);
					var xotree = new XML.ObjTree();
					var xml = xotree.writeXML(json);
					xml = decodeSpecialCharacter(xml);
					editor2.setMode("text");
					formatXML = $.format(xml, {
						method : 'xml'
					});
					editor2.setText(formatXML);
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

				var content = editor1.getText();

				if (content.trim().length == 0) {
					return false;
				}

				try {
					var jsonStr = editor1.getText();
					var json = JSON.parse(jsonStr);
					var csv = jsonTocsvbyjson(json);
					editor2.setMode("text");
					editor2.setText(csv);

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

				var content = editor1.getText();

				if (content.trim().length == 0) {
					return false;
				}

				try {
					var jsonStr = editor1.getText();
					var yaml = json2yaml(jsonStr);
					editor2.setMode("text");
					editor2.setText(yaml);
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