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
    <title>方案管理</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
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
			    pagenumber:'${GradeScheme.pageNo}',                         /* 表示初始页数 */
			    pagecount:'${GradeScheme.pageCount}',                      /* 表示总页数 */
			    totalCount:'${GradeScheme.totalCount}',
			    buttonClickCallback:PageClick                     /* 表示点击分页数按钮调用的方法 */                  
			});  			  
		});
		
PageClick = function(pageclickednumber) {
	$("#pager").pager({
	    pagenumber:pageclickednumber,                 /* 表示启示页 */
	    pagecount:'${GradeScheme.pageCount}',                  /* 表示最大页数pagecount */
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
function deleteGradeScheme(id,name){
	$.messager.confirm("删除确认","确认删除方案："+name+"?",function(r){  
		    if (r){   
			$.ajax({
				url : "manage/casemanage/jsondeleteGradeSchemeById.do?id="+id,
				type : "post",  
		    	dataType : "json",								
				success : function(data) {
		  			if(data.code == 0){ 
		  				$.messager.alert('操作信息',data.message,'info',function(){ 
		  					window.location.href="manage/casemanage/casemanageList.do?pageNo="+${GradeScheme.pageNo};
		      			});
		  			}else{		  			    
						$.messager.alert('错误信息','删除失败！','error');
		  			}  
			    } 
			});
	    }  
	}); 
}
function updateGradeScheme(id,used,name){
	var operation=null;
	if(used==0){
		operation="确认启用方案："+name+"  ?";		
	}else if(used==1){
		operation="确认禁用方案："+name+"  ?";	
	}
	$.messager.confirm("修改确认",operation,function(r){  
		    if (r){   
			$.ajax({
				url : "manage/casemanage/jsonupdateGradeSchemeById.do?id="+id+"&used="+used,
				type : "post",  
		    	dataType : "json",								
				success : function(data) { 									
		  			if(data.code == 0){ 
		  				$.messager.alert('操作信息',data.message,'info',function(){ 
		  					search();  
		      			});
		  			}else{		  			    
						$.messager.alert('错误信息','修改用户状态失败！','error');
		  			}  
			    } 
			});
	    }  
	}); 
}

function editManage(id,orgName){
	window.location.href="manage/casemanage/casemanageInfo.do?id="+id+"&orgName="+orgName;
}
</script>
  </head>
  
  <body>
    <div class="con-right" id="conRight">
		<div class="fl yw-lump">
			<div class="yw-lump-title">
				<i class="yw-icon icon-partner"></i><span>方案列表</span>
				
			</div>
		</div>
		
						
		<div class="fl yw-lump mt10">
			<form id="DeviceForm" name="DeviceForm"
				action="manage/casemanage/casemanageList.do" method="get">
				<div class="pd10">
					<div class="fl">
						<span class="ml26">方案列表</span>						
						<input type="text" name="searchName"   validType="SpecialWord" class="easyui-validatebox" 
							placeholder="搜索" value="${GradeScheme.searchName}" />						
						<span class="yw-btn bg-blue ml30 cur" onclick="search();">搜索</span>
					</div>
					<div class="fr">
						<span class="fl yw-btn bg-green cur" onclick="window.location.href='manage/casemanage/casemanageInfo.do?id='+ 0">新建方案</span>
					</div>
					<div class="cl"></div>
				</div>

				<input type="hidden" id="pageNumber" name="pageNo"
					value="${GradeScheme.pageNo}" />
			</form>
		</div>
           <div class="fl yw-lump"> 
				<table class="yw-cm-table yw-center yw-bg-hover" id="deviceList">
					<tr style="background-color:#D6D3D3;font-weight: bold;">
						<th width="4%" style="display:none">&nbsp;</th>
						<th width="10%" >状态</th>
						<th width="10%" >方案名称</th>
						<th width="10%" >所属机构</th>
						<th width="10%" >是否授权下级</th> 					
						<th width="10%" >操作</th> 
					</tr>
					<c:forEach var="item" items="${GradeSchemeList}">
						<tr>
							<td>
								<c:if test="${item.used == 1}">
									<span>启用</span>
								</c:if> <c:if test="${item.used == 0}">
									<span>禁用</span>
								</c:if>
							</td>
							<td>${item.name }</td>
							<td>${item.orgName }</td>
							<td>
								<c:if test="${item.inherit == 1}">
									<span>是</span>
								</c:if> <c:if test="${item.inherit == 0}">
									<span>否</span>
								</c:if>
							</td>
							<td>
								<c:if test="${item.used == 1}">
									<a style="color:blue" onclick="updateGradeScheme(${item.id},${item.used},'${item.name}');">禁用</a>
								</c:if> 
								<c:if test="${item.used == 0}">
									<a style="color:blue" onclick="updateGradeScheme(${item.id},${item.used},'${item.name}');">启用</a>
								</c:if>
								<a style="color:blue" onclick="deleteGradeScheme(${item.id},'${item.name}');">删除</a>							
								<a style="color:blue" onclick="editManage(${item.id},'${item.orgName }');">编辑</a>
								
							</td>
						</tr>
					</c:forEach>
				</table>
				<div class="page" id="pager"></div> 
		</div>	
		</div> 
  </body>
</html>
