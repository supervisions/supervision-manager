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
  
   <title>角色管理</title>
   
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
	 	var taskId = $("#hid_taskId").val();
	 	if(taskId>0){
	 		var itemTypeId = $("#hid_itemTypeId").val();
	 		var array = itemTypeId.split(",");
	 		$.each(array,function(index,arr){
	 			$("#itemType"+arr).attr("checked","checked");
	 		}); 
	 		showOtherTime();
	 	}	
	 	var flag = $("#flag").val();
	 	if(flag == 1){ 
	 		$("#taskName").attr("disabled",true);
	 		$("#ftimes").attr("disabled",true); 
	 	}
	 });
	 
	
	
	function saveRole(obj){ 
		var userName = $("#userName").val();
		var userAccount = $("#userAccount").val();
		var pwd = $("#pwd").val();
		var ppwd = $("#ppwd").val();			
		
		if ($('#userInfoForm').form('validate')) {			
			$(obj).attr("onclick", "");				 
			$('#userInfoForm').form('submit',{				 
		  		success:function(data){ 
					showProcess(false);
		  			data = $.parseJSON(data);				  			
		  			if(data.code==0){	 					
		  				$.messager.alert('保存信息',data.message,'info',function(){
		  					window.location.href="system/role/roleList.do";
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
			<span class="yw-bi-now">基本信息</span>
				
			</div>
			<div class="fr">
				<!-- <span class="yw-btn bg-green mr26 hide" id="editBtn"  onclick="editTask();">编辑</span> -->
				
				<span class="yw-btn bg-red" style="margin-left: 10px;" id="saveBtn" onclick="saveRole(this);">保存</span>
				<span class="yw-btn bg-green" style="margin-left: 10px;margin-right: 10px;" onclick="$('#i_back').click();">返回</span>
			</div>
		</div>
			<form id="userInfoForm" name="userInfoForm" action="<%=basePath%>system/role/jsonSaveOrUpdateRole.do" method="post">
				<div id="tab1" class="yw-tab">
				<table class="yw-cm-table font16" id="taskTable">
					<tr>
						<td width="8%" align="right">角色名称:</td>
						<td> 
							<input id="userName" class="easyui-validatebox" name="name" type="text"  doc="taskInfo" value="${Role.name}" required="true" validType="baseValue" style="width:254px;height:28px;"/>
							<input type="hidden" id="" name="id" doc="taskInfo" value="${Role.id}"/>								
							<span style="color:red">*</span>
						</td>
						<td width="8%"></td>
					</tr> 
					<tr>
						<td width="8%" align="right">角色描述:</td>
						<td> 
							<input id="userAccount" name="description" type="text"  doc="taskInfo" value="${Role.description}" required="true" class="easyui-validatebox" validType="baseValue" style="width:254px;height:28px;"/>								
							<span style="color:red">*</span>
						</td>
						<td width="8%"></td>
					</tr> 	
                                   
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
