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
<title>任务管理</title>
<meta http-equiv="refresh" content="3600">
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
	    pagenumber:'${ResourceConfig.pageNo}',                         /* 表示初始页数 */
	    pagecount:'${ResourceConfig.pageCount}',                      /* 表示总页数 */
	    totalCount:'${ResourceConfig.totalCount}',				   /* 表示总记录数 */
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
	    pagecount:'${ResourceConfig.pageCount}',                  /* 表示最大页数pagecount */
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
/* function showdialog(){
	var wz = getDialogPosition($('#taskInfoWindow').get(0),100);
	$('#taskInfoWindow').window({
		  	top: 100,
		    left: wz[1],
		    onBeforeClose: function () {
		    },
		    onClose:function(){
		    	$('#saveTaskForm .easyui-validatebox').val(''); 
		    }
	});
	$('#taskInfoWindow').window('open');
} */
function deleteResource(id,name){
	$.messager.confirm("删除确认","确认删除资源："+name+"?",function(r){  
		    if (r){   
			$.ajax({
				url : "jsondeleteResourceById.do?id="+id,
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
/* function updateResource(id,used,name){
	var operation=null;
	if(used==0){
		operation="确认禁用资源："+name+"  ?";		
	}else if(used==1){
		operation="确认启用资源："+name+"  ?";	
	}
	$.messager.confirm("修改确认",operation,function(r){  
		    if (r){   
			$.ajax({
				url : "jsonupdateUserById.do?id="+id+"&used="+used,
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
function resetUserPwd(id,name){
	$.messager.confirm("重置密码确认","确认重置用户："+name+"的密码？：",function(r){  
		    if (r){   
			$.ajax({
				url : "jsonResetUserPwd.do?id="+id,
				type : "post",  
		    	dataType : "json",								
				success : function(data) { 									
		  			if(data.code == 0){ 
		  				$.messager.alert('操作信息',data.message,'info',function(){ 
		  					search();  
		      			});
		  			}else{		  			    
						$.messager.alert('错误信息','重置密码失败！','error');
		  			}  
			    } 
			});
	    }  
	}); 
}

 */

</script>
</head>
<body>
	<div class="con-right" id="conRight">	
		<div class="fl yw-lump">
			<div class="yw-lump-title">
				<i class="yw-icon icon-partner"></i><span>资源列表</span> 
			</div>
		</div>
		<div class="fl yw-lump mt10">
			<form id="taskForm" name="taskForm"
				action="resourceList.do" method="get">
				<div class=pd10>
					<div class="fl">  
						<span>条件查询：</span>
						<input type="text" id="seaarchNameTemp" validType="SpecialWord" class="easyui-validatebox" placeholder="搜索关键字：名称，地址" value="${ResourceConfig.searchName}" /> 
						<input type="hidden" name="searchName" id="hid_serarch" /> 
						
						<span class="yw-btn bg-blue ml30 cur" onclick="search();">搜索</span>						
					</div>
					<div class="fr">
					<span class="yw-btn bg-green cur" onclick="window.location.href='resourceInfo.do?id=0';">新增资源</span> 
					</div>
						<div class="cl"></div>				
                     <input type="hidden" id="pageNumber" name="pageNo" value="${ResourceConfig.pageNo}" />
                     </div>
		     	</form>
		     	</div>
				
           <div class="fl yw-lump"> 
				<table class="yw-cm-table yw-center yw-bg-hover" id="taskList">
					<tr style="background-color:#D6D3D3;font-weight: bold;">
						<th width="4%" style="display:none">&nbsp;</th>						
						<th width="10%">资源名称</th>	
						<th width="20%" align="left">资源地址</th>
						<th width="8%">所属模块</th>
						<th width="15%">操作</th>			
					
					</tr>
					<c:forEach var="item" items="${resourceList}">
						<tr>
						<td>${item.name}</td>
						<td align="left">${item.resource}</td>
						<td>${item.functionName}</td>
						<td>
							<a style="color:blue" onclick="deleteResource(${item.id},'${item.name}');">删除</a>							
							<a style="color:blue" onclick="window.location.href='resourceInfo.do?id=${item.id}';">编辑</a>							
						</td>
						</tr>
					</c:forEach>
					
				</table>
				<div class="page" id="pager"></div>
				</div>
			</div>
  </body>
</html>

