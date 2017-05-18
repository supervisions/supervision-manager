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

	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/source/js/easyUI/themes/default/easyui.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/source/js/easyUI/themes/icon.css"> 
	<script type="text/javascript" src="${pageContext.request.contextPath}/source/js/easyUI/jquery.easyui.min.js"></script>
	<script src="${pageContext.request.contextPath}/source/js/easyUI/easyui-lang-zh_CN.js"></script>
	<script src="${pageContext.request.contextPath}/source/js/common/validate.js"></script>
	<script src="${pageContext.request.contextPath}/source/js/common/common.js"></script>
<script type="text/javascript">
	$(document).ready(function(){	 	
	 	
	 });
	
	/* //新增/编辑项目
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
	} */
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
				<span class="yw-btn bg-red" style="margin-left: 10px;" id="saveBtn" onclick="saveItem(this);">保存</span>
				<span class="yw-btn bg-green" style="margin-left: 10px;margin-right: 10px;" onclick="$('#i_back').click();">返回</span>
			</div>
		</div>
			<form id="itemInfoForm" name="itemInfoForm"
				action="<%=basePath%>manage/branch/jsonSaveOrUpdateItem.do"
				method="post">
				<div id="tab1" class="yw-tab">
					<table class="yw-cm-table font16" id="taskTable" border="1">
						<tr>
							<td width="15%" align="right">项目名称：</td>
							<td align="left">${Showitem.name }</td>
						</tr>
						<tr>
							<td width="15%" align="right">项目分类：</td>
							<td align="left">${Showitem.sType }</td>
						</tr>
						<tr>
							<td width="15%" align="right">立项时间：</td>
							<td align="left">${Showitem.showDate}</td>
						</tr>
						<!-- <tr>
							<td width="15%" align="right">项目属性：</td>
							<td align="left"></td>
						</tr> -->
						<tr>
							<td width="15%" align="right">工作要求、方案：</td>
							<td align="left"></td>
						</tr>
						<tr>
							<td width="15%" align="right">上传资料：</td>
							<td align="left"></td>
						</tr>
						<tr>
							<td width="15%" align="right">监察结论：</td>
							<td align="left"></td>
						</tr>
						<tr>
							<td width="15%" align="right">整改意见：</td>
							<td align="left"></td>
						</tr>
						<tr>
							<td width="15%" align="right">整改报告：</td>
							<td align="left"></td>
						</tr>
						<tr>
							<td width="15%" align="right">跟踪监察：</td>
							<td align="left"></td>
						</tr>
						<tr>
							<td width="15%" align="right">上报跟踪监察整改情况：</td>
							<td align="left"></td>
						</tr>
						<tr>
							<td width="15%" align="right">其他：</td>
							<td align="left"></td>
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
