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
	 	//加载机构树
	 	$("#orgParentTree").combotree({
			 	 url: 'system/organ/jsonLoadOrganTreeList.do',  
  				 required: false, //是否必须				 
  				 editable:false, //是否支持用户自定义输入	
  				 cascadeCheck:false, //是否支持级联选中 				 		 
  				 onSelect:function(record){ // 	当节点被选中时触发。
  				 		alert(record.name);
				 	 	$("#orgId").val(record.id); 
  				 },
  				 onBeforeExpand:function(node){ //节点展开前触发，返回 false 则取消展开动作。
  				 	$("#orgParentTree").combotree('tree').tree('options').url = 'area/jsonLoadAreaTreeList.do?pid='+ node.id;
  				 },
  				 onLoadSuccess:function(){ //当数据加载成功时触发。
  				 	//根据方案所对应的机构选中 
  				 	var orgId=$("#orgId").val();  				 	
  				 	$("#orgParentTree").combotree('setValues', orgId);
  				 	if(orgId>0){  				 	
  				 		var orgName = $("#orgName").val();  				 		
  				 		$("#orgParentTree").combotree("setText",orgName);
  				 		
  				 	}else{
					//$("#cmbParentArea").combotree("disable",true);
   				 	$("#orgParentTree").combotree("setText","=请选择所属机构=");
				}
  			}
		});	
	 });
	
	//新增/编辑资源
	function saveScheme(obj){	 	
		var moudleId=$("#orgId").val();
		//alert(moudleId);
		if(moudleId=="" || moudleId==null){	
			$.messager.alert("温馨提示！","请选择所属机构!",'error');
			return false;
		}		
		if ($('#gradeSchemeInfoForm').form('validate')) {			
			$(obj).attr("onclick", "");				 
			$('#gradeSchemeInfoForm').form('submit',{				 
		  		success:function(data){ 
					showProcess(false);
		  			data = $.parseJSON(data);				  			
		  			if(data.code==0){	 					
		  				$.messager.alert('保存信息',data.message,'info',function(){
		  					window.location.href="manage/casemanage/casemanageList.do";
	        			});
		  			}else{
						$.messager.alert('错误信息',data.message,'error',function(){
	        			});
						$(obj).attr("onclick", "saveScheme(this);"); 
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
				<i id="i_back" class="yw-icon icon-back" onclick="window.location.href='<%=basePath%>manage/casemanage/casemanageList.do'"></i><span>方案列表</span>
		</div>
	</div>
	<div class="fl yw-lump mt10">
		<div class="yw-bi-rows">
			<div class="yw-bi-tabs mt5" id="ywTabs">
			<span class="yw-bi-now">基本信息</span>
				
			</div>
			<div class="fr">
				<!-- <span class="yw-btn bg-green mr26 hide" id="editBtn"  onclick="editTask();">编辑</span> -->
				
				<span class="yw-btn bg-red" style="margin-left: 10px;" id="saveBtn" onclick="saveScheme(this);">保存</span>
				<span class="yw-btn bg-green" style="margin-left: 10px;margin-right: 10px;" onclick="$('#i_back').click();">返回</span>
			</div>
		</div>
			<form id="gradeSchemeInfoForm" name="gradeSchemeInfoForm"
				action="<%=basePath%>manage/casemanage/jsonSaveOrUpdateGradeScheme.do"
				method="post">
				<div id="tab1" class="yw-tab">
					<table class="yw-cm-table font16" id="taskTable">
						<tr>
							<td width="10%" align="right">方案名称：</td>
							<td><input id="" class="easyui-validatebox"
								name="name" type="text" doc="taskInfo" value="${GradeScheme.name}"
								required="true" validType="loginName"
								style="width:254px;height:28px;" /> <input type="hidden"
								id="resourceId" name="id" doc="taskInfo" value="${GradeScheme.id}" /> <span
								style="color:red">*</span></td>
							<td width="8%"></td>
						</tr>
						<tr>
							<td width="10%" align="right">所属机构：</td>
							<td>
								<input type="hidden" id="orgName" value="${GradeScheme.orgName }"/>
								<input type="hidden" id="orgId" value="${GradeScheme.orgId}"/>
								<input id="orgParentTree" name="orgId" value="" style="width:254px;height:28px;" class="easyui-combotree" />
								<span style="color:red">*</span>
							</td>
							<td width="8%"></td>
						</tr>
						<tr>
							<td width="10%" align="right">是否授权下级：</td>
							<td>
								<c:if test="${GradeScheme.inherit == 1 }">
									<label><input type="radio" name="inherit" value="1"
										checked="checked" />是</label>
									<label><input type="radio" name="inherit" value="0" />否</label>
								</c:if> 
								<c:if test="${GradeScheme.inherit == 0 || GradeScheme.inherit == null}">
									<label><input type="radio" name="inherit" value="1" />是</label>
									<label><input type="radio" name="inherit" value="0" checked="checked" />否</label>
										
								</c:if>
							</td>
						</tr>							
						<tr>
							<td width="10%" align="right">状态：</td>
							<td>
								<c:if test="${GradeScheme.used == 1}">
									<label><input type="radio" name="used" value="1" checked="checked" />启用</label>									
									<label><input type="radio" name="used" value="0" />禁用</label>
								</c:if> 
								<c:if test="${GradeScheme.used == 0 or GradeScheme.used==null}">
									<label><input type="radio" name="used" value="1" />启用</label>
									<label><input type="radio" name="used" value="0" checked="checked" />禁用</label>									
								</c:if>
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
