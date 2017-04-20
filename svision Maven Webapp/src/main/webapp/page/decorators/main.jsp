<%@ page language="java" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
	String url = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path;

%>
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<title>云端超级应用-<sitemesh:write property='title'/></title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<!--[if lt IE 9]>
	<meta http-equiv="refresh" content="0;ie.html" />
	<![endif]-->

	<link rel="shortcut icon" href="<%=basePath%>source/img/favicon.ico" type="image/x-icon" >
	<link href="<%=basePath %>source/bootstrap-dist/css/bootstrap.min.css?v=3.3.6" rel="stylesheet">
	<link href="<%=basePath %>source/bootstrap-dist/css/plugins/bootstrap-table/bootstrap-table.min.css" rel="stylesheet">
	<link href="<%=basePath %>source/font-awesome/css/font-awesome.min.css?v=4.4.0" rel="stylesheet">
	<link href="<%=basePath %>source/font-awesome/css/animate.css" rel="stylesheet">
	<link href="<%=basePath %>source/css/base.css" rel="stylesheet">
	<link href="<%=basePath %>source/font-awesome/css/style.css?v=4.1.0" rel="stylesheet">
	<link href="<%=basePath %>source/js/plugins/dialog/bootstrap-dialog.min.css" rel="stylesheet">

	<!-- 全局js -->
	<script src="<%=basePath %>source/js/jquery-2.0.3.min.js"></script>
	<script src="<%=basePath %>source/js/bootstrap.min.js?v=3.3.6"></script>
	<script src="<%=basePath %>source/js/plugins/metisMenu/jquery.metisMenu.js"></script>
	<script src="<%=basePath %>source/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
	<script src="<%=basePath %>source/js/plugins/layer/layer.min.js"></script>
	<script src="<%=basePath %>source/js/plugins/dialog/bootstrap-dialog.min.js"></script>
	<script src="<%=basePath %>source/js/plugins/dialog/run_prettify.min.js"></script>
	<script src="<%=basePath %>source/js/pager/jquery.pager.js"></script>
	<link href="<%=basePath %>source/js/pager/Pager.css" rel="stylesheet"/>
	<script src="<%=basePath %>source/js/content.js"></script>
	<script src="<%=basePath %>source/js/common.js"></script>
	<script src="<%=basePath %>source/js/plugins/validate/jquery.validate.min.js"></script>
	<script src="<%=basePath %>source/js/plugins/validate/messages_zh.min.js"></script>

	<script src="<%=basePath %>source/bootstrap-dist/js/validate/js/bootstrapValidator.min.js"></script>
	<link href="<%=basePath %>source/bootstrap-dist/js/validate/css/bootstrapValidator.min.css" rel="stylesheet">

	<!-- 自定义js -->
	<script src="<%=basePath %>source/js/hAdmin.js?v=4.1.0"></script>

	<!-- 第三方插件 -->
	<script src="<%=basePath %>source/js/plugins/pace/pace.min.js"></script>
	<sitemesh:write property='head' />
</head>

<body class="fixed-sidebar full-height-layout gray-bg" >
	<div id="wrapper">
		<jsp:include page="/page/decorators/left.jsp"></jsp:include>
		<div id="page-wrapper" class="gray-bg dashbard-1">
			<jsp:include page="/page/decorators/header.jsp"></jsp:include>
			<div class="row J_mainContent" id="content-main">
				<sitemesh:write property='body'/>
			</div>
		</div>
		<div id="footer" class="footer">
			<jsp:include page="/page/decorators/footer.jsp"></jsp:include>
		</div>
	</div>
</body>
</html>