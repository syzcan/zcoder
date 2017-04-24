<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
<title>-${tableName }</title>
<meta name="keywords" content="关键词" />
<meta name="description" content="描述" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<%@ include file="/WEB-INF/jsp/common/style.jsp"%>
<style type="text/css">
.beanField input{background: white;width: 100%;border: none;}
.beanField input:hover{background: #f5f5f5}
table tr:hover .beanField input{background: #f5f5f5}
#dataList tr>td:first-child,#dataList tr>th:first-child{border-left: none;}
#dataList tr>td:last-child,#dataList tr>th:last-child{border-right: none;}
#dataList tr:last-child>td{border-bottom: none;}
</style>
</head>
<body>
	<%@ include file="/WEB-INF/jsp/common/nav.jsp"%>
	<div style="position:fixed;top:3px;left:600px;z-index:10;color:white">取值前缀：<input id="prefix" placeholder="el表达式bean名称" type="text" class="input input-auto border-main"></div>
	<div class="admin">
		<div class="panel admin-panel">
			<div class="panel-head">
				数据连接：【<a href="${ctx}/${dbname}/tables">${dbname }</a> > ${tableName }
				<a class="button button-little bg-blue" href="${ctx}/${dbname }/tables/${tableName }">结构</a>
				<a class="button button-little border-blue" href="${ctx}/${dbname }/tables/${tableName }/datas">数据</a>
				<a class="button button-little border-blue" href="${ctx}/${dbname }/tables/${tableName }/code">代码</a>
				<a class="button button-little border-blue" href="${ctx}/${dbname }/tables/${tableName }/sqldatas">查询</a>
				】
				
			</div>

			<table class="table table-hover">
				<thead>
					<tr>
						<th width="50px">序号</th>
						<th width="160px">
							<select id="formInput" style="border: none;">
							<option value="">formInput</option>
							<option value="pintuer">pintuer</option>
							<option value="layui">layui</option>
							</select>
						</th>
						<th width="160px">EL 取值</th>
						<th width="160px">字段【${fn:length(columns) }】</th>
						<th width="100px">jdbcType</th>
						<th width="80px">java类型</th>
						<th width="80px">类型</th>
						<th>长度</th>
						<th width="50px">必填</th>
						<th width="50px">主键</th>
						<th>默认值</th>
						<th>备注</th>
					</tr>
				</thead>
				<tbody id="dataList" class="table-bordered table-condensed">
					<c:forEach items="${columns }" var="column" varStatus="vs">
						<tr>
							<td class="text-center">${vs.count }</td>
							<td class="beanField"><input type="text" class="formInput" readonly="readonly" data-field="${column.field }" data-type="${column.javaType }" data-required="${column.canNull=='NO'}"/></td>
							<td class="beanField"><input type="text" class="data-field" readonly="readonly" data-field="${column.field }" value="${column.field }"/></td>
							<td ${column.key=='PRI'?' title="主键"':'' }>
								<span type="text" class="${column.key=='PRI'?' text-red':'' }" readonly="readonly" data-field="${column.column }" >${column.column }</span>
							</td>
							<td class="text-green">${column.jdbcType }</td>
							<td class="text-blue">${column.javaType }</td>
							<td>${column.dataType }</td>
							<td>
							<c:if test="${column.jdbcType!='DECIMAL' && column.jdbcType!='INTEGER' }">
							${column.dataLength }
							</c:if>
							<c:if test="${column.jdbcType=='INTEGER' || column.jdbcType=='DECIMAL' }">
							${column.dataPrecision },${column.dataScale }
							</c:if>
							 </td>
							<td class="text-center"${column.canNull=='NO'?' title="必填字段"':'' }>
								<c:if test="${column.canNull=='NO' }">
								<strong class="text-red">√</strong>
								</c:if> 
							</td>
							<td class="text-center"${column.key=='PRI'?' title="主键"':'' }>
								<c:if test="${column.key=='PRI' }">
									<strong class="text-red">PRI</strong>
								</c:if> 
							</td>
							<td>${column.defaultValue }</td>
							<td>${column.remark }</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
</body>
<script type="text/javascript">
	$(function() {
		$('#prefix').on('blur', function() {
			//自动生成表单项
			buildFormInput();
		});
		$('#formInput').on('change', function() {
			//自动生成表单项
			buildFormInput();
		});
		$('#dataList .beanField').on('click',function(){
			$(this).find('input')[0].select();
			document.execCommand("Copy"); // 执行浏览器复制命令
		});
	});
	function buildFormInput(){
		var prefix = $.trim($('#prefix').val());
		$('.data-field').each(function() {
			if(prefix==''){
				$(this).val($(this).attr('data-field'));
			}else{
				$(this).val('$\{'+prefix+'.' + $(this).attr('data-field') + '}');
			}
		});
		$('.formInput').each(function() {
			if(prefix==''){
				$(this).val('');
				return;
			}
			var value = '$\{'+prefix+'.' + $(this).attr('data-field') + '}';
			var required='';
			var className='';
			//下拉选择生成Pintuer或layui的表单输入
			if($('#formInput').val()=='pintuer'){
				//如果是日期，则用fmt格式化显示
				if($(this).attr('data-type')=='Date'){
					value = '<'+'fmt:formatDate value="'+value+'" pattern="yyyy-MM-dd"/>';
					value = value + '" readonly onclick="laydate()';
				}
				if($(this).attr('data-required')=='true'){
					required = ' data-validate="required:请填写信息"';
				}
				className = 'input input-auto';
			}else{
				if($(this).attr('data-type')=='Date'){
					value = '<'+'fmt:formatDate value="'+value+'" pattern="yyyy-MM-dd"/>';
					value = value + '" readonly onclick="layui.laydate({elem: this})';
				}
				if($(this).attr('data-required')=='true'){
					required = ' required lay-verify="required"';
				}
				className = 'layui-input';
			}
			$(this).val('<input type="text" name="'+$(this).attr('data-field')+'" value="'+value+'" class="'+className+'"'+required+'/>');
		});
	}
</script>
</html>