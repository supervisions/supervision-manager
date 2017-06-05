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
  
   <title>指标管理</title>
   
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
			 var gId = $("#hid_gradeId").val();
			 if(gId >0){ 
			 	$("#slt_moudleId").combobox("setValue",gId);
			 }
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
		$.messager.alert("温馨提示！","权重不能大于100!",'error',function(){
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
				<i id="i_back" class="yw-icon icon-back" onclick="window.location.href='<%=basePath%>manage/casedetail/casedetailList.do'"></i><span>方案明细列表</span>
		</div>
	</div>
	<div class="fl yw-lump mt10">
		<div class="yw-bi-rows">
			<div class="yw-bi-tabs mt5" id="ywTabs">
			<span class="yw-bi-now">基本信息</span>
				
			</div>
			<div class="fr">  
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
							<td width="8%" align="right">指标名称：</td> 
							<td width="25%" >
								<input class="easyui-validatebox" name="name" type="text" value="${SchemeDetail.name}" required="true" validType="baseValue" style="width:254px;height:28px;" /> 
								<input type="hidden" name="id"  value="${SchemeDetail.id}" /> 
								<input type="hidden" name="pid"  value="${SchemeDetail.pid}" /> 
								<input type="hidden" name="level"  value="${SchemeDetail.level}" /> 
								<span style="color:red">*</span></td>
							<td ></td>
						</tr>
						<tr>
							<c:if test="${SchemeDetail.level == 0 }">
								<td align="right">所属模型：</td>
								<td>  
									<input type="hidden" value="${SchemeDetail.gradeId}" id="hid_gradeId" /> 
									<select id="slt_moudleId" name="gradeId" class="easyui-combobox"  style="width:254px;height:28px;" > 
										<option value="">=选择所属量化模型=</option>
										<c:forEach var="item" items="${SchemeList }">
											<option value="${item.id }">${item.name }</option>
										</c:forEach> 
									</select>
									<span style="color:red">*</span> 
								</td>
								<td></td>
							</c:if>
							<c:if test="${SchemeDetail.level > 0 }">
								<td align="right">所属模型：</td>
								<td>  
									<input type="hidden" value="${SchemeDetail.gradeId}" id="hid_gradeId" /> 
									<select id="slt_moudleId" class="easyui-combobox" data-options="disabled:true"  style="width:254px;height:28px;" > 
										<option value="">=选择所属量化模型=</option>
										<c:forEach var="item" items="${SchemeList }">
											<option value="${item.id }">${item.name }</option>
										</c:forEach> 
									</select> 
								</td>
								<td> 
									<label>一级指标：</label> 
									<input type="hidden" value="${SchemeDetail.gradeId}"  name="gradeId" /> 
								 	<label>${SchemeDetail.pName}</label>
								 	<c:if test="${SchemeDetail.level == 2  }"> 
										<label style="margin-left:30px;">二级指标：</label>  
									 	<label>${SchemeDetail.ppName}</label>
								 	</c:if>
								 </td>
							</c:if> 
						</tr>
						<tr>
							<c:if test="${SchemeDetail.level < 2  }"> 
								<td align="right">权重：</td>
							</c:if>
							<c:if test="${SchemeDetail.level == 2  }"> 
								<td align="right">标准分值：</td>
							</c:if>
							<td><input id="grade" oninput="checkGrade(this)" class="easyui-validatebox"
								name="grade" type="text" doc="taskInfo" value="${SchemeDetail.grade}"
								required="true" validType="number"
								style="width:254px;height:28px;" /> 
								<span style="color:red">*</span>
							</td>							
							<td ></td>
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
