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
  
   <title>效能监察</title>
   
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
				<i id="i_back" class="yw-icon icon-back" onclick="window.location.href='<%=basePath%>vision/efficiency/efficiencyList.do'"></i><span>效能监察列表</span>
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
				<div id="tab1" class="yw-tab">
					<table class="font16 taskTable"  cellpadding="0" cellspacing="0">
						<!-- 初始状态 -->
						<tr>
							<td width="12%" align="right">项目名称：</td>
							<td colspan="3">
								 <label>${Item.name } </label>  
							</td> 
						</tr>
						<tr>
							<td align="right">相关附件：</td>
							<td colspan="3"> 
								<table style="width:100%;height:100%;min-height:80px;">
									<c:forEach var="fileItem" items="${ItemProcess.fileList }">
										<tr style="height:25px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
									</c:forEach> 								
								</table>
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
							<td align="right" style="height:100px;">监察内容：</td>
							<td colspan="3">
								<label>${ItemProcess.content } </label> 
							</td>		
						</tr> 
							
						
										
						
						<!-- 不分节点上传资料状态 -->
						<c:if test="${Item.isStept==0 }">
							<!-- 不分节点的显示方案 -->
							<c:if test="${ItemProcess2 != null }">
								<tr>
									<td align="right" >资料内容：</td>
									<td colspan="3">
										<label>${ItemProcess2.content } </label> 									
									</td>		
								</tr> 
								<tr>
									<td align="right" >资料附件：</td>
									<td colspan="3"> 
										<table style="width:100%;height:100%;min-height:80px;">
											<c:forEach var="fileItem" items="${ItemProcess2.fileList }">
												<tr style="height:25px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
											</c:forEach> 
											<tr><td style="border:0px;"></td><tr>
										</table>
									</td>		
								</tr>
							</c:if>
						</c:if>
						
						
						
						<!-- 分节点上传资料状态 -->
						<c:if test="${Item.isStept==1 }">
							<!-- 显示初始资料部分和初始资料监察意见 -->
							<c:if test="${ItemProcess2 != null }">
								<tr>
									<td align="right">初始资料内容：</td>
									<td colspan="3">
										<label>${ItemProcess2.content } </label> 									
									</td>		
								</tr> 
								<tr>
									<td align="right" >初始资料附件：</td>
									<td colspan="3"> 
										<table style="width:100%;">
											<c:forEach var="fileItem" items="${ItemProcess2.fileList }">
												<tr><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
											</c:forEach>										
										</table>
									</td>		
								</tr>
								<c:forEach var="item" items="${ipYJList }" begin="0" end="0">
									<tr>
										<td align="right">监察意见：</td>
										<td colspan="3">
											<label>${item.content } </label> 									
										</td>		
									</tr> 
									<tr>
										<td align="right" >相关附件：</td>
										<td colspan="3"> 
											<table style="width:100%;">
												<c:forEach var="fileItem" items="${item.fileList }">
													<tr><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
												</c:forEach>										
											</table>
										</td>		
									</tr>								
								</c:forEach>
							</c:if>
							<!-- 显示每个节点的的资料和监察意见 -->	
							<c:forEach var="item" items="${ipList }" varStatus="varStatusA">
								<tr>
									<td align="right">节点${varStatusA.index+1 }资料内容：</td>
									<td colspan="3">
										<label>${item.content } </label> 									
									</td>		
								</tr> 
								<tr>
									<td align="right" >节点${varStatusA.index+1 }资料附件：</td>
									<td colspan="3"> 
										<table style="width:100%;">
											<c:forEach var="fileItem" items="${item.fileList }">
												<tr><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
											</c:forEach>										
										</table>
									</td>		
								</tr>
								<c:forEach var="item" items="${ipYJList }" begin="${varStatusA.index+1 }" end="${varStatusA.index+1 }">
									<tr>
										<td align="right">监察意见：</td>
										<td colspan="3">
											<label>${item.content } </label> 									
										</td>		
									</tr> 
									<tr>
										<td align="right" >相关附件：</td>
										<td colspan="3"> 
											<table style="width:100%;">
												<c:forEach var="fileItem" items="${item.fileList }">
													<tr><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
												</c:forEach>										
											</table>
										</td>		
									</tr>								
								</c:forEach>								
							</c:forEach>							
						</c:if>				
						
												
						<c:if test="${ItemProcess3 != null }">
							<tr>
								<td align="right">监察意见：</td>
								<td colspan="3">
									<label>${ItemProcess3.content } </label> 
									
								</td>		
							</tr>
							<tr>
								<td align="right" >相关附件：</td>
								<td colspan="3"> 
									<table style="width:100%;">
										<c:forEach var="fileItem" items="${ItemProcess3.fileList }">
											<tr style="height:25px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
										</c:forEach>									
									</table>
								</td>		
							</tr>
							<tr>
								<td align="right" >是否需要整改：</td>
								<td>
									<label>无需整改</label> 
								</td>		
							</tr> 							
						</c:if>
						<c:if test="${ItemProcess4 != null }">
							<tr>
								<td align="right" >监察意见：</td>
								<td colspan="3">
									<label>${ItemProcess4.content } </label>								
								</td>		
							</tr>
							<tr>
								<td align="right" >相关附件：</td>
								<td colspan="3"> 
									<table style="width:100%;" >
										<c:forEach var="fileItem" items="${ItemProcess4.fileList }">
											<tr style="height:25px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
										</c:forEach> 										
									</table>
								</td>		
							</tr>
							<tr>
								<td align="right" >是否需要整改：</td>
								<td>
									<label>需要整改</label> 
								</td>		
							</tr> 							
						</c:if>
						
						<!-- 录入整改情况 -->
						<c:if test="${ItemProcess5 != null }">
							<tr>
								<td align="right">整改内容：</td>
								<td colspan="3">
									<label>${ItemProcess5.content } </label> 									
								</td>		
							</tr> 
							<tr>
								<td align="right" >整改附件：</td>
								<td colspan="3"> 
									<table style="width:100%;">
										<c:forEach var="fileItem" items="${ItemProcess5.fileList }">
											<tr style="height:25px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
										</c:forEach>										
									</table>
								</td>		
							</tr>
						</c:if>
						
						<c:if test="${ItemProcess6 != null }">
							<tr>
								<td align="right">是否问责：</td>
								<td colspan="3">
									<label>${ItemProcess6.content } </label>									
								</td>		
							</tr>							
						</c:if>
						<c:if test="${ItemProcess10 !=null && ItemProcess6 == null && ItemProcess7 == null}">
							<td align="right">是否问责：</td>
								<td colspan="3">
									<label>${ItemProcess10.content } </label> 									
								</td>
						</c:if>					
						
						<c:if test="${ItemProcess9 != null }">
							<tr>
								<td align="right">问责资料：</td>
								<td colspan="3">
									<label>${ItemProcess9.content } </label> 									
								</td>		
							</tr> 
							<tr>
								<td align="right" >相关附件：</td>
								<td colspan="3"> 
									<table style="width:100%;">
										<c:forEach var="fileItem" items="${ItemProcess9.fileList }">
											<tr style="height:25px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
										</c:forEach>									
									</table>
								</td>		
							</tr>						
						</c:if>
						<!-- 录入整改情况 -->
						<c:if test="${ItemProcess7 != null }">
							<tr>
								<td align="right">再次录入整改情况：</td>
								<td colspan="3">
									<label>${ItemProcess7.content } </label> 									
								</td>		
							</tr> 
							<tr>
								<td align="right" >相关附件：</td>
								<td colspan="3"> 
									<table style="width:100%;">
										<c:forEach var="fileItem" items="${ItemProcess7.fileList }">
											<tr style="height:25px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
										</c:forEach>									
									</table>
								</td>		
							</tr>
						</c:if>
						<c:if test="${ItemProcess8 != null }">
							<tr>
								<td align="right">监察结论：</td>
								<td colspan="3">
									<label>${ItemProcess8.content } </label> 
									
								</td>		
							</tr>
							<tr>
								<td align="right" >相关附件：</td>
								<td colspan="3"> 
									<table style="width:100%;">
										<c:forEach var="fileItem" items="${ItemProcess8.fileList }">
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
	
	<div class="cl"></div>
</div>
<div class="cl"></div>
</div>
<div id="dialog"></div>
</body>
</html>  
