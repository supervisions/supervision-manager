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
  
   <title>廉政监察</title>
   
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
				<i id="i_back" class="yw-icon icon-back" onclick="window.location.href='<%=basePath%>vision/incorrupt/incorruptList.do'"></i><span>廉政监察列表</span>
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
						<!-- 初始状态 -->
						<tr>
							<td width="15%" align="right">工作事项：</td>
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
							<td align="right" style="height:40px;">项目名称：</td>
							<td colspan="3">
								<label>${ItemProcess.content } </label> 
							</td>		
						</tr> 
						<tr>
							<td align="right">项目分类：</td>
							<td colspan="3">
							 <label>${Item.sType } </label>   
							</td>								
						</tr>
						<tr>
							<td align="right">项目类别：</td>
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
						<c:if test="${Item.status!=0 }">
							<tr>
								<td align="right">立项时间：</td>
								<td colspan="3">
								 <label>${Item.preparerTimes } </label>   
								</td>								
							</tr>
						</c:if>												
						
						
										
						<!-- 被监察对象录入方案状态 -->						
						<c:if test="${ItemProcess2 != null }">
							<tr>
								<td align="right" style="height:40px;">方案内容：</td>
								<td colspan="3">
									<label>${ItemProcess2.content } </label> 									
								</td>		
							</tr> 
							<tr>
								<td align="right" >方案附件：</td>
								<td colspan="3"> 
									<table style="width:100%;height:100%;min-height:80px;">
										<c:forEach var="fileItem" items="${ItemProcess2.fileList }">
											<tr style="height:25px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
										</c:forEach> 
										
									</table>
								</td>		
							</tr>
						</c:if>
						<!-- 监察室给出监察意见，但是项目不合规 -->		
						<c:if test="${ItemProcess0 != null }">
							<tr>
								<td align="right" style="height:40px;">监察意见：</td>
								<td colspan="3">
									<label>${ItemProcess0.content } </label> 									
								</td>	
							</tr>
							<tr>
								<td align="right" >相关附件：</td>
								<td colspan="3"> 
									<table style="width:100%;height:100%;min-height:80px;">
										<c:forEach var="fileItem" items="${ItemProcess0.fileList }">
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
						<!-- 被监察对象录入会议决策 -->
						<c:if test="${ItemProcess6 != null }">
							<tr>
								<td align="right" style="height:40px;">会议决策内容：</td>
								<td colspan="3">
									<label>${ItemProcess6.content } </label>
									
								</td>		
							</tr>
							<tr>
								<td align="right" >会议决策相关附件：</td>
								<td colspan="3"> 
									<table style="width:100%;height:100%;min-height:80px;">
										<c:forEach var="fileItem" items="${ItemProcess6.fileList }">
											<tr style="height:20px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
										</c:forEach> 
										
									</table>
								</td>		
							</tr>								
						</c:if>
						
						<!-- 监察室根据会议决策，给出意见，并且无异议 -->
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
								<td align="right">是否有异议：</td>
								<td colspan="3">
									<label>无异议</label>									
								</td>		
							</tr>								
						</c:if>
						<!-- 有异议提请党委 -->
						<c:if test="${ItemProcess8 != null && ItemProcess4==null}">
							<tr>
								<td align="right" style="height:40px;">监察意见：</td>
								<td colspan="3">
									<label>${ItemProcess8.content } </label>									
								</td>		
							</tr>
							<tr>
								<td align="right" >相关附件：</td>
								<td colspan="3"> 
									<table style="width:100%;height:100%;min-height:80px;">
										<c:forEach var="fileItem" items="${ItemProcess8.fileList }">
											<tr style="height:20px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
										</c:forEach> 
										
									</table>
								</td>		
							</tr>		
							<tr>
								<td align="right">是否有异议：</td>
								<td colspan="3">
									<label>有异议</label> 									
								</td>		
							</tr>						
						</c:if>
						<!-- 党委意见，重新决策 -->
						<c:if test="${ItemProcess13 != null}">
							<tr>
								<td align="right" style="height:40px;">党委意见：</td>
								<td colspan="3">
									<label>${ItemProcess13.content } </label>									
								</td>		
							</tr>											
						</c:if>
						<!-- 党委意见，维持原决议 -->
						<c:if test="${ItemProcess14 != null}">
							<tr>
								<td align="right" style="height:40px;">党委意见：</td>
								<td colspan="3">
									<label>${ItemProcess14.content } </label>									
								</td>		
							</tr>											
						</c:if>
						<!-- 被监察对象录入执行情况-->
						<c:if test="${ItemProcess5 != null }">
							<tr>
								<td align="right" style="height:40px;">执行情况：</td>
								<td colspan="3">
									<label>${ItemProcess5.content } </label> 									
								</td>		
							</tr> 
							<tr>
								<td align="right" >相关附件：</td>
								<td colspan="3"> 
									<table style="width:100%;height:100%;min-height:80px;">
										<c:forEach var="fileItem" items="${ItemProcess5.fileList }">
											<tr style="height:20px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
										</c:forEach> 
										
									</table>
								</td>		
							</tr>
						</c:if>
						<!-- 监察室监察执行情况，并且监察合规 -->
						<c:if test="${ItemProcess7 != null }">
							<tr>
								<td align="right" style="height:40px;">监察执行情况意见：</td>
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
								<td align="right">执行情况是否合规：</td>
								<td colspan="3">
									<label>合规</label> 									
								</td>		
							</tr> 
						</c:if>	
						
						<!-- 监察室监察执行情况，但是不合规，并且不问责 -->	
						<c:if test="${ItemProcess11 != null }">
							<tr>
								<td align="right" style="height:40px;">监察执行情况意见：</td>
								<td colspan="3">
									<label>${ItemProcess11.content } </label> 									
								</td>		
							</tr>
							<tr>
								<td align="right" >相关附件：</td>
								<td colspan="3"> 
									<table style="width:100%;height:100%;min-height:80px;">
										<c:forEach var="fileItem" items="${ItemProcess11.fileList }">
											<tr style="height:25px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
										</c:forEach> 
										
									</table>
								</td>		
							</tr>
							<tr>
								<td align="right">执行情况是否合规：</td>
								<td colspan="3">
									<label>不合规</label> 									
								</td>		
							</tr>
							<tr>
								<td align="right">是否问责：</td>
								<td colspan="3">
									<label>不问责</label> 									
								</td>		
							</tr> 						
						   <%--  <tr>
								<td align="right" >相关附件：</td>
								<td colspan="3"> 
									<table style="width:100%;height:100%;min-height:80px;">
										<c:forEach var="fileItem" items="${ItemProcess11.fileList }">
											<tr style="height:25px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
										</c:forEach> 
										
									</table>
								</td>		
							</tr> --%>
						</c:if>	
						
						<!-- 需要问责，问责前一节点的监察意见 -->
						<c:if test="${ItemProcess10 != null }">
							<tr>
								<td align="right" style="height:40px;">对执行情况的意见：</td>
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
								<td align="right" style="height:40px;">执行情况是否合规：</td>
								<td colspan="3">
									<label>不合规</label> 									
								</td>		
							</tr>
							<tr>
								<td align="right" style="height:40px;">是否问责：</td>
								<td colspan="3">
									<label>问责</label> 									
								</td>		
							</tr>						
							<%-- <tr>
								<td align="right" >相关附件：</td>
								<td colspan="3"> 
									<table style="width:100%;height:100%;min-height:80px;">
										<c:forEach var="fileItem" items="${ItemProcess10.fileList }">
											<tr style="height:25px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
										</c:forEach> 
										
									</table>
								</td>		
							</tr> --%>
						</c:if>	
						<!-- 问责相关资料 -->
						<c:if test="${ItemProcess12 != null }">
							<tr>
								<td align="right" style="height:40px;">问责资料：</td>
								<td colspan="3">
									<label>${ItemProcess12.content } </label> 									
								</td>		
							</tr>
							<tr>
								<td align="right" >相关附件：</td>
								<td colspan="3"> 
									<table style="width:100%;height:100%;min-height:80px;">
										<c:forEach var="fileItem" items="${ItemProcess12.fileList }">
											<tr style="height:20px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
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
