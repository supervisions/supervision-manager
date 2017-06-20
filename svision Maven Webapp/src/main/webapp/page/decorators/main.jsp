<%@ page language="java" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% 
String uri = request.getRequestURI();
String  url  =  uri.substring(uri.lastIndexOf("/")+1);
%>
<!DOCTYPE HTML>
<html>
<head> 
<meta http-equiv="X-UA-Compatible" content="IE=5" /> 
<title>电子监察平台-<sitemesh:write property='title'/></title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<link rel="shortcut icon" href="${pageContext.request.contextPath}/source/images/favicon.ico" type="image/x-icon" />
<link type="text/css" href="${pageContext.request.contextPath}/source/css/base.css" rel="stylesheet"/>
	<link type="text/css" href="${pageContext.request.contextPath}/source/css/global.css" rel="stylesheet"/>
	<script type="text/javascript" src="${pageContext.request.contextPath}/source/js/jquery-1.11.2.min.js"></script>
	
	<!--[if IE 6]>
	<script src="${pageContext.request.contextPath}/source/js/DDPngMin.js"></script>
	<script>DD_belatedPNG.fix('.ad_img img,#ssssss');</script>
	<![endif]--> 
<!-- 导入页面引用的特殊js和css文件 -->
<sitemesh:write property='head' />
<script type="text/javascript">
	$.yw={
			 currURL:'${pageContext.request.contextPath}',
			 sessionAccount:'${sessionScope.userInfo.account}',
			 sessionUserId:'${sessionScope.userInfo.id}',
			 pageURL:'<%=request.getAttribute("requestCurrURL")%>'
	};
	//这个方法用来启动该页面的ReverseAjax功能
	//dwr.engine.setActiveReverseAjax( true);
	//设置在页面关闭时，通知服务端销毁会话
	//dwr.engine.setNotifyServerOnPageUnload( true);
	
	$(function(){
		//计算网页高度
		setHei();
		$(window).resize(function(){
			setHei();
		});
	});
	
	function setHei(){
		$("#content").removeAttr("style");
		var h = $(window).height();
		var hh = document.body.offsetHeight;
		var t = $("#content").offset().top;
		if(hh>h)h = hh+20;
		var v = h-t-1;
		var rh = $("#conRight").height();
		if(rh>v){
			v = rh+50;
		}
		$("#content").css("height",v-30);
	}
</script>
</head>

<body style="overflow-x:hidden">
	<div id="main">
		<div id="header"><jsp:include page="/page/decorators/header.jsp"></jsp:include></div>
		<div id="content">
			<jsp:include page="/page/decorators/left.jsp"></jsp:include>
			<sitemesh:write property='body'/>
			<div class="cl"></div>
		</div>
		<div id="footer"><jsp:include page="/page/decorators/footer.jsp"></jsp:include></div>
	</div>
</body>
</html>