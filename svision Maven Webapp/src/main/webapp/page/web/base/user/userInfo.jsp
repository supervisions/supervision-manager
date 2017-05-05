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
		
		//获取用户所属的机构id
		var userOrgLength =$("input[name='userOrgId']").length;		
		var userOrg = new Array(userOrgLength);		
		for (var i = 0; i < userOrgLength; i++) {
			userOrg[i]=$("[name='userOrgId']")[i].value;
		}		
	 	//加载机构树
	 	$("#orgParentTree").combotree({
			 	 url: 'system/organ/jsonLoadOrganTreeList.do',  
  				 required: false, //是否必须
  				 multiple:true,  //是否支持多选  				 
  				 editable:false, //是否支持用户自定义输入	
  				 cascadeCheck:false,  				 		 
  				 onSelect:function(record){ // 	当节点被选中时触发。
				 	 	$("#areaId").val(record.id); 
  				 },
  				 onBeforeExpand:function(node){ //节点展开前触发，返回 false 则取消展开动作。
  				 	$("#orgParentTree").combotree('tree').tree('options').url = 'area/jsonLoadAreaTreeList.do?pid='+ node.id;
  				 },
  				 onLoadSuccess:function(){ //当数据加载成功时触发。
  				 	//根据user所对应的机构选中复选框
  				 	$("#orgParentTree").combotree('setValues', userOrg);
  				 	var userId = $("#userId").val();
  				 	
  				 	if(userId>0){
  				 		//var pId = $("#areaId").val();
  				 		var orgName = $("#orgName").val();
  				 		$("#orgParentTree").combotree("setText",orgName);
  				 		
  				 	}else{
					//$("#cmbParentArea").combotree("disable",true);
   				 	$("#orgParentTree").combotree("setText","=请选择所属机构=");
				}
  			}
		});	
	 });	
	//新增or修改用户
	function saveOrUpdateUser(obj){ 
		var roleId=$("input[name='roleId']").is(':checked');
		if(roleId==false){	
			$.messager.alert("温馨提示！","请选择用户角色!",'error');
			return false;
		}
		if ($('#userInfoForm').form('validate')) {			
			$(obj).attr("onclick", "");		
			showProcess(true, '温馨提示', '正在提交数据...');		 
			$('#userInfoForm').form('submit',{				 
		  		success:function(data){ 
					showProcess(false);
		  			data = $.parseJSON(data);				  			
		  			if(data.code==0){	 					
		  				$.messager.alert('保存信息',data.message,'info',function(){
		  					window.location.href="system/user/userList.do";
	        			});
		  			}else{
						$.messager.alert('错误信息',data.message,'error',function(){
	        			});
						$(obj).attr("onclick", "saveOrUpdateUser(this);"); 
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
				<i id="i_back" class="yw-icon icon-back" onclick="window.location.href='<%=basePath%>system/user/userList.do'"></i><span>用户列表</span>
		</div>
	</div>
	<div class="fl yw-lump mt10">
		<div class="yw-bi-rows">
			<div class="yw-bi-tabs mt5" id="ywTabs">
			<span class="yw-bi-now">基本信息</span>
				
			</div>
			<div class="fr">
				<!-- <span class="yw-btn bg-green mr26 hide" id="editBtn"  onclick="editTask();">编辑</span> -->
				
				<span class="yw-btn bg-red" style="margin-left: 10px;" id="saveBtn" onclick="saveOrUpdateUser(this);">保存</span>
				<span class="yw-btn bg-green" style="margin-left: 10px;margin-right: 10px;" onclick="$('#i_back').click();">返回</span>
			</div>
		</div>
			<form id="userInfoForm" name="userInfoForm" action="<%=basePath%>system/user/jsonSaveOrUpdateUser.do" method="post">
				<div id="tab1" class="yw-tab">
				<table class="yw-cm-table font16" id="userTable">
					<tr>
						<td width="8%" align="right">用户名称:</td>
						<td> 
							<input id="userName" class="easyui-validatebox" name="name" type="text"  doc="taskInfo" value="${User.name}" required="true" validType="baseValue" style="width:254px;height:28px;"/>
							<input type="hidden" id="userId" name="id" doc="taskInfo" value="${User.id}"/>								
							<span style="color:red">*</span>
						</td>
						<td width="8%"></td>
					</tr> 
					<c:if test="${User.id == 0 || User.id == null }">
						<tr>
							<td width="8%" align="right">用户账号</td>
							<td>
								<input id="userAccount" name="account" type="text"
								doc="taskInfo" value="${User.account}" required="true"
								class="easyui-validatebox" validType="baseValue"
								style="width:254px;height:28px;" />
								<span style="color:red">*</span>
							</td>
							<td width="8%"></td>
						</tr>
						<tr>
							<td width="8%" align="right">用户密码</td>
							<td>
								<input id="pwd" name="pwd" type="password"
								doc="taskInfo" value="${User.name}" required="true"
								class="easyui-validatebox" validType="safepass"
								style="width:254px;height:28px;" /> 
								<span style="color:red">*</span>
							</td>
							<td width="8%"></td>
						</tr>
						<tr>
							<td align="right">确认密码</td>
							<td><input id="ppwd" name="ppwd" type="password"
								doc="taskInfo" value="${User.name}" required="true"
								class="easyui-validatebox" validType="equalTo['#pwd']"
								style="width:254px;height:28px;" /> <span style="color:red">*</span>
							</td>
							<td width="8%"></td>
						</tr>
					</c:if>
					<tr>
						<input type="hidden" id="OrganName" value="" />
						<td align="right">所属机构:</td>
						<td>	
							<!-- t_user_org表中user_id对应的id -->
							<c:forEach var="userOrg" items="${userOrgList}">
								<input name="userOrgId" type="hidden" value="${userOrg.id }" />
							</c:forEach>
							<input id="orgName" name="orgName" type="hidden" value="${User.orgName }" />				
							<input id="orgParentTree" name="orgId" value="" style="width:254px;height:28px;" checkbox="true"  class="easyui-combotree" />
							
							<span style="color:red">*</span>
						</td>
					</tr>
					
					<tr>
						<td width="8%" align="right">职务名称</td>
						<td><select name="postId" multiple="multiple" class="easyui-combobox"
							style="width:254px;height:28px;">								
								<c:forEach var="position" items="${meatListByKey}">
									<option value="${position.id}" <c:forEach var="userPost" items="${userPostList}"><c:if test="${position.id == userPost.id}">selected="selected"</c:if></c:forEach>>${position.name}</option>
								</c:forEach>
						</select> <span style="color:red">*</span></td>
						<td width="8%"></td>
					</tr>
					<tr>
						<td align="right">用户角色</td>						
						<td> 
							<!-- 角色列表 -->
							<c:forEach var="item" items="${roleList }">								
								<label> 
								<input type="checkbox" doc="taskInfo" <c:forEach var="selectItem" items="${userRoleList}"><c:if test="${item.id == selectItem.id}">checked="checked"</c:if></c:forEach> required="true" name="roleId" value="${item.id}" />${item.name}
								</label>
							</c:forEach>
						</td>
						<td width="8%"></td>
					</tr>
					<tr>
						<td align="right">用户状态</td>
						<td><c:if test="${User.used == 1 }">
								<label><input type="radio" name="used" value="1"
									checked="checked" />启用</label>
								<label><input type="radio" name="used" value="0" />禁用</label>
							</c:if> <c:if test="${User.used == 0 || User.used == null}">
								<label><input type="radio" name="used" value="1" />启用</label>
								<label><input type="radio" name="used" value="0"
									checked="checked" />禁用</label>
							</c:if></td>
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
