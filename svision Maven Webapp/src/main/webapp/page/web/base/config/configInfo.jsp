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

<meta name="viewport"
	content="width=device-width, initial-scale=1, minimum-scale=1  ,maximum-scale=1, user-scalable=no" />
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/source/js/easyUI/themes/default/easyui.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/source/js/easyUI/themes/icon.css"> 
	<script type="text/javascript" src="${pageContext.request.contextPath}/source/js/easyUI/jquery.easyui.min.js"></script>
	<script src="${pageContext.request.contextPath}/source/js/easyUI/easyui-lang-zh_CN.js"></script>
	<script src="${pageContext.request.contextPath}/source/js/common/validate.js"></script>
	<script src="${pageContext.request.contextPath}/source/js/common/common.js"></script>
<!--
<link rel="stylesheet" type="text/css" href="styles.css">
-->

<script type="text/javascript">
	$(document).ready(function() {
		//判断是否是子配置
		isFirst();	
	});

	function isFirst(){
		//判断是否是子配置		
		var cfgType=$('input:radio[name="configType"]:checked').val();		
		if(cfgType == 0){									
			$("#configPid").hide();
			$("#configKey").show();		
			return 0;
		}else if(cfgType == 1) {
			$("#kerValue").val("null");			
			$("#configPid").show();
			$("#configKey").hide();
			return 1;
		}
	}
	function saveMeta(obj){	
		if(isFirst()==1){
			if($(":input[name=pid]").val()==0){			
				$.messager.alert("温馨提示！","请选择所属配置!",'error');
				return false;
			}
		}else if(isFirst()==0){			
			if($("#kerValue").val()=="null"){			
				$.messager.alert("温馨提示！","请修改关键字!",'error');
				return false;
			}
		}		
		if ($('#metaInfoForm').form('validate')) {
			$(obj).attr("onclick", ""); 
			//showProcess(true, '温馨提示', '正在提交数据...'); 
			$('#metaInfoForm').form('submit',{
		  		success:function(data){
					showProcess(false);
		  			data = $.parseJSON(data);
		  			if(data.code==0){
		  				$.messager.alert('保存信息',data.message,'info',function(){ 
							window.location.href ="<%=basePath %>system/config/configList.do";
	        			});
		  			}else{
						$.messager.alert('错误信息',data.message,'error',function(){
	        			});
						$(obj).attr("onclick", "saveMeta(this);"); 
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
					onclick="window.location.href='<%=basePath%>system/config/configList.do'"></i><span>配置列表</span>
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
						onclick="saveMeta(this);">保存</span> <span class="yw-btn bg-green"
						style="margin-left: 10px;margin-right: 10px;"
						onclick="$('#i_back').click();">返回</span>
				</div>
			</div>
			<form id="metaInfoForm" name="metaInfoForm"
				action="<%=basePath%>system/config/jsonSaveOrUpdateMeta.do"
				method="post">
				<div id="tab1" class="yw-tab">
					<table class="yw-cm-table font16" id="taskTable">						
						<tr>
							<td width="8%" align="right">配置名称:</td>
							<td><input id="userAccount" name="name" type="text"
								doc="taskInfo" value="${Config.name}" required="true"
								class="easyui-validatebox" validType="baseValue"
								style="width:254px;height:28px;" /> 
								<input type="hidden" name="id" value="${Config.id}" />
								<span style="color:red">*</span>
							</td>
							<td width="8%"></td>
						</tr>
						<tr>
							<td align="right">配置类型</td>
							<td>
								<c:if test="${Config.pid != 0}">
									<label><input type="radio" name="configType" onclick="isFirst();" value="1" checked="checked"/>子配置</label>
									<label><input type="radio" name="configType" onclick="isFirst();" value="0"/>根配置</label>		
								</c:if>
								<c:if test="${Config.pid == 0}">
									<label><input type="radio" name="configType" onclick="isFirst();" value="1"/>子配置</label>
									<label><input type="radio" name="configType" onclick="isFirst();" value="0" checked="checked"/>根配置</label>		
								</c:if>																
							<td width="8%"></td>
						</tr>
						<tr id="configPid">
							<td width="8%" align="right">所属配置:</td>
							<td>
								<select id="pidValue" name="pid" class="easyui-combobox"
								style="width:254px;height:28px;">	
									<c:if test="${Config.pid ==0 || Config.pid ==null }">	
										<option value="0" selected="selected">请选择所属配置</option>											
									</c:if>								
									<c:forEach var="ascription" items="${configList }">										
										<c:if test="${Config.pid !=0 and Config.pid !=null}">
											<option value="${ascription.id }" <c:if test="${ascription.id ==Config.pid }">selected="selected"</c:if>>${ascription.name }</option>
										</c:if>		
										<c:if test="${Config.pid ==0 || Config.pid ==null }">
											<option value="${ascription.id }">${ascription.name }</option>
										</c:if>								
									</c:forEach>
								</select>
								<span style="color:red">*</span>
							</td>
							<td width="8%"></td>
						</tr>
						<tr id="configKey">
							<td width="8%" align="right">关键字:</td>
							<td><input id="kerValue" name="key" type="text"
								doc="taskInfo" value="${Config.key}" required="false"
								class="easyui-validatebox" validType="loginName"
								style="width:254px;height:28px;" /> <span style="color:red">*</span>
							</td>
							<td width="8%"></td>
						</tr>
						<tr>
							<td width="8%" align="right">配置描述:</td>
							<td><input id="userAccount" name="description" type="text"
								doc="taskInfo" value="${Config.description}" required="false"
								class="easyui-validatebox" validType="baseValue"
								style="width:254px;height:28px;" /> <span style="color:red">*</span>
							</td>
							<td width="8%"></td>
						</tr>
						<tr>
							<td align="right">配置状态</td>
							<td><c:if test="${Config.used == 1 }">
									<label><input type="radio" name="used" value="1"
										checked="checked" />启用</label>
									<label><input type="radio" name="used" value="0" />禁用</label>
								</c:if> <c:if test="${Config.used == 0 || Config.used == null}">
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
