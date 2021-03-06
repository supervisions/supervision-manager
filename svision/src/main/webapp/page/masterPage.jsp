<%@ page language="java" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% 
String uri = request.getRequestURI();
String  url  =  uri.substring(uri.lastIndexOf("/")+1);
%>
<!DOCTYPE HTML>
<html>
<head> 
<meta http-equiv="X-UA-Compatible" content="IE=8,chrome=1" /> 
<title>电子监察平台<sitemesh:write property='title'/></title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<link type="text/css" href="${pageContext.request.contextPath}/source/css/skitter.css" rel="stylesheet"/>
<link type="text/css" href="${pageContext.request.contextPath}/source/css/base.css" rel="stylesheet"/>
<link type="text/css" href="${pageContext.request.contextPath}/source/css/global.css" rel="stylesheet"/> 
<script type="text/javascript" src="${pageContext.request.contextPath}/source/js/jquery-1.11.2.min.js"></script> 
<script type="text/javascript" src="${pageContext.request.contextPath}/source/js/jquery.easing.1.3.js"></script> 
<script type="text/javascript" src="${pageContext.request.contextPath}/source/js/jquery.skitter.js"></script> 
	<link rel="shortcut icon" href="${pageContext.request.contextPath}/source/images/favicon.ico" type="image/x-icon" />
 
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
	
	$(function(){
		//计算网页高度
		setHei();
		$(window).resize(function(){
			setHei();
		});
		
		$(".box_skitter_large").skitter({
			animation: "random",
			interval: 3000,
			numbers: false, 
			numbers_align: "right", 
			hideTools: true,
			controls: false,
			focus: false,
			focus_position: true,
			width_label:'340px', 
			enable_navigation_keys: true,   
			progressbar: false
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
		 <div id="header" style="height:120px;background-color: #1894f4;"><jsp:include page="/page/decorators/masterHeader.jsp"></jsp:include></div> 
		<div id="content">
			 <jsp:include page="/page/decorators/advertisement.jsp"></jsp:include>
			 <div class="yw-main-notice">
			    <div class="yw-row"> 
			      <div class="yw-span1" style="text-align: right;"> 
			        <span class="icon icon-bullhorn"></span>
			      </div>
			      <div class="yw-span3">
			        <span>·&nbsp;</span>
			       <a title=" " href="javascript:void(0);" target="_blank" class="yw-clear"><span class="title" style="color:red;font-size:14px;font-weight:bold;"> 网站链接1 </span></a></div>
			      <div class="yw-span3">
			        <span>·&nbsp;</span>
			       <a title=" " href="javascript:void(0);" target="_blank" class="yw-clear"><span class="title" style="color:red;font-size:14px;font-weight:bold;">  网站链接2</span></a></div>
			      <div class="yw-span3">
			        <span>·&nbsp;</span>
			       <a title=" " href="javascript:void(0);" target="_blank" class="yw-clear"><span class="title" style="color:red;font-size:14px;font-weight:bold;"> 网站链接3 </span></a></div>
			      <div class="yw-span3">
			        <span>·&nbsp;</span>
			       <a title=" " href="javascript:void(0);" target="_blank" class="yw-clear"><span class="title" style="color:red;font-size:14px;font-weight:bold;"> 网站链接4 </span></a></div>
			      <div class="yw-span2 y-last">
			        <a href="javascript:void(0);" target="_blank">
			         <!--  更多&gt;&gt; -->
			        </a>
			      </div>
			    </div>
			  </div>   
		  	 <jsp:include page="/page/decorators/masterIndex.jsp"></jsp:include>
			<div class="cl"></div>
		</div>
		<div id="footer"><jsp:include page="/page/decorators/footer.jsp"></jsp:include></div>
	</div>
</body>
</html>