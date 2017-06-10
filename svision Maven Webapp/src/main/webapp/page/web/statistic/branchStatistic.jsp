<%@ page language="java" import="java.util.*" contentType="text/html;charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta charset="utf-8">
<title>分行立项统计</title>
<meta http-equiv="refresh" content="3600">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/source/js/easyUI/themes/default/easyui.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/source/js/easyUI/themes/icon.css"> 
	<script type="text/javascript" src="${pageContext.request.contextPath}/source/js/easyUI/jquery.easyui.min.js"></script>
	<script src="${pageContext.request.contextPath}/source/js/easyUI/easyui-lang-zh_CN.js"></script>
	<script src="${pageContext.request.contextPath}/source/js/common/validate.js"></script>
	<script src="${pageContext.request.contextPath}/source/js/common/common.js"></script>
<meta name="viewport"
	content="width=device-width, initial-scale=1, minimum-scale=1  ,maximum-scale=1, user-scalable=no" />
<script
	src="${pageContext.request.contextPath}/source/js/pager/jquery.pager.js"></script>
<link
	href="${pageContext.request.contextPath}/source/js/pager/Pager.css"
	rel="stylesheet" />
<script type="text/javascript">
$(document).ready(function(){
	  
	var s = $.trim($("#hid_moudleId").val());	
	if(s.length>0){
		$("#slt_moudleId").combobox("setValue",s);
	} 
	setDefaultDate();  
}); 	 
function search(){
	$("#pageNumber").val("1"); 
	if ($('#logForm').form('validate')) {
		logForm.submit();
	}
}  
function resetSearch(){
	$("#slt_moudleId").combobox("setText","=选择监察类型进行查询="); 
	$("#dtx_schBeginTime").datebox("setValue","");
	$("#dtx_schEndTime").datebox("setValue","");
}
</script> 
</head>
<body>
	<div class="con-right" id="conRight">	
		<div class="fl yw-lump">
			<div class="yw-lump-title">
				<i class="yw-icon icon-partner"></i><span>分行立项统计列表</span> 
			</div>
		</div>
		<div class="fl yw-lump mt10">
			<form id="logForm" name="logForm"
				action="<%=basePath %>statistic/branch/branchStatistic.do" method="get">
				<div class=pd10>
					<div class="fl">   
						<input type="hidden" value="${Item.supervisionTypeId}" id="hid_moudleId" />
						<span>监察类型：</span>
						<select id="slt_moudleId" name="supervisionTypeId" class="easyui-combobox"  style="width:184px;height:32px;" >
							<option value="">=选择监察类型进行查询=</option>
							<option value="2">效能监察</option>
							<option value="3">廉政监察</option>
							<option value="4">执法监察</option> 
						</select>  
						<span>起止时间:</span>
						<input style="width:129px;height:32px;" id="dtx_schBeginTime" name="schBeginTime" value="${Item.schBeginTime }" class="easyui-datebox" data-options="sharedCalendar:'#sj',editable:false,onSelect:stTimeslt">
						<span>至</span>
						<input style="width:129px;height:32px;" id="dtx_schEndTime" name="schEndTime" value="${Item.schEndTime }" class="easyui-datebox" data-options="sharedCalendar:'#sj',editable:false,onSelect:stTimeslt">								
						<div id="sj" class="easyui-calendar"></div>
						<span class="yw-btn bg-red ml30 cur" onclick="resetSearch();">重置</span>		<span class="yw-btn bg-blue ml30 cur" onclick="search();">搜索</span>						
					</div> 
						<div class="cl"></div>				   
                     </div>
		     	</form>
		     	</div>
				
           <div class="fl yw-lump"> 
				<table class="yw-cm-table yw-center yw-bg-hover" >
					<tr style="background-color:#D6D3D3;font-weight: bold;"> 				
						<th style="font-size:18px;font-weight:bold;">项目总记录数</th>	
						<th style="font-size:18px;font-weight:bold;">已完成项目</th>
						<th style="font-size:18px;font-weight:bold;">未完成项目</th>
						<th style="font-size:18px;font-weight:bold;">逾期未完成项目</th>		
						<th style="font-size:18px;font-weight:bold;">逾期完成项目</th> 		 
					</tr>
					<tr> 				
						<td style="font-size:18px;font-weight:bold;color:blue;">${StatisticModel.totalCount }</td>	 
						<td style="font-size:18px;font-weight:bold;color:green;">${StatisticModel.comCount }</td>
						<td style="font-size:18px;font-weight:bold;color:blue;">${StatisticModel.unComCount }</td>
						<td style="font-size:18px;font-weight:bold;color:red;">${StatisticModel.overUnComCount }</td>		
						<td style="font-size:18px;font-weight:bold;color:red;">${StatisticModel.overComCount }</td> 		 
					</tr> 
				</table>
				<br />
				<table class="yw-cm-table yw-center yw-bg-hover" >
					<tr style="background-color:#D6D3D3;"> 		
						<th style="font-size:20px;font-weight: bold;color: black;text-align:left;" colspan="6">各机构项目统计明细 </th> 		 
					</tr> 
					<tr style="background-color:#D6D3D3;font-weight: bold;"> 		 		  
						<th style="font-size:18px;font-weight:bold;">机构名称</th>	
						<th style="font-size:18px;font-weight:bold;">立项总数</th>
						<th style="font-size:18px;font-weight:bold;">完成项目</th>
						<th style="font-size:18px;font-weight:bold;">未完成项目</th>		 
						<th style="font-size:18px;font-weight:bold;">逾期未完成项目</th>		
						<th style="font-size:18px;font-weight:bold;">逾期完成项目</th>	    
					</tr> 
				</table>
				<div style="max-height:350px;overflow-x:hidden;">
					<table class="yw-cm-table yw-center yw-bg-hover" > 
					 	<c:forEach var="item" items="${TotalList }">
						 	<tr> 			
								<td>${item.orgName }</td>		
								<td>${item.totalCount }</td>	
								<td>${item.comCount }</td>
								<td>${item.unComCount }</td>
								<td>${item.overUnComCount }</td>		
								<td>${item.overComCount }</td> 		 
							</tr>
					 	</c:forEach> 
					</table>
				</div> 
				</div>
			</div>
  </body>
</html>

