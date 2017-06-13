<%@ page language="java" import="java.util.*" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
   <base href="<%=basePath%>">
  
   <title>综合管理</title>
   
<meta name="viewport"
content="width=device-width, initial-scale=1, minimum-scale=1  ,maximum-scale=1, user-scalable=no" /> 
<!--
<link rel="stylesheet" type="text/css" href="styles.css">
-->

    <%--//////////--%>
    <%--<link type="text/css" rel="stylesheet" href="<%=basePath%>source/js/plupload/css/bootstrap.css" media="screen" />--%> 
	<script src="${pageContext.request.contextPath}/source/js/common/common.js"></script>
    <link type="text/css" rel="stylesheet" href="<%=basePath%>source/js/plupload/css/my.css" media="screen" />
    <link type="text/css" rel="stylesheet" href="<%=basePath%>source/js/plupload/css/prettify.css" media="screen" />
    <link type="text/css" rel="stylesheet" href="<%=basePath%>source/js/plupload/css/shCore.css" media="screen" />
    <link type="text/css" rel="stylesheet" href="<%=basePath%>source/js/plupload/css/shCoreEclipse.css" media="screen" />
    <link type="text/css" rel="stylesheet" href="<%=basePath%>source/js/plupload/css/jquery-ui.min.css" media="screen" />
    <link type="text/css" rel="stylesheet" href="<%=basePath%>source/js/plupload/css/jquery.ui.plupload.css" media="screen" />

    <script type="text/javascript" src="<%=basePath%>source/js/plupload/shCore.js" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=basePath%>source/js/plupload/shBrushjScript.js" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=basePath%>source/js/plupload/jquery-ui.min.js" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=basePath%>source/js/plupload/plupload.full.min.js" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=basePath%>source/js/plupload/jquery.ui.plupload.min.js" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=basePath%>source/js/plupload/zh_CN.js" charset="UTF-8"></script>
    
    <!-- 以下两个引的文件用于layer -->
	<link type="text/css" rel="stylesheet" href="<%=basePath%>source/js/layer/skin/layer.css"/>	
	<script src="<%=basePath%>source/js/layer/layer.js"></script>
    
    
    <!--[if lte IE 7]>
    <link rel="stylesheet" type="text/css" href="<%=basePath%>source/js/plupload/css/my_ie_lte7.css" />
    <![endif]-->
    <link href="<%=basePath%>source/js/plupload/css/Breeserif.css" rel="stylesheet" type="text/css">
    <!--[if IE]>
    <link href="<%=basePath%>source/js/plupload/css/opensans.css" rel="stylesheet" type="text/css">
    <link href="<%=basePath%>source/js/plupload/css/opensans-300.css" rel="stylesheet" type="text/css">
    <link href="<%=basePath%>source/js/plupload/css/opensans-400.css" rel="stylesheet" type="text/css">
    <link href="<%=basePath%>source/js/plupload/css/opensans-600.css" rel="stylesheet" type="text/css">
    <link href="<%=basePath%>source/js/plupload/css/opensans-700.css" rel="stylesheet" type="text/css">
    <link href="<%=basePath%>source/js/plupload/css/opensans-300s.css" rel="stylesheet" type="text/css">
    <link href="<%=basePath%>source/js/plupload/css/opensans-400s.css" rel="stylesheet" type="text/css">
    <link href="<%=basePath%>source/js/plupload/css/opensans-600s.css" rel="stylesheet" type="text/css">
    <link href="<%=basePath%>source/js/plupload/css/Breeserif-400.css" rel="stylesheet" type="text/css">
    <![endif]-->
    <!--[if IE 7]>
    <link rel="stylesheet" href="<%=basePath%>source/js/plupload/css/font-awesome-ie7.min.css">
    <![endif]-->
    <!--[if lt IE 9]>
    <script src="<%=basePath%>source/js/plupload/html5shiv.js"></script>
    <![endif]-->
    <%--///////////////////--%>

<script type="text/javascript">
	 
	function downLoadFile(path,name){
		var filePath = encodeURI(encodeURI(path));
		var fileName = encodeURI(encodeURI(name));
		window.open("<%=basePath %>system/upload/downLoadFile.do?filePath="+filePath+"&fileName="+fileName);
	}
</script>
 </head> 
 <body>
<div class="con-right" id="conRight">
	<div class="fl yw-lump">
		<div class="yw-lump-title"> 												
				<i id="i_back" class="yw-icon icon-back" onclick="window.location.href='<%=basePath%>manage/branch/branchFHList.do'"></i><span>分行立项分行完成</span>
		</div>
	</div>
	<div class="fl yw-lump mt10">
		<div class="yw-bi-rows">
			<div class="yw-bi-tabs mt5" id="ywTabs">
			<span class="yw-bi-now">项目详情</span>
				
			</div>
			<div class="fr">  
				<span class="yw-btn bg-green" style="margin-left: 10px;margin-right: 10px;" onclick="$('#i_back').click();">返回</span>
			</div>
		</div> 
		<div style="width:100%;max-height:700px; overflow-x:hidden; ">
				<div id="tab1" class="yw-tab">
					<table class="font16 taskTable"  cellpadding="0" cellspacing="0">
						<tr>
							<td width="15%" align="right">项目名称：</td>
							<td colspan="3">
								 <label>${Item.name } </label>  
							</td> 
						</tr>
						<tr>
							<td align="right">项目分类：</td>
							<td colspan="3">
							 <label>${Item.sType } </label>   
							</td>								
						</tr>
						<tr>
							<td align="right">立项时间：</td>
							<td colspan="3">
							 <label>${Item.preparerTimes } </label>   
							</td>								
						</tr>
						<tr>
							<td align="right" style="height:40px;">工作要求、方案：</td>
							<td colspan="3">
							 <label>${ItemProcess.content } </label>  
							</td>		
						</tr> 
						<tr>
							<td align="right"style="height:80px;">附件列表：</td>
							<td colspan="3"> 
								<table style="width:100%;height:100%;min-height:80px;">
									<c:forEach var="fileItem" items="${ItemProcess.fileList }">
										<tr style="height:25px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
									</c:forEach> 
									<tr><td style="border:0px;"></td><tr>
								</table>
							</td>		
						</tr> 
						 
						<c:if test="${ FileItemProcess != null}">
							<tr>
								<td align="right" style="height:40px;">上传文件说明：</td>
								<td colspan="3">
									<label>${FileItemProcess.content } </label> 
								</td>		
							</tr> 
							<tr>
								<td align="right">附件列表：</td>
								<td colspan="3"> 
									<table style="width:100%;height:100%;min-height:80px;">
										<c:forEach var="fileItem" items="${FileItemProcess.fileList }">
											<tr style="height:25px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
										</c:forEach> 
										<tr><td style="border:0px;"></td><tr>
									</table>
								</td>		
							</tr>    
						</c:if>
						 
						<c:if test="${ ChangeItemProcess != null}">
							<tr>
								<td align="right" style="height:40px;">监察室意见：</td>
								<td colspan="3">
									<label>${ChangeItemProcess.content } </label> 
								</td>		
							</tr>    
							<tr>
								<td align="right" style="height:40px;">整改意见：</td>
								<td colspan="3">
									<label>${ChangeItemProcess.changeContent } </label> 
								</td>		
							</tr>     
							<tr>
								<td align="right">整改意见附件：</td>
								<td colspan="3"> 
									<table style="width:100%;height:100%;min-height:80px;">
										<c:forEach var="fileItem" items="${ChangeItemProcess.fileList }">
											<tr style="height:25px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
										</c:forEach> 
										<tr><td style="border:0px;"></td><tr>
									</table>
								</td>		
							</tr>   
						</c:if>
						
						<c:if test="${ FollowItemProcess != null}">
							<tr>
								<td align="right" style="height:40px;">整改内容：</td>
								<td colspan="3">
									<label>${FollowItemProcess.content } </label> 
								</td>		
							</tr>    
							<tr>
								<td align="right">整改内容附件：</td>
								<td colspan="3"> 
									<table style="width:100%;height:100%;min-height:80px;">
										<c:forEach var="fileItem" items="${FollowItemProcess.fileList }">
											<tr style="height:25px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
										</c:forEach> 
										<tr><td style="border:0px;"></td><tr>
									</table>
								</td>		
							</tr>   
						</c:if> 
						
						
						<c:if test="${ FollowChangeProcess != null}">
							<tr>
								<td align="right" style="height:40px;">是否跟踪：</td>
								<td colspan="3">
									<label>跟踪 </label> 
								</td>		
							</tr>  
							<tr>
								<td align="right" style="height:40px;">跟踪意见：</td>
								<td colspan="3">
									<label>${FollowChangeProcess.content } </label> 
								</td>		
							</tr>  
						</c:if> 
						 <c:if test="${OverItemProcess != null && OverItemProcess.fileList != null && OverItemProcess.contentTypeId != 35 }">
							<tr>
								<td align="right" style="height:40px;">跟踪整改内容：</td>
								<td colspan="3"> 
										<label>${OverItemProcess.content }</label>	 
								 </td>	
							</tr> 
							 <tr>
								<td align="right">附件列表：</td>
								<td colspan="3"> 
									<table style="width:100%;height:100%;min-height:80px;">
										<c:forEach var="fileItem" items="${OverItemProcess.fileList }">
											<tr style="height:25px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
										</c:forEach> 
										<tr><td style="border:0px;"></td><tr>
									</table>
								</td>		
							</tr>   
						</c:if>
						 <c:if test="${OverItemProcess != null && OverItemProcess.fileList == null  }">
							<tr>
								<td align="right" style="height:40px;">监察结论：</td>
								<td colspan="3"> 
										<label>${OverItemProcess.content }</label>	 
								 </td>	
							</tr>  
						</c:if>
						 <c:if test="${OverItemProcess != null && OverItemProcess.fileList != null  && OverItemProcess.contentTypeId == 35 }">
							<tr>
								<td align="right" style="height:40px;">监察结论：</td>
								<td colspan="3"> 
										<label>${OverItemProcess.content }</label>	 
								 </td>	
							</tr>  
							 <tr>
								<td align="right">监察结论附件：</td>
								<td colspan="3"> 
									<table style="width:100%;height:100%;min-height:80px;">
										<c:forEach var="fileItem" items="${OverItemProcess.fileList }">
											<tr style="height:25px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
										</c:forEach> 
										<tr><td style="border:0px;"></td><tr>
									</table>
								</td>		
							</tr>  
						</c:if>
						 <c:if test="${OtherProcess != null && OtherProcess.fileList == null  }">
							<tr>
								<td align="right" style="height:40px;">监察结论：</td>
								<td colspan="3"> 
										<label>${OverItemProcess.content }</label>	 
								 </td>	
							</tr>  
						</c:if>
						<c:if test="${ OverProcess != null && OverProcess.fileList != null  }">
							<tr>
								<td align="right" style="height:40px;">监察结论：</td>
								<td colspan="3">
									<label>${ OverProcess.content }</label> 
								</td>		
							</tr>  
							 <tr>
								<td align="right">监察结论附件：</td>
								<td colspan="3"> 
									<table style="width:100%;height:100%;min-height:80px;">
										<c:forEach var="fileItem" items="${OverProcess.fileList }">
											<tr style="height:25px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
										</c:forEach> 
										<tr><td style="border:0px;"></td><tr>
									</table>
								</td>		
							</tr>  
						</c:if> 
						 
					</table>
				</div> 
		</div>  
				</div> 
	
	<div class="cl"></div>
</div>
<div class="cl"></div>
</div>
<div id="dialog"></div>
</body>
</html>  
