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
    <title>分行立项</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/source/js/easyUI/themes/default/easyui.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/source/js/easyUI/themes/icon.css"> 
	<script type="text/javascript" src="${pageContext.request.contextPath}/source/js/easyUI/jquery.easyui.min.js"></script>
	<script src="${pageContext.request.contextPath}/source/js/easyUI/easyui-lang-zh_CN.js"></script>
	<script src="${pageContext.request.contextPath}/source/js/common/validate.js"></script>
	<script src="${pageContext.request.contextPath}/source/js/common/common.js"></script>
	<script
	src="${pageContext.request.contextPath}/source/js/pager/jquery.pager.js"></script>
	<link
	href="${pageContext.request.contextPath}/source/js/pager/Pager.css"
	rel="stylesheet" />
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	<script type="text/javascript">
		$(document).ready(function(){
			$("#pager").pager({
			    pagenumber:'${Item.pageNo}',                         /* 表示初始页数 */
			    pagecount:'${Item.pageCount}',                      /* 表示总页数 */
			    totalCount:'${Item.totalCount}',
			    buttonClickCallback:PageClick                     /* 表示点击分页数按钮调用的方法 */                  
			}); 			  
		});
		
PageClick = function(pageclickednumber) {
	$("#pager").pager({
	    pagenumber:pageclickednumber,                 /* 表示启示页 */
	    pagecount:'${Item.pageCount}',                  /* 表示最大页数pagecount */
	    buttonClickCallback:PageClick                 /* 表示点击页数时的调用的方法就可实现javascript分页功能 */            
	});
	
	$("#pageNumber").val(pageclickednumber);          /* 给pageNumber从新赋值 */
	/* 执行Action */
	pagesearch();
}
function search(){
	$("#pageNumber").val("1");
	pagesearch();
}

function pagesearch(){
	if ($('#DeviceForm').form('validate')) {
		DeviceForm.submit();
	}  
}
function deleteItem(id,name){
	$.messager.confirm("删除确认","确认删除项目："+name+"?",function(r){  
		    if (r){   
			$.ajax({
				url : "manage/branch/jsondeleteItemById.do?id="+id,
				type : "post",  
		    	dataType : "json",								
				success : function(data) { 									
		  			if(data.code == 0){ 
		  				$.messager.alert('操作信息',data.message,'info',function(){ 
		  					search();  
		      			});
		  			}else{		  			    
						$.messager.alert('错误信息','删除失败！','error');
		  			}  
			    } 
			});
	    }  
	}); 
}
function edit(id){
	window.location.href="manage/branch/showItem.do?id="+id;
}
function showDialogModel(name){
	$.messager.confirm("操作确认","是否量化该项目："+name+"?",function(r){  
	    if (r){   
	    	window.location.href='<%=basePath %>manage/support/supportFile.do?is';
    	}else{
    		window.location.href='<%=basePath %>manage/support/supportFile.do';
    	}
	}); 
}
</script>
  </head>
  
  <body>
    <div class="con-right" id="conRight">
		<div class="fl yw-lump">
			<div class="yw-lump-title">
				<i class="yw-icon icon-partner"></i><span>项目列表</span>
			</div>
		</div>			
		<div class="fl yw-lump mt10">
			<form id="DeviceForm" name="DeviceForm"
				action="<%=basePath %>manage/support/supportList.do" method="get">
				<div class="pd10">
					<div class="fl">
						<span class="ml26">输入关键字查找</span>						
						<input type="text" name="searchName" validType="SpecialWord" class="easyui-validatebox" 
							placeholder="搜索" value="${Item.searchName}"/> 
						<span>立项时间:</span>
						<input style="width:129px;height:32px;" name="schBeginTime" value="${Item.schBeginTime }" class="easyui-datebox" data-options="sharedCalendar:'#sj'">
						<span>至</span>
						<input style="width:129px;height:32px;" name="schEndTime" value="${Item.schEndTime }" class="easyui-datebox" data-options="sharedCalendar:'#sj'">								
						<div id="sj" class="easyui-calendar"></div>
						<select name="supervisionTypeId" class="easyui-combobox" style="width:129px;height:32px;">									
							<option value="" selected="selected">请选择项目类别</option>
							<c:forEach var="position" items="${meatListByKey}">
								<option value="${position.id}" <c:if test="${Item.supervisionTypeId == position.id}">selected="selected"</c:if>>${position.name}</option>
							</c:forEach>
						</select>
						<select name="used" class="easyui-combobox" style="width:99px;height:32px;">									
							<option value="" >是否完结</option>
							<option value="1" >是</option>
							<option value="0" >否</option>
						</select>
						 
						<span class="yw-btn bg-blue ml30 cur" onclick="search();">搜索</span>
					</div>
					<div class="fr">
						<span class="fl yw-btn bg-green cur" onclick="window.location.href='manage/support/supportInfo.do?pointId='+ 0">新建项目</span>
					</div>
					<div class="cl"></div>
				</div>

				<input type="hidden" id="pageNumber" name="pageNo"
					value="${Device.pageNo}" />
			</form>
		</div>
           <div class="fl yw-lump"> 
				<table class="yw-cm-table yw-center yw-bg-hover" id="deviceList">
					<tr style="background-color:#D6D3D3;font-weight: bold;">
						<th width="4%" style="display:none">&nbsp;</th>
						<th width="15%" >项目名称</th>
						<th width="5%" >项目分类</th>
						<th width="5%" >立项时间</th>  
						<th width="10%" >立项单位（部门）</th>					
						<th width="10%" >完成单位（部门）</th>
						
						<th width="10%" >操作</th> 
					</tr>
					<c:forEach var="item" items="${itemList}">
						<tr>
							<td align="center" style="display:none">${item.id}</td>
							<td><a style="color: blue;" onclick="edit(${item.id})">${item.name}</a></td>
							<td>${item.sType}</td>
							<td>${item.showDate}</td>
							<td>${item.preparerOrg}</td>
							<td>${item.orgName}</td>
							<td>
								<a style="color: blue;" onclick="showDialogModel();">上传资料</a>
								<a style="color: blue;" onclick="deleteItem(${item.id},'${item.name}')">删除</a> 
							</td>							
						</tr>
					</c:forEach>
				</table>
				<div class="page" id="pager"></div> 
		</div>	
		</div> 
  </body>
</html>
