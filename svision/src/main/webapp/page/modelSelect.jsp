<%@ page language="java" pageEncoding="utf-8"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
	String url = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";

%>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=8,chrome=1" /> 
	<meta content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no' name='viewport' />
	<title>电子监察平台-模块选择</title>
	<link type="text/css" href="<%=basePath%>source/css/base.css" rel="stylesheet"/>
	<link type="text/css" href="<%=basePath%>source/css/global.css" rel="stylesheet"/>
	 
	<link rel="shortcut icon" href="<%=basePath%>source/images/favicon.ico" type="image/x-icon" />
	<script type="text/javascript" src="<%=basePath%>source/js/jquery-1.11.2.min.js"></script>  
	<script type="text/javascript">
	function gotoMainMenu(url,selectedMainMemu) {
        $.ajax({
            type : "post",
            url : "${pageContext.request.contextPath}/jsonLoadSession.do?selectedMainMemu="+selectedMainMemu,
            async : false
        });

        window.location.href = url;
    }
	</script>
</head>

<body class="modelbg" style="overflow-x:hidden">
<div style="width:100%;height:30px;">
	 <div class="fr head-menu-right"> 
        <a href="${pageContext.request.contextPath}/logout.do"> <span  style="color:#1894f4;font-size:16px;font-weight:bold" title="退出登录">退出</span></a>
    </div>
</div>
<div class="box">  
	<table id="sltModel">  
		<tr> 
			<td style="width:20%"></td>
			<c:forEach var="item" items="${sessionScope.userResources}">
				<c:if test="${item.url == 'vision/efficiency/efficiencyList.do'}"> 
					<c:forEach var="subItem" items="${item.childMenulist}" varStatus="status"> 
						<c:if test="${status.index == 0}">
							<td><img src="<%=basePath %>source/images/model/ssjc.png" title="${item.name}" onclick="gotoMainMenu('${pageContext.request.contextPath}/${subItem.url}','${item.id}')" /></td>
						</c:if>
					</c:forEach>
				</c:if>
				<c:if test="${item.url == 'manage/branch/branchFHList.do'}">
					<td><img src="<%=basePath %>source/images/model/zhgl.png" title="${item.name}" onclick="gotoMainMenu('${pageContext.request.contextPath}/${item.url}','${item.id}')"  /></td>
				</c:if>
				<c:if test="${item.url == 'system/user/userList.do'}"> 
					<td><img src="<%=basePath %>source/images/model/jcgl.png" title="${item.name}" onclick="gotoMainMenu('${pageContext.request.contextPath}/${item.url}','${item.id}')" /></td>
				</c:if> 
				<c:if test="${item.url == 'system/log/logList.do'}"> 
					<td><img src="<%=basePath %>source/images/model/rzgl.png" title="${item.name}" onclick="gotoMainMenu('${pageContext.request.contextPath}/${item.url}','${item.id}')"  /></td>
				</c:if> 
				<c:if test="${item.url == 'statistic/efficiency/efficencyStatistic.do'}"> 
					<td><img src="<%=basePath %>source/images/model/tjfx.png" title="${item.name}" onclick="gotoMainMenu('${pageContext.request.contextPath}/${item.url}','${item.id}')"  /></td>
				</c:if> 
			</c:forEach>
			<td style="width:20%"></td>  
		</tr> 
	</table>
</div>
</body>
</html>