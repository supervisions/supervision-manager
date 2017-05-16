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
<title>廉政监察</title>
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
	    pagenumber:'${Role.pageNo}',                         /* 表示初始页数 */
	    pagecount:'${Role.pageCount}',                      /* 表示总页数 */
	    totalCount:'${Role.totalCount}',				   /* 表示总记录数 */
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
	    pagecount:'${Role.pageCount}',                  /* 表示最大页数pagecount */
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
function deleteRole(id,name){
	$.messager.confirm("删除确认","确认删除角色："+name+"?",function(r){  
		    if (r){   
			$.ajax({
				url : "jsondeleteRoleById.do?id="+id,
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
				<i class="yw-icon icon-partner"></i><span>项目列表</span> 
			</div>
		</div>
		<div class="fl yw-lump mt10">
			
			<form id="toARfrom" action="toAuthorizationResource.do" method="post">
				<input id="toAid" type="hidden" name="id" value="">
				<input id="toAname" type="hidden" name="name" value="">
			</form>
			<form id="taskForm" name="taskForm"
				action="roleList.do" method="get">
				<div class=pd10>
					<div class="fl">  
						<span>条件查询：</span>
						<input type="text" id="seaarchNameTemp" validType="SpecialWord" class="easyui-validatebox" placeholder="搜索" value="${Role.searchName}" /> 
						<input type="hidden" name="searchName" id="hid_serarch" /> 
						
						<span class="yw-btn bg-blue ml30 cur" onclick="search();">搜索</span>						
					</div>

					<div class="fr">
						<span class="yw-btn bg-green cur" onclick="window.location.href='roleInfo.do?id=0';">新增项目</span>
					</div>
					<div class="cl"></div>				
                    	<input type="hidden" id="pageNumber" name="pageNo" value="${Role.pageNo}" />
                </div>
		     </form>
		 </div>	
          <div class="fl yw-lump"> 
			<table class="yw-cm-table yw-center yw-bg-hover" id="taskList">
				<tr style="background-color:#D6D3D3;font-weight: bold;">
					<th width="4%" style="display:none">&nbsp;</th>
					<th>立项情况</th>
					<th>状态</th>	
					<th>工作事项</th>	
					<th>查看</th>	
					<th>项目类别</th>	
					<th>项目名称</th>	
					<th>被监察对象</th>
					
					<th>操作</th>			
				</tr>
				<c:forEach var="item" items="${roleList}">
					<tr> 							
						<td>${item.name}</td>
						<td>${item.description}</td>
						<td><a style="color:blue" onclick="authorizeResource(${item.id},'${item.name}')">资源授权</a></td>
						<td>
							<a style="color:blue" onclick="deleteRole(${item.id},'${item.name}');">删除</a>
							<a style="color:blue" onclick="window.location.href='roleInfo.do?id=${item.id}';">编辑</a>
						</td>
						
					</tr>
				</c:forEach>
			</table>
			<div class="page" id="pager"></div>
			</div>
		</div>

 		

  </body>
</html>












