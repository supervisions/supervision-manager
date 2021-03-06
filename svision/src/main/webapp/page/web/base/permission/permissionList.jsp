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
<title>权限管理</title>
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
	$("#pager").pager({
	    pagenumber:'${Permission.pageNo}',                         /* 表示初始页数 */
	    pagecount:'${Permission.pageCount}',                      /* 表示总页数 */
	    totalCount:'${Permission.totalCount}',				   /* 表示总记录数 */
	    buttonClickCallback:PageClick                     /* 表示点击分页数按钮调用的方法 */                  
	});		
	$("#seaarchNameTemp").keypress(function(e){
		if(e.keyCode == 13){
			search();
		}
	});			
}); 		 
PageClick = function(pageclickednumber) {
	$("#pager").pager({
	    pagenumber:pageclickednumber,                 /* 表示启示页 */
	    pagecount:'${Permission.pageCount}',                  /* 表示最大页数pagecount */
	    buttonClickCallback:PageClick                 /* 表示点击页数时的调用的方法就可实现javascript分页功能 */            
	});	
	$("#pageNumber").val(pageclickednumber);          /* 给pageNumber从新赋值 */
	/* 执行Action */
	pagesearch();
}
function search(){
	$("#pageNumber").val("1");
	$("#hid_serarch").val(encodeURI($("#seaarchNameTemp").val()));
	pagesearch(); 
} 
function pagesearch(){
	if ($('#taskForm').form('validate')) {
		taskForm.submit();
	}
}


function deletePermission(id,name){
	$.messager.confirm("删除确认","确认删除资源："+name+"?",function(r){  
		    if (r){   
			$.ajax({
				url : "<%=basePath%>system/permission/jsondeletePermissionById.do?id="+id,
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
function authorizeResource(id,name){
	$("#toAid").val(id);
	$("#toAname").val(name);
	$("#toARfrom").submit();
	
	//window.location.href="toAuthorizationResource.do?id="+id+"&name="+name;
}

</script>
</head>
<body>
	<div class="con-right" id="conRight">	
		<div class="fl yw-lump">
			<div class="yw-lump-title">
				<i class="yw-icon icon-partner"></i><span>权限列表</span> 
			</div>
		</div>
		<div class="fl yw-lump mt10">
			<form id="toARfrom" action="toAuthorizationResource.do" method="post">
				<input id="toAid" type="hidden" name="id" value="">
				<input id="toAname" type="hidden" name="name" value="">
			</form>
			<form id="taskForm" name="taskForm"
				action="<%=basePath%>system/permission/permissionList.do" method="get">
				<div class=pd10>
					<div class="fl">  
						<span>条件查询：</span>
						<input type="text" id="seaarchNameTemp" validType="SpecialWord" class="easyui-validatebox" placeholder="搜索关键字：名称，地址" value="${Permission.searchName}" /> 
						<input type="hidden" name="searchName" id="hid_serarch" /> 
						
						<span class="yw-btn bg-blue ml30 cur" onclick="search();">搜索</span>						
					</div>
					<div class="fr">
					<span class="yw-btn bg-green cur" onclick="window.location.href='<%=basePath%>system/permission/permissionInfo.do?id=0';">新增权限</span> 
					</div>
						<div class="cl"></div>				
                     <input type="hidden" id="pageNumber" name="pageNo" value="${Permission.pageNo}" />
                     </div>
		     	</form>
		     	</div>
				
           <div class="fl yw-lump"> 
				<table class="yw-cm-table yw-center yw-bg-hover" id="taskList">
					<tr style="background-color:#D6D3D3;font-weight: bold;">
						<th width="4%" style="display:none">&nbsp;</th>						
						<th width="20%">权限名称</th>	
						<th width="10%">所属模块</th>
						<th width="5%">资源分配</th>
						<th width="20%">权限描述</th>
						<th width="5%">操作一</th>	
						<th width="10%">操作二</th>			
					
					</tr>
					<c:forEach var="item" items="${PermissionList}">
						<tr>
						<td>${item.name}</td>
						<td>${item.fName}</td>
						<%-- <td><a style="color:blue" onclick="authorizeResource(${item.id},'${item.name}')">资源授权</a></td> --%>
							 <td>	<span class="yw-btn-small bg-green cur" onclick="authorizeResource(${item.id},'${item.name}')">资源授权</span>	</td>
						<td>${item.description}</td>
						<td>														
							<%-- <a style="color:blue" onclick="window.location.href='resourceInfo.do?id=${item.id}';">编辑</a>	 --%>
								<span class="yw-btn-small bg-lan cur" onclick="window.location.href='<%=basePath%>system/permission/permissionInfo.do?id=${item.id}';">编辑</span>						
						</td>
						<td>
							<%-- <a style="color:blue" onclick="deleteResource(${item.id},'${item.name}');">删除</a> --%>
								<span class="yw-btn-small bg-red cur" onclick="deletePermission(${item.id},'${item.name}');">删除</span>
						</td>
						</tr>
					</c:forEach>
					
				</table>
				<div class="page" id="pager"></div>
				</div>
			</div>
  </body>
</html>

