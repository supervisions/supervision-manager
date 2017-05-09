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
   
<meta name="viewport"
content="width=device-width, initial-scale=1, minimum-scale=1  ,maximum-scale=1, user-scalable=no" /> 
<!--
<link rel="stylesheet" type="text/css" href="styles.css">
-->

<script type="text/javascript">
	$(document).ready(function(){	 	
	 	
	 });
	
	//新增/编辑项目
	function saveItem(obj){	 	
		var typeId=$("input[name='supervisionTypeId']").val();
		var orgIds=$("input[type='checkbox']:checked").length;

		if(typeId==-1){	
			$.messager.alert("温馨提示！","请选择项目分类!",'error');
			return false;
		}
		if(orgIds==0){
			$.messager.alert("温馨提示！","请选择完成单位!",'error');
			return false;
		}
		if ($('#itemInfoForm').form('validate')) {			
			$(obj).attr("onclick", "");				 
			$('#itemInfoForm').form('submit',{				 
		  		success:function(data){ 
					showProcess(false);
		  			data = $.parseJSON(data);				  			
		  			if(data.code==0){	 					
		  				$.messager.alert('保存信息',data.message,'info',function(){
		  					window.location.href="manage/branch/branchList.do";
	        			});
		  			}else{
						$.messager.alert('错误信息',data.message,'error',function(){
	        			});
						$(obj).attr("onclick", "saveItem(this);"); 
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
				<i id="i_back" class="yw-icon icon-back" onclick="window.location.href='<%=basePath%>manage/branch/branchList.do'"></i><span>项目列表</span>
		</div>
	</div>
	<div class="fl yw-lump mt10">
		<div class="yw-bi-rows">
			<div class="yw-bi-tabs mt5" id="ywTabs">
			<span class="yw-bi-now">基本信息</span>
				
			</div>
			<div class="fr">
				<!-- <span class="yw-btn bg-green mr26 hide" id="editBtn"  onclick="editTask();">编辑</span> -->
				
				<span class="yw-btn bg-red" style="margin-left: 10px;" id="saveBtn" onclick="saveItem(this);">保存</span>
				<span class="yw-btn bg-green" style="margin-left: 10px;margin-right: 10px;" onclick="$('#i_back').click();">返回</span>
			</div>
		</div>
			<form id="itemInfoForm" name="itemInfoForm"
				action="<%=basePath%>manage/branch/jsonSaveOrUpdateItem.do"
				method="post">
				<div id="tab1" class="yw-tab">
					<table class="yw-cm-table font16" id="taskTable">
						<tr>
							<td width="12%" align="right">项目名称：</td>
							<td><input id="" class="easyui-validatebox"
								name="name" type="text" doc="taskInfo" value=""
								required="true" validType="baseValue"
								style="width:254px;height:28px;" /> <input type="hidden"
								id="resourceId" name="id" value="" /> <span
								style="color:red">*</span></td>
							<td width="12%"></td>
						</tr>
						<tr>
							<td width="12%" align="right">项目分类：</td>
							<td><select id="supervisionTypeId" name="supervisionTypeId" class="easyui-combobox"
								style="width:254px;height:28px;">
									<option value="-1">请选择项目分类</option>									
									<c:forEach var="position" items="${meatListByKey}">
										<option value="${position.id}" <c:forEach var="userPost" items="${userPostList}"><c:if test="${position.id == userPost.id}">selected="selected"</c:if></c:forEach>>${position.name}</option>
									</c:forEach>
							</select> <span style="color:red">*</span></td>
							<td width="8%"></td>
						</tr>
						<tr>							
							<td width="12%" align="right">立项时间：</td>
							<td align="left" required="true">								
								<input id="" name="pTime" class="easyui-datebox" data-options="sharedCalendar:'#cc'" style="width:254px;height:28px;" />
								<span style="color:red">*</span>
								<div id="cc" class="easyui-calendar" style="width:254px;height:28px;"></div>
							</td>								
						</tr>
						<tr>
							<td width="12%" align="right">工作要求、方案：</td>
							<td>
								<input class="easyui-validatebox" name="content" type="text" value=""
								 required="true" validType="baseValue" style="width:254px;height:28px;" />
								<span style="color:red">*</span>
							</td>
							<td width="8%"></td>
						</tr>				
					</table>
					<table style="font-size: 16px;">
						<tr>
							<td align="left" style="padding-left: 63px;">选择单位：</td>
							<td>
								<c:forEach var="item" items="${OrgList }">
									<tr><td style="font-weight: 900;">${item.name }</td></tr>
									<tr style="width: 100%;">
										<td>
											<c:forEach var="org" items="${item.itemList }">
												<label style="float:left;"><input type="checkbox" name="OrgId" value="${org.id }"/>${org.name }</label>
											</c:forEach>
										</td>
									</tr>
								</c:forEach>
							</td>
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
