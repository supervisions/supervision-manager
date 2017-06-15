<%@ page language="java" import="java.util.*" contentType="text/html;charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta charset="utf-8">
<title>待办事项</title>
<meta http-equiv="refresh" content="3600">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/source/js/easyUI/themes/default/easyui.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/source/js/easyUI/themes/icon.css"> 
	<script type="text/javascript" src="${pageContext.request.contextPath}/source/js/easyUI/jquery.easyui.min.js"></script>
	<script src="${pageContext.request.contextPath}/source/js/easyUI/easyui-lang-zh_CN.js"></script>
	<script src="${pageContext.request.contextPath}/source/js/common/validate.js"></script>
	<script src="${pageContext.request.contextPath}/source/js/common/common.js"></script>
<meta name="viewport"
	content="width=device-width, initial-scale=1, minimum-scale=1  ,maximum-scale=1, user-scalable=no" />  
<script type="text/javascript">
function showItem(id,type){
	if(type == 2){
		window.location.href="<%=basePath%>vision/efficiency/showItem.do?id="+id;
	}else if(type == 3){
		window.location.href="<%=basePath%>vision/incorrupt/showItem.do?id="+id;
	}else if(type == 4){
		window.location.href="<%=basePath%>vision/enforce/showItem.do?id="+id;
	}
}
</script>
</head>
<body>
	<div class="con-right" id="conRight">	
		<div class="fl yw-lump">
			<div class="yw-lump-title">
				<i class="yw-icon icon-partner"></i><span>待办事项列表</span> 
			</div>
		</div>
		<div class="fl yw-lump mt10">  
			<div class=pd10>
				<div class="fl">  
					<span style="font-size:16px;font-weight:bold;height:40px;">待办事项：</span>
					<span style="font-size:16px;font-weight:bold;height:40px;">共计  ${totalCountLZ+totalCountZF+totalCountXN} 项，其中：效能监察：  ${totalCountXN } 项，廉政监察： ${totalCountLZ } 项，执法监察： ${totalCountZF } 项</span> 				
				</div> 
				<div class="cl"></div>	 
               </div> 
		 </div>	
          <div class="fl yw-lump"> 
			<table  id="taskList" border="1px">
				<tr style="background-color:#D6D3D3;font-weight: bold;"> 
					<th width="30%" style="font-size:16px;font-weight:bold;height:40px;">效能监察</th>
					<th width="30%" style="font-size:16px;font-weight:bold;height:40px;">廉政监察</th>	
					<th width="30%" style="font-size:16px;font-weight:bold;height:40px;">执法监察</th>	 
				<tr> 							
					<td>
					<table style="width:100%;height:100%;">
						<c:forEach var="xlItem" items="${itemListXN }">
							<tr>
								<td style="height:30px; "><a class="dddd" title="点击查看"  onclick="showItem(${xlItem.id },2)" >【${xlItem.name }】</a></td>
								<td width="30"><img alt="查看" title="查看详情" src="<%=basePath %>source/images/search.png" onclick="showItem(${xlItem.id },2)"  /></td>
							</tr>
						</c:forEach>
						<tr><td></td></tr>
					</table>
					</td> 					
					<td> 
					<table style="width:100%;height:100%;">
						<c:forEach var="lzItem" items="${itemListLZ }">
							<tr>
								<td style="height:30px; "><a class="dddd" title="点击查看" onclick="showItem(${lzItem.id },3)" >【${lzItem.name }】</a></td>
								<td width="30"><img alt="查看" title="查看详情" src="<%=basePath %>source/images/search.png" onclick="showItem(${lzItem.id },3)"  /></td>
							</tr>
						</c:forEach>
						<tr><td></td></tr>
					</table>
					</td> 					
					<td> 
					<div style="width:100%;overflow-x:hidden;max-height:480px;">
					<table style="width:100%;">
						<c:forEach var="zfItem" items="${itemListZF }">
							<tr>
								<td style="height:30px;"><a class="dddd" title="点击查看" onclick="showItem(${zfItem.id },4)"  >【${zfItem.name }】</a></td>
								<td width="30"><img alt="查看" title="查看详情" src="<%=basePath %>source/images/search.png" onclick="showItem(${zfItem.id },4)"  /></td>
							</tr>
						</c:forEach> 
					</table> 
					</div>
					</td> 
				</tr> 
			</table> 
			</div>
		</div> 
  </body>
</html>