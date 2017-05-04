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
	 	$("#pid").combotree({
			 url: 'manage/casedetail/jsonLoadSchemeDetailTreeList.do',  
  				 required: false,
  				 onSelect:function(node){  	
  				 	$("#gradeId").val(node.gradeId);		 	 				 	 				 	
  				 },
  				 onBeforeExpand:function(node){
  				 	$("#moudleId").combotree('tree').tree('options').url = 'system/function/jsonLoadFunctionTreeList.do?pid='+ node.id;
  				 },
  				 onLoadSuccess:function(){  				 	
  				 	//编辑时默认选中
  				 	var defaultPid=$("#defaultPid").val();
  				 	$("#pid").combotree('setValue', defaultPid);
  				 	
  				 	var resourceId = $("#resourceId").val();			 	
  				 	if(resourceId>0){  				 		
  				 		var moudleName = $("#moudleName").val();
  				 		$("#pid").combotree("setText",moudleName);  				 		
  				 	}else{
					//$("#moudleId").combotree("disable",true);
   				 	$("#pid").combotree("setText","=请选择所属模块=");
				}
  			}
		});	 	
	 });
	
	//新增/编辑资源
	function saveResource(obj){	 	
		var moudleId=$("#moudle_Id").val();
		//alert(moudleId);
		/* if(moudleId=="" || moudleId==null){	
			$.messager.alert("温馨提示！","请选择所属模块!",'error');
			return false;
		}	 */	
		if ($('#resourceInfoForm').form('validate')) {			
			$(obj).attr("onclick", "");				 
			$('#resourceInfoForm').form('submit',{				 
		  		success:function(data){ 
					showProcess(false);
		  			data = $.parseJSON(data);				  			
		  			if(data.code==0){	 					
		  				$.messager.alert('保存信息',data.message,'info',function(){
		  					window.location.href="manage/casedetail/casedetailList.do";
	        			});
		  			}else{
						$.messager.alert('错误信息',data.message,'error',function(){
	        			});
						$(obj).attr("onclick", "saveResource(this);"); 
		  			}
		  		}
			});
		}
	}
function checkGrade(obj){
	if(obj.value>100){
		$.messager.alert("温馨提示！","分值不能大于100!",'error',function(){
			$("#grade").val("");
		});
	}
}
</script>
 </head> 
 <body>
<div class="con-right" id="conRight">
	<div class="fl yw-lump">
		<div class="yw-lump-title"> 												
				<i id="i_back" class="yw-icon icon-back" onclick="window.location.href='<%=basePath%>system/resource/resourceList.do'"></i><span>角色列表</span>
		</div>
	</div>
	<div class="fl yw-lump mt10">
		<div class="yw-bi-rows">
			<div class="yw-bi-tabs mt5" id="ywTabs">
			<span class="yw-bi-now">基本信息</span>
				
			</div>
			<div class="fr">
				<!-- <span class="yw-btn bg-green mr26 hide" id="editBtn"  onclick="editTask();">编辑</span> -->
				
				<span class="yw-btn bg-red" style="margin-left: 10px;" id="saveBtn" onclick="saveResource(this);">保存</span>
				<span class="yw-btn bg-green" style="margin-left: 10px;margin-right: 10px;" onclick="$('#i_back').click();">返回</span>
			</div>
		</div>
			<form id="resourceInfoForm" name="resourceInfoForm"
				action="<%=basePath%>manage/casedetail/jsonSaveOrUpdateDetail.do"
				method="post">
				<div id="tab1" class="yw-tab">
					<table class="yw-cm-table font16" id="taskTable">
						<tr>
							<td width="8%" align="right">指标名称</td>
							<td><input id="" class="easyui-validatebox"
								name="name" type="text" doc="taskInfo" value="${SchemeDetail.name}"
								required="true" validType="loginName"
								style="width:254px;height:28px;" /> <input type="hidden"
								id="resourceId" name="id" doc="taskInfo" value="${SchemeDetail.id}" /> <span
								style="color:red">*</span></td>
							<td width="8%"></td>
						</tr>
						<tr>
							<td width="8%" align="right">上级指标</td>
							<td>
								<input type="hidden" id="gradeId" name="gradeId" value="">
								<input type="hidden" id="defaultPid" value="${SchemeDetail.pid}">
								<input id="pid" name="pid" doc="pointInfo" type="text"
								class="easyui-combotree" required="true" style="width:256px;height:32px;" />
								<span style="color:red">*</span>
							</td>
							<td width="8%"></td>
						</tr>
						<tr>
							<td width="8%" align="right">分值</td>
							<td><input id="grade" oninput="checkGrade(this)" class="easyui-validatebox"
								name="grade" type="text" doc="taskInfo" value="${SchemeDetail.grade}"
								required="true" validType="loginName"
								style="width:254px;height:28px;" /> 
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
