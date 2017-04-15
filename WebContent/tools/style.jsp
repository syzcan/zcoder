<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath }" />
<link rel="stylesheet" href="${ctx }/tools/css/codemirror.css" />
<link rel="stylesheet" href="${ctx }/tools/css/bootstrap.min.css" />
<link rel="stylesheet" href="${ctx }/tools/css/modern-business.css" />
<link rel="stylesheet" href="${ctx }/tools/css/jsoneditor.min.css" />
<link rel="stylesheet" href="${ctx }/tools/css/font-awesome.min.css" />
<link rel="stylesheet" href="${ctx }/tools/css/style.css" />
<link rel="shortcut icon" href="${ctx }/static/image/favicon.ico"/>
<script type="text/javascript">
	var ctx = "${pageContext.request.contextPath }";
</script>
<script type="text/javascript" src="${ctx }/tools/js/jquery.min.js"></script>
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
