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
  
   <title>权限管理</title>
   
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/source/js/easyUI/themes/default/easyui.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/source/js/easyUI/themes/icon.css"> 
	<script type="text/javascript" src="${pageContext.request.contextPath}/source/js/easyUI/jquery.easyui.min.js"></script>
	<script src="${pageContext.request.contextPath}/source/js/easyUI/easyui-lang-zh_CN.js"></script>
	<script src="${pageContext.request.contextPath}/source/js/common/validate.js"></script>
	<script src="${pageContext.request.contextPath}/source/js/common/common.js"></script>
<meta name="viewport"
content="width=device-width, initial-scale=1, minimum-scale=1  ,maximum-scale=1, user-scalable=no" /> 
<!--
<link rel="stylesheet" type="text/css" href="styles.css">
-->

<script type="text/javascript">
	$(document).ready(function(){
	 	
	 });
	 
	
	
	function saveRole(obj){ 		
		if ($('#userInfoForm').form('validate')) {			
			$(obj).attr("onclick", "");	
			showProcess(true, '温馨提示', '正在提交数据...');					 
			$('#userInfoForm').form('submit',{				 
		  		success:function(data){ 
					showProcess(false);
		  			data = $.parseJSON(data);				  			
		  			if(data.code==0){	 					
		  				$.messager.alert('保存信息',data.message,'info',function(){
		  					window.location.href="system/permission/permissionList.do";
	        			});
		  			}else{
						$.messager.alert('错误信息',data.message,'error',function(){
	        			});
						$(obj).attr("onclick", "saveRole(this);"); 
		  			}
		  		}
			});
		}
	}
 
</script>
 </head> 
 <body>
<div class="con-right" id="conRight">
	<div class="fl yw-lump">
		<div class="yw-lump-title"> 												
				<i id="i_back" class="yw-icon icon-back" onclick="window.location.href='<%=basePath%>system/role/roleList.do'"></i><span>角色列表</span>
		</div>
	</div>
	<div class="fl yw-lump mt10">
		<div class="yw-bi-rows">
			<div class="yw-bi-tabs mt5" id="ywTabs">
			<span class="yw-bi-now">资源授权</span>
			</div>
			<div class="fr">
				<!-- <span class="yw-btn bg-green mr26 hide" id="editBtn"  onclick="editTask();">编辑</span> -->
				
				<span class="yw-btn bg-red" style="margin-left: 10px;" id="saveBtn" onclick="saveRole(this);">保存</span>
				<span class="yw-btn bg-green" style="margin-left: 10px;margin-right: 10px;" onclick="$('#i_back').click();">返回</span>
			</div>
		</div>
			<form id="userInfoForm" name="userInfoForm" action="<%=basePath%>system/permission/jsonSaveOrUpdateRoleResource.do" method="post">
				<div id="tab1" class="yw-tab" style="padding:15px;">
				<span style="font-size: 20px">当前权限:</span><input class="easyui-validatebox" readonly="readonly" value="${resourceConfig.name }"style="width:228px;height:20px; padding-left: 12px; background-color: #ccc;"/>		
				<table class="yw-cm-table font16" id="taskTable">
					<input type="hidden" name="permissionId" value="${resourceConfig.id }">
					<c:forEach var="item" items="${resourceList }">
					<tr>
						<td style="font-weight: 900;"><sapn>所属模块：</sapn>${item.name }</td>
					</tr>
					<tr>	
						<td>					
							<c:forEach var="rse" items="${item.itemList }">
								<label style="float: left;padding-right:15px;"><input type="checkbox"  name="resourceId" value="${rse.id }" <c:forEach var="roleResource" items="${permissionResourceList }"><c:if test="${roleResource.resourceId ==rse.id  }">checked="checked"</c:if></c:forEach>>${rse.name }</label>
							</c:forEach>
						</td>
					</tr> 	
                    </c:forEach>               
				</table>  
				</div>
			</form>
		</div> 
	
	<div class="cl"></div>
</div>
<div class="cl"></div>
</div>
</body>
</html>  
