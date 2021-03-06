<%@ page language="java" import="java.util.*"
	contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<base href="<%=basePath%>">

<title>任务管理</title>

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
	$(document).ready(function() {	
		//获取机构所属的机构pid
		var orgpid=$("#orgPid").val();
		//加载机构树
	 	$("#orgParentTree").combotree({
			 	 url: '<%=basePath %>system/organ/jsonLoadOrganTreeList.do',  
  				 required: false, //是否必须
  				 //multiple:true,  //是否支持多选  				 
  				 editable:false, //是否支持用户自定义输入	  				 		 
  				 onSelect:function(record){ // 	当节点被选中时触发。  	
  				 		if(record.path=="" ||record.path==null){  				 			
  				 			$("#orgPath").val(record.id);  				 			
  				 		}else{
  				 			$("#orgPath").val(record.path+"."+record.id);
  				 		}  				 		  				 			
				 	 	$("#orgPid").val(record.id); 
  				 },
  				 onBeforeExpand:function(node){ //节点展开前触发，返回 false 则取消展开动作。  				  
  				 	$("#orgParentTree").combotree('tree').tree('options').url = '<%=basePath %>system/organ/jsonLoadOrganTreeList.do?pid='+ node.id;
  				 },
  				 onLoadSuccess:function(){ //当数据加载成功时触发。  				 	
  				 	//根据所对应的机构选中复选框
  				 	$("#orgParentTree").combotree('setValues', orgpid);
  				 	var orgId = $("#orgId").val();  				 	
  				 	//判断是新增还是编辑	 	
  				 	if(orgId>0){ 				 		
  				 		//var orgName = $("#orgName").val();
  				 		//$("#orgParentTree").combotree("setText",orgName);  				 		
  				 	}else{
						//$("#cmbParentArea").combotree("disable",true);
	   				 	$("#orgParentTree").combotree("setText","=请选择所属机构=");
					}
  				}
		});	
	});
	
	function saveOrgan(obj) {
		
		if ($('#userInfoForm').form('validate')) {
			$(obj).attr("onclick", "");
			//showProcess(true, '温馨提示', '正在提交数据...');
			$('#userInfoForm')
					.form(
							'submit',
							{
								success : function(data) {
									showProcess(false);
									data = $.parseJSON(data);
									if (data.code == 0) {
										$.messager
												.alert(
														'保存信息',
														data.message,
														'info',
														function() {
															window.location.href = "<%=basePath %>system/organ/organList.do";
														});
									} else {
										$.messager.alert('错误信息', data.message,
												'error', function() {
												});
										$(obj).attr("onclick",
												"saveOrgan(this);");
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
				<i id="i_back" class="yw-icon icon-back"
					onclick="window.location.href='<%=basePath%>system/organ/organList.do'"></i><span>机构列表</span>
			</div>
		</div>
		<div class="fl yw-lump mt10">
			<div class="yw-bi-rows">
				<div class="yw-bi-tabs mt5" id="ywTabs">
					<span class="yw-bi-now">基本信息</span>

				</div>
				<div class="fr">
					<!-- <span class="yw-btn bg-green mr26 hide" id="editBtn"  onclick="editTask();">编辑</span> -->

					<span class="yw-btn bg-red" style="margin-left: 10px;" id="saveBtn"
						onclick="saveOrgan(this);">保存</span> <span class="yw-btn bg-green"
						style="margin-left: 10px;margin-right: 10px;"
						onclick="$('#i_back').click();">返回</span>
				</div>
			</div>
			<form id="userInfoForm" name="userInfoForm"
				action="<%=basePath%>system/organ/jsonSaveOrUpdateOrgan.do"
				method="post">
				<div id="tab1" class="yw-tab">
					<table class="yw-cm-table font16" id="taskTable">
						<tr>
							<td width="10%" align="right">机构名称:</td>
							<td><input id="orgName" class="easyui-validatebox"
								name="name" type="text" doc="taskInfo" value="${Organ.name}"
								required="true" validType="baseValue"
								style="width:254px;height:28px;" /> 
								<input type="hidden"id="orgId" name="id" doc="taskInfo" value="${Organ.id}" /> 
								<span style="color:red">*</span>
								<input type="hidden" name="path" id="orgPath" value="">
							</td>			
							<td width="8%"></td>
						</tr>								
						<tr>
							<input type="hidden" id="OrganName" value="" />
							<td align="right">所属机构:</td>
							<td>							
								<input id="orgPid" name="pid" type="hidden" value="${Organ.pid }" />
								<input id="orgParentTree" name="" value="" style="width:254px;height:28px;" checkbox="true"  class="easyui-combotree" />
								
								<span style="color:red">*</span>
							</td>
						</tr>
						<tr>							
							<td align="right">机构类型:</td>
							<td>							
								<select name="orgtype" class="easyui-combobox" style="width:254px;height:28px;">
									<option value="0">=请选择机构类型=</option>
									<c:forEach var="item" items="${OrgType }">
										<option value="${item.id }" <c:if test="${item.id == Organ.orgtype}">selected="selected"</c:if>>${item.name }</option>
									</c:forEach>
									
								</select>								
								<span style="color:red">*</span>
							</td>
						</tr>									
						<tr>
							<td align="right">是否监察部门:</td>
							<td>
								<c:if test="${Organ.supervision==1}">
									<label><input type="radio" name="supervision" value="1"
										checked="checked" />是</label>
									<label><input type="radio" name="supervision" value="0" />否</label>
								</c:if>
								<c:if test="${Organ.supervision == 0 || Organ.supervision == null}">
									<label><input type="radio" name="supervision" value="1" />是</label>
									<label><input type="radio" name="supervision" value="0" checked="checked" />否</label>										
								</c:if>
							</td>
							<td width="8%"></td>
						</tr>
						<tr>
							<td align="right">机构状态:</td>
							<td>
								<c:if test="${Organ.used==1}">
									<label><input type="radio" name="used" value="1"
										checked="checked" />启用</label>
									<label><input type="radio" name="used" value="0" />禁用</label>
								</c:if>
								<c:if test="${Organ.used==0 || Organ.used==null}">
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
