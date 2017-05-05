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
	 	$("#moudleId").combotree({
			 url: 'system/function/jsonLoadFunctionTreeList.do',  
  				 required: false,
  				 onSelect:function(node){ 
  				 	//alert($(this).tree('getRoot', node.target));
  				 	//$(this).tree('getRoot', node.target);		 			 	 				 	
				 	$("#moudle_Id").val(node.id); 				 	
  				 },
  				 onBeforeSelect:function(node){                    
                    //返回树对象
					var tree = $(this).tree;
					//选中的节点是否为叶子节点,如果不是叶子节点,清除选中
					var isLeaf = tree('isLeaf', node.target);					
                    if(!isLeaf){
                    	 $.messager.alert("温馨提示！","根节点不可选，请选择子节点！",'error');
                        $("#moudle_Id").tree("unselect");
                       
                    }
                 },
  				 onBeforeExpand:function(node){
  				 	$("#moudleId").combotree('tree').tree('options').url = 'system/function/jsonLoadFunctionTreeList.do?pid='+ node.id;
  				 },
  				 onLoadSuccess:function(){
  				 	//编辑时默认选中
  				 	var mid=$("#moudle_Id").val();
  				 	$("#moudleId").combotree('setValue', mid);
  				 	
  				 	var resourceId = $("#resourceId").val();  				 	
  				 	if(resourceId>0){  				 		
  				 		var moudleName = $("#moudleName").val();
  				 		$("#moudleId").combotree("setText",moudleName);  				 		
  				 	}else{
					//$("#moudleId").combotree("disable",true);
   				 	$("#moudleId").combotree("setText","=请选择所属模块=");
				}
  			}
		});	 	
	 });
	
	//新增/编辑资源
	function saveResource(obj){	 	
		var moudleId=$("#moudle_Id").val();
		//alert(moudleId);
		if(moudleId=="" || moudleId==null){	
			$.messager.alert("温馨提示！","请选择所属模块!",'error');
			return false;
		}		
		if ($('#resourceInfoForm').form('validate')) {			
			$(obj).attr("onclick", "");				 
			$('#resourceInfoForm').form('submit',{				 
		  		success:function(data){ 
					showProcess(false);
		  			data = $.parseJSON(data);				  			
		  			if(data.code==0){	 					
		  				$.messager.alert('保存信息',data.message,'info',function(){
		  					window.location.href="system/resource/resourceList.do";
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
				action="<%=basePath%>system/resource/jsonSaveOrUpdateResource.do"
				method="post">
				<div id="tab1" class="yw-tab">
					<table class="yw-cm-table font16" id="taskTable">
						<tr>
							<td width="8%" align="right">资源名称</td>
							<td><input id="" class="easyui-validatebox"
								name="name" type="text" doc="taskInfo" value="${ResourceConfig.name}"
								required="true" validType="baseValue"
								style="width:254px;height:28px;" /> <input type="hidden"
								id="resourceId" name="id" doc="taskInfo" value="${ResourceConfig.id}" /> <span
								style="color:red">*</span></td>
							<td width="8%"></td>
						</tr>
						<tr>
							<td width="8%" align="right">资源地址</td>
							<td><input id="" class="easyui-validatebox"
								name="resource" type="text" doc="taskInfo" value="${ResourceConfig.resource}"
								required="true" validType=""
								style="width:254px;height:28px;" /> 
								<span style="color:red">*</span>
							</td>							
							<td width="8%"></td>
						</tr>
						<tr>
							<input type="hidden" id="OrganName" value="" />
							<td align="right">所属模块:</td>
							<td align="left" required="true">
								<input type="hidden" id="moudle_Id" name="moudle_Id" value="${ResourceConfig.moudleId }"/>
								<input type="hidden" id="moudleName" value="${ResourceConfig.functionName}"/>
								<input id="moudleId" name="moudleId" doc="pointInfo" type="text"
								class="easyui-combotree" required="true" style="width:254px;height:28px;" />
								<span style="color:red">*</span>
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
