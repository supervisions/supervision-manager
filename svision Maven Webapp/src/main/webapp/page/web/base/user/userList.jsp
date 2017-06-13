<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<html>
<head>
<meta charset="utf-8"> 
<title>组织机构管理</title> 
<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1  ,maximum-scale=1, user-scalable=no" />
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/source/js/easyUI/themes/default/easyui.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/source/js/easyUI/themes/icon.css"> 
	<script type="text/javascript" src="${pageContext.request.contextPath}/source/js/easyUI/jquery.easyui.min.js"></script>
	<script src="${pageContext.request.contextPath}/source/js/easyUI/easyui-lang-zh_CN.js"></script>
	<script src="${pageContext.request.contextPath}/source/js/common/validate.js"></script>
	<script src="${pageContext.request.contextPath}/source/js/common/common.js"></script>
	<script src="${pageContext.request.contextPath}/source/js/pager/jquery.pager.js"></script>
	<link href="${pageContext.request.contextPath}/source/js/pager/Pager.css" rel="stylesheet" />
	<link rel="shortcut icon" href="<%=basePath%>source/images/favicon.ico" type="image/x-icon" />
<script type="text/javascript">
$(document).ready(function(){
	//截取机构长度
	subOrgname();
	
	//加载机构树
 	$("#treeList").tree({	 		
	 	 url: '<%=basePath%>system/organ/jsonLoadOrganTreeList.do?', 			 	 
	 	 onClick:function(node){//单击事件		 	 	
	 		orgId = node.id;
	 		//机构ID查询用户
	 		getUserListByOrgId(orgId);
 		},
 		onBeforeExpand:function(node){   				 
			$('#treeList').tree('options').url = '<%=basePath%>system/organ/jsonLoadOrganTreeList.do?pid='+ node.id;
		},
		onLoadSuccess:function(){		 	
		    var cyId = $.trim($("#hid_companyId").val());
		 	if(cyId.length>0){
		 		var node = $("#treeList").tree("find",cyId); 
				$('#treeList').tree("select", node.target);		 		
		 	} 
		 }	
	});
	
	$("#pager").pager({
	    pagenumber:'${User.pageNo}',                         /* 表示初始页数 */
	    pagecount:'${User.pageCount}',                      /* 表示总页数 */
	    totalCount:'${User.totalCount}',				   /* 表示总记录数 */
	    buttonClickCallback:PageClick                     /* 表示点击分页数按钮调用的方法 */                  
	});		
	$("#seaarchNameTemp").keypress(function(e){
		if(e.keyCode == 13){
			search();
		}
	});				
	/* $("#userList").addClass("yw-cm-table"); */
	$("#userList").addClass("yw-leftSide");
	/* $("#userList").addClass("yw-bg-hover"); */
}); 
//截取机构长度
function subOrgname(){
	//当机构的长度超过15的时候用....表示
	var trLength=$(".orgName").length;
	var valueLength=0;	
	var orgNames="";	
	for(var i=0; i<trLength; i++){
		valueLength=$(".orgName").eq(i).html().length;
		if(valueLength>15){			
			orgNames=$(".orgName").eq(i).html().substr(0,15);
			$(".orgName").eq(i).html(orgNames+"......");
		}
	}
}
		 
PageClick = function(pageclickednumber) {
	$("#pager").pager({
	    pagenumber:pageclickednumber,                 /* 表示启示页 */
	    pagecount:'${User.pageCount}',                  /* 表示最大页数pagecount */
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
	if ($('#userForm').form('validate')) {
		userForm.submit();
	}
}
//删除用户
function deleteUser(id,name){
	$.messager.confirm("删除确认","确认删除用户："+name+"?",function(r){  
		    if (r){   
			$.ajax({
				url : "jsondeleteUserById.do?id="+id,
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
//修改用户状态
function updateUser(id,used,name){
	var operation=null;
	if(used==0){
		operation="确认禁用用户："+name+"  ?";		
	}else if(used==1){
		operation="确认启用用户："+name+"  ?";	
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
//重置用户密码
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
//根据机构ID查询用户
function getUserListByOrgId(orgId){
	  $.ajax({
		url : "jsonLoadUserListByOrgId.do?orgId="+orgId,
		type : "post",  
		dataType:"json",
		success : function(data) { 
  			if(data.code == 0){ 
  				 $("#pageNumber").val(1); 
  				 $("#pager").pager({
				    pagenumber:data.obj.pageNo,                         /* 表示初始页数 */
				    pagecount:data.obj.pageCount,                      /* 表示总页数 */
				    totalCount:data.obj.totalCount,
				    buttonClickCallback:PageClick                     /* 表示点击分页数按钮调用的方法 */                  
				});
				$("#metaList").html("");
				fillMetaList(data.list);
				var usedTdLength=$(".usedTds").length;
				var usedValue="";
				var stateBtn="";
				for(var i=0; i<usedTdLength; i++){
					usedValue=$(".usedTds").eq(i).html();
					stateBtn=$(".stateBut").eq(i).html();
					if(usedValue==0){			
						$(".usedTds").eq(i).html("禁用");
						$(".stateBut").eq(i).html("启用");
					}else if(usedValue==1){
						$(".usedTds").eq(i).html("启用");
						$(".stateBut").eq(i).html("禁用");
					}
				}
				//截取机构长度
				subOrgname();
  			}else{
				$.messager.alert('错误信息',data.message,'error');
  			} 
		}
	});
};
function fillMetaList(lst){
	var html = "<tbody>";
	html += "<tr style='background-color:#D6D3D3;font-weight: bold;'><th width='4%' style='display:none'>&nbsp;</th><th width='15%'><span style='margin-left:40px'>状态</span></th><th width='15%'>用户名称</th><th width='15%'>用户账号</th><th width='25%'>所属机构</th><th width='15%'>操作一</th><th width='10%'>操作二</th></tr>";
	for(var i = 0; i<lst.length;i++){
		html += "<tr>";
		html += "<td  style='display:none'>"+lst[i].id+"</td><td align='left' ><span class='usedTds' style='margin-left:40px'>"+lst[i].used+"</span></td><td align='left' >"+lst[i].name+"</td><td align='left'>"+lst[i].account+"</td>";
		html += "<td align='left' class='orgName' title=\'"+lst[i].orgName+"\'>"+lst[i].orgName+"</td>";
		html += "<td align='left'>"+"<a href='javascript:void(0);' class='stateBut' onclick=updateUser(\'"+lst[i].id+"\',\'"+lst[i].used+"\',\'"+lst[i].name+"\')  style='margin-top:25px;color:blue' >启用</a>&nbsp;<a href='javascript:void(0);' onclick=goToUserInfo(\'"+lst[i].id+"\')  style='margin-top:25px;color:blue' >编辑</a>&nbsp;<a href='javascript:void(0);' onclick=resetUserPwd(\'"+lst[i].id+"\',\'"+lst[i].name+"\')  style='margin-top:25px;color:blue' >重置密码</a></td>";
		html += "<td align='left'>"+"<a href='javascript:void(0);' onclick=deleteUser(\'"+lst[i].id+"\',\'"+lst[i].name+"\')  style='margin-top:25px;color:blue' >删除</a></td>";
		html += "</tr>";
	}
	html += "</tbody>";
	$("#userList").html(html);
}

function goToUserInfo(id){
	window.location.href="userInfo.do?id="+id;
}
</script>
</head>

<body>

	<div class="con-right" id="conRight">
		<div class="fl yw-lump">
			<div class="yw-lump-title">
				<i class="yw-icon icon-partner"></i><span>用户列表</span><input type="hidden" value="${User.id}" id="hid_organId" />
			</div>
		</div>
		<div class="fl yw-lump mt10">
			<form id="userForm" name="userForm"
				action="userList.do" method="get">
				<div class="pd10-28">
					<div class="fl">
						 <button class="yw-btn bg-blue cur">全部用户</button>  
					</div>
					<div class="fr">
						<input type="text" name="searchName"   validType="SpecialWord" class="easyui-validatebox"
							   style="width: 180px;" placeholder="搜索关键字：名称、账号" value="${User.searchName}" />
						<span class="yw-btn bg-orange ml30 cur" onclick="search();">搜索</span>
						<span class="yw-btn bg-green ml20 cur" onclick="window.location.href='userInfo.do?id=0';">新建</span>
					</div>
					<div class="cl"></div>
				</div>

				<input type="hidden" id="pageNumber" name="pageNo"
					value="" />
			</form>
		</div>
		<div class="fl">
			<div class="fl yw-lump mlwid250 mt10">
				<div class="yw-cm-title">
					<span class="ml26">全部机构</span>
				</div> 
				<div class="yw-organ-tree-list" style="height: 639px;">
					<!-- 加载机构树 -->
					<ul id="treeList"></ul> 
				</div>
			</div>
			<div class="yw-lump wid-atuo ml260s mt10">
				<div class="yw-cm-title"> 
					<span class="ml26">用户列表</span>
				</div> 
				<table id="userList" cellspacing="0" cellpadding="0">
					<tr style="background-color:#D6D3D3;font-weight: bold;height:30px;line-height:30px;">   
						<th width="15%">用户名称</th>
						<th width="15%">用户账号</th>
						<th width="25%">所属机构</th>								
						<th width="15%">操作一</th>	
						<th width="10%">操作二</th>	
					</tr>
					<c:forEach var="item" items="${userList}">
						<tr> 
							<%-- <td><c:if test="${item.used == 1}">
								<span style='margin-left:40px'>启用</span>
							</c:if> <c:if test="${item.used == 0}">
								<span style='margin-left:40px'>禁用</span>
							</c:if></td> --%>
							<td>${item.name}</td>
							<td>${item.account}</td>
							<td title="${item.orgName}" class="orgName">${item.orgName}</td>
							
							<td>
								<span class="yw-btn-small bg-red cur" onclick="resetUserPwd(${item.id},'${item.name}');">重置密码</span>	
								<span class="yw-btn-small bg-lan cur" onclick="window.location.href='userInfo.do?id=${item.id}';">编辑</span>	
							</td>
							<td>
								<%-- <a style="color:blue" onclick="deleteUser(${item.id},'${item.name}');">删除</a>		 --%>
								<span class="yw-btn-small bg-red cur" onclick="deleteUser(${item.id},'${item.name}');">删除</span>					
							</td>
						</tr>
					</c:forEach>
				</table>
				<div class="page" id="pager"></div>
			</div>
		</div>
	</div>
</body>
</html> 
