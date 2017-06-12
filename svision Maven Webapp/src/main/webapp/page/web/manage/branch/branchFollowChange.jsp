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
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/source/js/easyUI/themes/default/easyui.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/source/js/easyUI/themes/icon.css"> 
	<script type="text/javascript" src="${pageContext.request.contextPath}/source/js/easyUI/jquery.easyui.min.js"></script>
	<script src="${pageContext.request.contextPath}/source/js/easyUI/easyui-lang-zh_CN.js"></script>
	<script src="${pageContext.request.contextPath}/source/js/common/validate.js"></script>
	<script src="${pageContext.request.contextPath}/source/js/common/common.js"></script>
	<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1  ,maximum-scale=1, user-scalable=no" />
	<script src="${pageContext.request.contextPath}/source/js/pager/jquery.pager.js"></script>
	<link href="${pageContext.request.contextPath}/source/js/pager/Pager.css" rel="stylesheet" />
	<link rel="shortcut icon" href="<%=basePath%>source/images/favicon.ico" type="image/x-icon" />

<script type="text/javascript"> 
	  
	function downLoadFile(path,name){
		var filePath = encodeURI(encodeURI(path));
		var fileName = encodeURI(encodeURI(name));
		window.open("<%=basePath %>system/upload/downLoadFile.do?filePath="+filePath+"&fileName="+fileName);
	} 
	function followStatusClick(stus){
		if(stus==0){
			if($("#tr_followContent").hasClass("displaynone")){
				$("#tr_followContent").removeClass("displaynone");
			} 
			$("#hid_isFollowStatus").val(0);
		}else{
			if(!$("#tr_followContent").hasClass("displaynone")){
				$("#tr_followContent").addClass("displaynone");
			} 
			$("#ar_followContent").val("");
			$("#ar_followContent").text("");
			$("#hid_isFollowStatus").val(1);
		}
	}
	 function followAction(itemId,status){
	 	var obj = {};
	 	obj.id = $.trim($("#hid_itemId").val());
	 	obj.isFollow = $.trim($("#hid_isFollowStatus").val());
	 	obj.content = $.trim($("#ar_followContent").val()); 
		$.ajax({
			url : "<%=basePath%>manage/branch/jsonfollowItemById.do",
			type : "post",  
	    	dataType : "json",		
	    	data:obj,						
			success : function(data) { 									
	  			if(data.code == 0){ 
	  				$.messager.alert('操作信息',data.message,'info',function(){ 
	  				 	window.location.href='<%=basePath%>manage/branch/branchFHList.do';
	      			});
	  			}else{		  			    
					$.messager.alert('错误信息','删除失败！','error');
	  			}  
		    } 
		});
	 }
	 function returnPage(){
		layer.confirm('当前项目资料尚未提交，是否离开当前页面？', {
			btn: ['确认','取消'] //按钮
		}, function(){//点击确认按钮调用
			layer.close(layer.confirm());//关闭当前弹出层
			 window.location.href='<%=basePath%>manage/branch/branchFHList.do';
		}, function(){
			
		});
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
			<span class="yw-bi-now">上传资料</span>
				
			</div>
			<div class="fr">
				<!-- <span class="yw-btn bg-green mr26 hide" id="editBtn"  onclick="editTask();">编辑</span> -->
				
				<span class="yw-btn bg-red" style="margin-left: 10px;" id="saveBtn" onclick="followAction();">提交</span>
				<span class="yw-btn bg-green" style="margin-left: 10px;margin-right: 10px;" onclick="$('#i_back').click();">返回</span>
			</div>
		</div>
		<div style="width:100%;max-height:700px; overflow-x:hidden; ">
			<form id="itemInfoForm" name="itemInfoForm" >
				<div id="tab1" class="yw-tab">
					<table class="font16 taskTable"  cellpadding="0" cellspacing="0">
						<tr>
							<td width="8%" align="right">项目名称：</td>
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
						 <tr>
								<td align="right" style="height:40px;">是否跟踪：</td>
								<td colspan="3">  
									<label><input type="radio" name="isFollow" value="1" checked="checked"  onclick="followStatusClick(1);" />不跟踪</label>
									<label><input type="radio" name="isFollow" value="0"  onclick="followStatusClick(0);" />跟踪</label> 
								 </td>	
							</tr> 
							<tr id="tr_followContent" class="displaynone">
								<td align="right" style="height:50px;">跟踪意见：</td>
								<td colspan="3">  
									<input type="hidden" value="${Item.id }" id="hid_itemId" />
									<input type="hidden" id="hid_isFollowStatus" value="1" />
									<textarea rows="4" cols="5" style="width:60%;" id="ar_followContent" name="content" ></textarea>	
								 </td>	
							</tr> 	
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
