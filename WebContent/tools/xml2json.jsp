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
	<div class="container">
		<br>
		<style type="text/css">
.CodeMirror {
	height: 450px;
}
</style>

		<div class="row">

			<div class="col-md-12">

				<div class="panel panel-default">
					<div class="panel-heading">
						<div class="media">
							<div class="media-body">
								<h4 class="media-heading">XML、JSON在线转换</h4>
							</div>
						</div>
					</div>
					<div class="panel-body">
						<div class="row">
							<div class="col-sm-5">
								<textarea id="xml" name="RawJson" class="json_input" rows="20" style="width: 100%" spellcheck="false" placeholder="要转义的XML"><?xml version="1.0" encoding="UTF-8" ?>
    <animals>
        <dog>
            <name>Rufus</name>
            <breed>labrador</breed>
        </dog>
        <dog>
            <name>Marty</name>
            <breed>whippet</breed>
        </dog>
        <cat name="Matilda" />
    </animals>
    
</textarea>
							</div>
							<div class="col-sm-2" style="text-align: center;">
								<p>
									<input id="zyBianma" type="checkbox">
								</p>
								<p style="font-size: 10px;">转义编码</p>
								<button id="tojson">
									<span class="glyphicon glyphicon-arrow-right"></span>
								</button>
								<p></p>
								<p>
									<button id="toxml">
										<span class="glyphicon glyphicon-arrow-left"></span>
									</button>
								</p>
								<p>
									<input id="reset" type="button" value="清空">
								</p>
							</div>
							<div class="col-sm-5">
								<textarea id="json" name="RawJson" class="json_input" rows="20" style="width: 100%" spellcheck="false" placeholder="要转义的JSON"></textarea>
							</div>
						</div>


					</div>
					<div class="panel-footer"></div>
				</div>
			</div>
			<script>
				if (typeof (JKL) == 'undefined')
					JKL = function() {
					};

				//  JKL.Dumper Constructor

				JKL.Dumper = function() {
					return this;
				};

				//  Dump the data into JSON format

				JKL.Dumper.prototype.dump = function(data, offset) {
					if (typeof (offset) == "undefined")
						offset = "";
					var nextoff = offset + "  ";
					switch (typeof (data)) {
					case "string":
						return '"' + this.escapeString(data) + '"';
						break;
					case "number":
						return data;
						break;
					case "boolean":
						return data ? "true" : "false";
						break;
					case "undefined":
						return "null";
						break;
					case "object":
						if (data == null) {
							return "null";
						} else if (data.constructor == Array) {
							var array = [];
							for (var i = 0; i < data.length; i++) {
								array[i] = this.dump(data[i], nextoff);
							}
							return "[\n" + nextoff
									+ array.join(",\n" + nextoff) + "\n"
									+ offset + "]";
						} else {
							var array = [];
							for ( var key in data) {
								var val = this.dump(data[key], nextoff);
								//              if ( key.match( /[^A-Za-z0-9_]/ )) {
								key = '"' + this.escapeString(key) + '"';
								//              }
								array[array.length] = key + ": " + val;
							}
							if (array.length == 1
									&& !array[0].match(/[\n\{\[]/)) {
								return "{ " + array[0] + " }";
							}
							return "{\n" + nextoff
									+ array.join(",\n" + nextoff) + "\n"
									+ offset + "}";
						}
						break;
					default:
						return data;
						// unsupported data type
						break;
					}
				};

				//  escape '\' and '"'

				JKL.Dumper.prototype.escapeString = function(str) {
					return str.replace(/\\/g, "\\\\").replace(/\"/g, "\\\"");
				};

				//  ===============================================================
				var formatXml = function(xml) {
					var reg = /(>)(<)(\/*)/g;
					var wsexp = / *(.*) +\n/g;
					var contexp = /(<.+>)(.+\n)/g;
					xml = xml.replace(reg, '$1\n$2$3').replace(wsexp, '$1\n')
							.replace(contexp, '$1\n$2');
					var pad = 0;
					var formatted = '';
					var lines = xml.split('\n');
					var indent = 0;
					var lastType = 'other';
					// 4 types of tags - single, closing, opening, other (text, doctype, comment) - 4*4 = 16 transitions 
					var transitions = {
						'single->single' : 0,
						'single->closing' : -1,
						'single->opening' : 0,
						'single->other' : 0,
						'closing->single' : 0,
						'closing->closing' : -1,
						'closing->opening' : 0,
						'closing->other' : 0,
						'opening->single' : 1,
						'opening->closing' : 0,
						'opening->opening' : 1,
						'opening->other' : 1,
						'other->single' : 0,
						'other->closing' : -1,
						'other->opening' : 0,
						'other->other' : 0
					};

					for (var i = 0; i < lines.length; i++) {
						var ln = lines[i];
						var single = Boolean(ln.match(/<.+\/>/)); // is this line a single tag? ex. <br />
						var closing = Boolean(ln.match(/<\/.+>/)); // is this a closing tag? ex. </a>
						var opening = Boolean(ln.match(/<[^!].*>/)); // is this even a tag (that's not <!something>)
						var type = single ? 'single' : closing ? 'closing'
								: opening ? 'opening' : 'other';
						var fromTo = lastType + '->' + type;
						lastType = type;
						var padding = '';

						indent += transitions[fromTo];
						for (var j = 0; j < indent; j++) {
							padding += '\t';
						}
						if (fromTo == 'opening->closing')
							formatted = formatted.substr(0,
									formatted.length - 1)
									+ ln + '\n'; // substr removes line break (\n) from prev loop
						else
							formatted += padding + ln + '\n';
					}

					return formatted;
				};
			</script>
			<script>
				var minLines = 3;
				var startingValue = '';
				for (var i = 0; i < minLines; i++) {
					startingValue += '\n';
				}
				var editor1 = CodeMirror.fromTextArea(document
						.getElementById("xml"), {
					lineNumbers : true,
					matchBrackets : true,

					mode : "application/xml",
					indentUnit : 4,
					indentWithTabs : true,
					value : startingValue
				});
				var editor2 = CodeMirror.fromTextArea(document
						.getElementById("json"), {
					lineNumbers : true,
					lineWrapping : true,
					matchBrackets : true,
					mode : "application/ld+json",
					indentUnit : 4,
					indentWithTabs : true,
					value : startingValue
				});
				function repalceFh(c) {
					return c.replace(/&gt;/g, ">").replace(/&lt;/g, "<")
							.replace(/&quot;/g, "\"");
				}
				$(function() {

					$("#tojson").on("click", function(e) {
						var xotree = new XML.ObjTree();
						var dumper = new JKL.Dumper();
						var xmlText = editor1.getValue();
						if ($("#zyBianma").attr("checked")) {
							xmlText = repalceFh(xmlText);
						}
						var tree = xotree.parseXML(xmlText);
						//$("#json").val(dumper.dump(tree));
						editor2.getDoc().setValue(dumper.dump(tree));
					});

					$("#toxml")
							.on(
									"click",
									function(e) {
										var xotree = new XML.ObjTree();
										var json = eval("("
												+ editor2.getValue() + ")");
										//$("#xml").val(formatXml(xotree.writeXML(json))); 
										editor1
												.getDoc()
												.setValue(
														formatXml(xotree
																.writeXML(json)));
									});

					$("#example")
							.click(
									function() {
										$("#xml")
												.val(
														'<animals><dog><name>Rufus</name><breed>labrador</breed></dog><dog><name>Marty</name><breed>whippet</breed></dog><cat name="Matilda"/></animals>');
									});

					$("#reset").click(function() {
						editor1.getDoc().setValue('');
						editor2.getDoc().setValue('');
					});
				})
			</script>
		</div>
	</div>
</body>
</html>