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
    
    <title>效能监察</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta name="viewport"
	content="width=device-width, initial-scale=1, minimum-scale=1  ,maximum-scale=1, user-scalable=no" /> 
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	<script type="text/javascript">
		$(document).ready(function(){
			
		});
		  
		
		
	</script>
  </head>
  
  <body>
    <div class="con-right" id="conRight">
		<div class="fl yw-lump">
			<div class="yw-lump-title">
				<i  id="i_back"  class="yw-icon icon-back" onclick="javascript:history.back();"></i>
				<span>项目列表</span> 			
			</div>
		</div>

		<div class="fl yw-lump mt10">
			<div class="yw-bi-rows">
				<div class="yw-bi-tabs mt5" id="ywTabs">
					<span class="yw-bi-now">基本信息</span>
				</div>
				<div class="fr">
					<span class="yw-btn bg-red mr26" id="saveBtn" onclick="">保存</span> 
					<span class="yw-btn bg-green mr26"  onclick="$('#i_back').click();">返回</span>
				</div>
			</div>
			<div>
	<form id="devicePointForm" name="devicePointForm" action="device/jsonSaveOrUpdatePoint.do" method="post">
		<div id="tab1" class="yw-tab">
			<table class="yw-cm-table font16">
				<tr>	
					<td align="right" width="12%">监察项目：</td>
					<td  align="left" ><input  name="name" type="text" value="" class="easyui-validatebox" required="true" style="width:354px;height:28px;" />
					<span style="color:red">*</span>
					</td>
					
				</tr>
				
				<tr>	
					<td align="right">监察内容：</td>
					<td  align="left" ><input  name="content" type="text" value=""  class="easyui-validatebox"  style="width:354px;height:28px;" />
					<span style="color:red">*</span>
					</td>
				</tr>
				<tr>	
					<td align="right">规定完成时间：</td>
					<td  align="left" ><input  name="EndTime" type="text" value="" class="easyui-datebox" data-options="sharedCalendar:'#sj'"style="width:354px;height:32px;" />
					<span style="color:red">*</span>
					<div id="sj" class="easyui-calendar"></div>
					</td> 
			    </tr>
				<tr>
					<td align="right">是否分节点监察：</td>
					<td  align="left" >
					<select name="isStept" class="easyui-validatebox" required="true" style="width:354px;height:32px;">
						<option value="0">否</option>
						<option value="1">是</option>
					</select>
					<span style="color:red">*</span>
					</td> 
			    </tr>
				<tr>	
					<td align="right">被监察对象:</td>
					<td  align="left" ><input  name="" type="text" value="" class="easyui-validatebox" required="true" style="width:354px;height:28px;" />
					<span style="color:red">*</span> 
					</td> 
				</tr>
				<tr>	
					<td align="right">责任领导:</td>
					<td  align="left" ><input  name="" type="text" value="" class="easyui-validatebox" required="true" style="width:354px;height:28px;" />
					<span style="color:red">*</span>
					</td>
			    </tr>
				
			</table> 
		</div>  
	</form>
	</div>
    </div>
       <div class="cl"></div>
	</div>
	<div class="cl"></div> 
  </body>
</html>
