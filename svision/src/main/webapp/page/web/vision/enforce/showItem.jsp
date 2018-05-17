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
  
   <title>执法监察</title>
   
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
				<i id="i_back" class="yw-icon icon-back" onclick="window.location.href='<%=basePath%>vision/enforce/enforceList.do'"></i><span>执法监察列表</span>
		</div>
	</div>
	<div class="fl yw-lump mt10">
		<div class="yw-bi-rows">
			<div class="yw-bi-tabs mt5" id="ywTabs">
			<span class="yw-bi-now">项目详情</span>
				
			</div>
			<div class="fr">  
				<span class="yw-btn bg-green" style="margin-left: 10px;margin-right: 10px;" onclick="javascript:history.back();">返回</span>
			</div>
		</div> 
		<div style="width:100%;max-height:700px; overflow-x:hidden; ">
				<div id="tab1" class="yw-tab">
					<table class="font16 taskTable"  cellpadding="0" cellspacing="0">
						<!-- 初始状态 -->
						<tr>
							<td width="16%" align="right">工作事项：</td>
							<td colspan="3">
								 <label>${Item.name } </label>  
							</td> 
						</tr>
						<tr>
							<td align="right">附件列表：</td>
							<td colspan="3"> 
								<table style="width:100%;height:100%;min-height:80px;">
									<c:forEach var="fileItem" items="${ItemProcess.fileList }">
										<tr style="height:25px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
									</c:forEach> 								
								</table>
							</td>		
						</tr>	
						<tr>
							<td align="right" style="height:40px;">执法监察立项：</td>
							<td colspan="3">
								<label>${ItemProcess1.content } </label> 
							</td>		
						</tr>
						<tr>
							<td align="right">立项附件列表：</td>
							<td colspan="3"> 
								<table style="width:100%;height:100%;min-height:80px;">
									<c:forEach var="fileItem" items="${ItemProcess1.fileList }">
										<tr style="height:25px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
									</c:forEach>
									
								</table>
							</td>		
						</tr>						
						<tr>
							<td align="right">执法类型：</td>
							<td colspan="3">
							 <label>${Item.itemCategory } </label>   
							</td>								
						</tr>
						<tr>
							<td align="right">被监察对象：</td>
							<td colspan="3">
							 <label>${Item.orgName } </label>   
							</td>								
						</tr>	
						
			
						<!-- 被监察录入执法监察资料状态-->						
						<c:if test="${ItemProcess2 != null }">							
							<tr>
								<td align="right" >执法检查立项资料：</td>
								<td colspan="3"> 
									<table style="width:100%;height:100%;min-height:80px;">
										<c:forEach var="fileItem" items="${ItemProcess2.fileList }">
											<tr style="height:25px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
										</c:forEach> 
										
									</table>
								</td>		
							</tr>
							<tr>
								<td align="right" style="height:40px;">执法检查立项资料说明：</td>
								<td colspan="3">
									<label>${ItemProcess2.content } </label> 									
								</td>		
							</tr> 
						</c:if>
						<!-- 监察室给出监察意见，并且项目合规 -->		
						<c:if test="${ItemProcess3 != null }">
							<tr>
								<td align="right" style="height:40px;">监察意见：</td>
								<td colspan="3">
									<label>${ItemProcess3.content } </label> 									
								</td>	
							</tr>
							<tr>
								<td align="right" >相关附件：</td>
								<td colspan="3"> 
									<table style="width:100%;height:100%;min-height:80px;">
										<c:forEach var="fileItem" items="${ItemProcess3.fileList }">
											<tr style="height:20px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
										</c:forEach> 
										
									</table>
								</td>		
							</tr>
							<tr>
								<td align="right">是否合规：</td>
								<td colspan="3">
									<label>合规 </label> 									
								</td>		
							</tr>							
						</c:if>			
						<!-- 监察室给出监察意见，但是项目不合规 -->						
						<c:if test="${ItemProcess4 != null }">
							<tr>
								<td align="right" style="height:40px;">监察意见：</td>
								<td colspan="3">
									<label>${ItemProcess4.content } </label> 									
								</td>		
							</tr>
							<tr>
								<td align="right" >相关附件：</td>
								<td colspan="3"> 
									<table style="width:100%;height:100%;min-height:80px;">
										<c:forEach var="fileItem" items="${ItemProcess4.fileList }">
											<tr style="height:20px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
										</c:forEach> 
										
									</table>
								</td>		
							</tr>
							<tr>
								<td align="right">是否合规：</td>
								<td colspan="3">
									<label>不合规 </label> 									
								</td>		
							</tr>							
						</c:if>					
						<!-- 被监察对象录入监察报告、意见书 -->
						<c:if test="${ItemProcess5 != null }">							
							<tr>
								<td align="right" >现场检查报告、意见书：</td>
								<td colspan="3"> 
									<table style="width:100%;height:100%;min-height:80px;">
										<c:forEach var="fileItem" items="${ItemProcess5.fileList }">
											<tr style="height:20px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
										</c:forEach> 
										
									</table>
								</td>		
							</tr>
							<tr>
								<td align="right" style="height:40px;">检查报告、意见书说明：</td>
								<td colspan="3">
									<label>${ItemProcess5.content } </label>
									
								</td>		
							</tr>								
						</c:if>
						
						
						<!-- 监察室录入监察意见书的意见，并且合规 -->
						<c:if test="${ItemProcess6 != null }">
							<tr>
								<td align="right" style="height:40px;">监察意见：</td>
								<td colspan="3">
									<label>${ItemProcess6.content } </label>									
								</td>		
							</tr>
							<tr>
								<td align="right" >相关附件：</td>
								<td colspan="3"> 
									<table style="width:100%;height:100%;min-height:80px;">
										<c:forEach var="fileItem" items="${ItemProcess6.fileList }">
											<tr style="height:20px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
										</c:forEach> 
										
									</table>
								</td>		
							</tr>
							<tr>
								<td align="right">是否合规：</td>
								<td colspan="3">
									<label>合规</label> 									
								</td>		
							</tr>						
						</c:if>
						
						<!-- 监察室录入监察意见书的意见，但是不合规 -->
						<c:if test="${ItemProcess7 != null }">
							<tr>
								<td align="right" style="height:40px;">监察意见：</td>
								<td colspan="3">
									<label>${ItemProcess7.content } </label> 									
								</td>		
							</tr> 
							<tr>
								<td align="right" >相关附件：</td>
								<td colspan="3"> 
									<table style="width:100%;height:100%;min-height:80px;">
										<c:forEach var="fileItem" items="${ItemProcess7.fileList }">
											<tr style="height:25px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
										</c:forEach> 
										
									</table>
								</td>		
							</tr>
							<tr>
								<td align="right">是否合规：</td>
								<td colspan="3">
									<label>不合规</label> 									
								</td>		
							</tr> 
						</c:if>	
						
						
						<!-- 被监察对象录入督促整改情况，并且不处罚 -->
						<c:if test="${ItemProcess8 != null }">
							<tr>
								<td align="right" style="height:40px;">督促整改情况：</td>
								<td colspan="3">
									<label>${ItemProcess8.content } </label> 									
								</td>		
							</tr>
							<tr>
								<td align="right" >相关附件：</td>
								<td colspan="3"> 
									<table style="width:100%;height:100%;min-height:80px;">
										<c:forEach var="fileItem" items="${ItemProcess8.fileList }">
											<tr style="height:25px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
										</c:forEach> 
										
									</table>
								</td>		
							</tr>
							<tr>
								<td align="right" style="height:40px;">是否处罚：</td>
								<td colspan="3">
									<label>不处罚</label> 									
								</td>		
							</tr>						
						</c:if>	
						
						
						
						<!-- 被监察对象录入督促整改情况，但是要处罚 -->
						<c:if test="${ItemProcess10 != null }">
							<tr>
								<td align="right" style="height:40px;">督促整改情况：</td>
								<td colspan="3">
									<label>${ItemProcess10.content } </label> 									
								</td>		
							</tr>
							<tr>
								<td align="right" >相关附件：</td>
								<td colspan="3"> 
									<table style="width:100%;height:100%;min-height:80px;">
										<c:forEach var="fileItem" items="${ItemProcess10.fileList }">
											<tr style="height:25px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
										</c:forEach> 
										
									</table>
								</td>		
							</tr>
							<tr>
								<td align="right" style="height:40px;">是否处罚：</td>
								<td colspan="3">
									<label>进行处罚</label> 									
								</td>		
							</tr>						
						</c:if>	
						<!-- 被监察对象录入行政处罚意见书 -->
						<c:if test="${ItemProcess11 != null }">							
							<tr>
								<td align="right" >行政处罚意见告知书：</td>
								<td colspan="3"> 
									<table style="width:100%;height:100%;min-height:80px;">
										<c:forEach var="fileItem" items="${ItemProcess11.fileList }">
											<tr style="height:25px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
										</c:forEach> 
										
									</table>
								</td>		
							</tr>
							<tr>
								<td align="right" style="height:40px;">处罚意见告知书说明：</td>
								<td colspan="3">
									<label>${ItemProcess11.content } </label> 									
								</td>		
							</tr>												
						</c:if>	
						<!-- 监察室监察行政处罚意见告知，并且合规-->
						<c:if test="${ItemProcess12 != null }">							
							<tr>
								<td align="right" style="height:40px;">监察意见：</td>
								<td colspan="3">
									<label>${ItemProcess12.content } </label> 									
								</td>		
							</tr>
							<tr>
								<td align="right" >相关附件：</td>
								<td colspan="3"> 
									<table style="width:100%;height:100%;min-height:80px;">
										<c:forEach var="fileItem" items="${ItemProcess12.fileList }">
											<tr style="height:25px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
										</c:forEach> 
										
									</table>
								</td>		
							</tr>
							<tr>
								<td align="right" style="height:40px;">是否合规：</td>
								<td colspan="3">
									<label>合规</label> 									
								</td>		
							</tr>												
						</c:if>	
						<!-- 监察室监察行政处罚意见告知，但是不合规合规-->
						<c:if test="${ItemProcess13 != null }">							
							<tr>
								<td align="right" style="height:40px;">监察意见：</td>
								<td colspan="3">
									<label>${ItemProcess13.content } </label> 									
								</td>		
							</tr>
							<tr>
								<td align="right" >相关附件：</td>
								<td colspan="3"> 
									<table style="width:100%;height:100%;min-height:80px;">
										<c:forEach var="fileItem" items="${ItemProcess13.fileList }">
											<tr style="height:25px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
										</c:forEach> 
										
									</table>
								</td>		
							</tr>
							<tr>
								<td align="right" style="height:40px;">是否合规：</td>
								<td colspan="3">
									<label>不合规</label> 									
								</td>		
							</tr>												
						</c:if>	
						<c:if test="${ItemProcess15 == null && ItemProcess14 !=null}">
							<tr>
								<td align="right" style="height:40px;">是否听证：</td>
								<td colspan="3">
									<label>不听证</label> 									
								</td>		
							</tr>
						</c:if>
						<!-- 听证，录入听证相关资料  -->
						<c:if test="${ItemProcess15 != null }">	
							<tr>
								<td align="right" style="height:40px;">是否听证：</td>
								<td colspan="3">
									<label>听证</label> 									
								</td>		
							</tr>							
							<tr>
								<td align="right" >听证相关资料：</td>
								<td colspan="3"> 
									<table style="width:100%;height:100%;min-height:80px;">
										<c:forEach var="fileItem" items="${ItemProcess15.fileList }">
											<tr style="height:25px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
										</c:forEach> 
										
									</table>
								</td>		
							</tr>
							<tr>
								<td align="right" style="height:40px;">听证资料说明：</td>
								<td colspan="3">
									<label>${ItemProcess15.content } </label> 									
								</td>		
							</tr>												
						</c:if>
						<!-- 不听证，被监察对象录入行政处罚决定书  -->
						<c:if test="${ItemProcess14 != null }">												
							<tr>
								<td align="right" >行政处罚决定书：</td>
								<td colspan="3"> 
									<table style="width:100%;height:100%;min-height:80px;">
										<c:forEach var="fileItem" items="${ItemProcess14.fileList }">
											<tr style="height:25px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
										</c:forEach> 
										
									</table>
								</td>		
							</tr>
							<tr>
								<td align="right" style="height:40px;">行政处罚决定书说明：</td>
								<td colspan="3">
									<label>${ItemProcess14.content } </label> 									
								</td>		
							</tr>												
						</c:if>
						<!-- 监察室监察行政处罚决定书，并且合规 -->
						<c:if test="${ItemProcess16 != null }">												
							<tr>
								<td align="right" >监察意见：</td>
								<td colspan="3"> 
									<label>${ItemProcess16.content } </label> 		 
								</td>		
							</tr>
							<tr>
								<td align="right" >相关附件：</td>
								<td colspan="3"> 
									<table style="width:100%;height:100%;min-height:80px;">
										<c:forEach var="fileItem" items="${ItemProcess16.fileList }">
											<tr style="height:25px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
										</c:forEach> 
										
									</table>
								</td>		
							</tr>
							<tr>
								<td align="right" style="height:40px;">是否合规：</td>
								<td colspan="3">
									<label>合规 </label> 									
								</td>		
							</tr>												
						</c:if>
						
						<!-- 监察室监察行政处罚决定书，但是不合规 -->
						<c:if test="${ItemProcess17 != null }">												
							<tr>
								<td align="right" >监察意见：</td>
								<td colspan="3"> 
									<label>${ItemProcess17.content } </label> 		 
								</td>		
							</tr>
							<tr>
								<td align="right" >相关附件：</td>
								<td colspan="3"> 
									<table style="width:100%;height:100%;min-height:80px;">
										<c:forEach var="fileItem" items="${ItemProcess17.fileList }">
											<tr style="height:25px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
										</c:forEach> 
										
									</table>
								</td>		
							</tr>
							<tr>
								<td align="right" style="height:40px;">是否合规：</td>
								<td colspan="3">
									<label>不合规 </label> 									
								</td>		
							</tr>												
						</c:if>
						<!-- 需要复议，录入复议相关资料 -->
						<c:if test="${ItemProcess19 != null }">		
							<tr>
								<td align="right" >是否复议：</td>
								<td colspan="3"> 
									<label>需要复议</label> 		 
								</td>		
							</tr>										
							<tr>
								<td align="right" >复议相关资料：</td>
								<td colspan="3"> 
									<label>${ItemProcess19.content } </label> 		 
								</td>		
							</tr>
							<tr>
								<td align="right" >复议资料相关附件：</td>
								<td colspan="3"> 
									<table style="width:100%;height:100%;min-height:80px;">
										<c:forEach var="fileItem" items="${ItemProcess19.fileList }">
											<tr style="height:25px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
										</c:forEach> 
										
									</table>
								</td>		
							</tr>									
						</c:if>
						
						
						<!-- 监察室监察行政处罚决定书，但是不合规 -->
						<c:if test="${ItemProcess18 != null }">												
							<tr>
								<td align="right" >行政处罚情况：</td>
								<td colspan="3"> 
									<label>${ItemProcess18.content } </label> 		 
								</td>		
							</tr>
							<tr>
								<td align="right" >相关附件：</td>
								<td colspan="3"> 
									<table style="width:100%;height:100%;min-height:80px;">
										<c:forEach var="fileItem" items="${ItemProcess18.fileList }">
											<tr style="height:25px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
										</c:forEach> 
										
									</table>
								</td>		
							</tr>									
						</c:if>
						
						
						<!-- 监察结论 -->							
						<c:if test="${ItemProcess9 != null }">
							<tr>
								<td align="right" style="height:40px;">监察结论：</td>
								<td colspan="3">
									<label>${ItemProcess9.content } </label> 									
								</td>		
							</tr>
							<tr>
								<td align="right" >相关附件：</td>
								<td colspan="3"> 
									<table style="width:100%;height:100%;min-height:80px;">
										<c:forEach var="fileItem" items="${ItemProcess9.fileList }">
											<tr style="height:25px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
										</c:forEach> 
										
									</table>
								</td>		
							</tr> 										
						</c:if>
					</table>
				</div>
			</form>
		</div>  
	</div>
	<div class="cl"></div>
</div>
<div class="cl"></div>
</div> 
</body>
</html>  
