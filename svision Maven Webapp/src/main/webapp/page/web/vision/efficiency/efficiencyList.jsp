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
<title>效能监察</title>
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
	    pagenumber:'${Item.pageNo}',                         /* 表示初始页数 */
	    pagecount:'${Item.pageCount}',                      /* 表示总页数 */
	    totalCount:'${Item.totalCount}',				   /* 表示总记录数 */
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
	    pagecount:'${Item.pageCount}',                  /* 表示最大页数pagecount */
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
function deleteItem(id,name){
	$.messager.confirm("删除确认","确认删除项目："+name+"?",function(r){  
		    if (r){   
			$.ajax({
				url : "jsondeleteItemById.do?id="+id,
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
function setProject(id){
	$.messager.confirm("立项确认","是否确认立项?",function(r){  
		    if (r){   
			$.ajax({
				url : "jsonsetProjectById.do?id="+id,
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
function sign(itemId){
	$.messager.confirm("签收确认","是否确认签收?",function(r){  
		    if (r){   
			$.ajax({
				url : "jsonSignItemById.do?itemId="+itemId,
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
function uploadFile(id,tag){
	window.location.href="<%=basePath%>vision/efficiency/efficiencyFile.do?id="+id+"&tag="+tag;
	<%-- if(isStept==0){
		window.location.href="<%=basePath%>vision/efficiency/efficiencyNoFile.do?id="+id;
	}else{
		window.location.href="";
	} --%>
}
function toOpinion(id,tag){
	window.location.href="<%=basePath%>vision/efficiency/toOpinion.do?id="+id+"&tag="+tag;
}
function showItem(id){
	window.location.href="<%=basePath%>vision/efficiency/showItem.do?id="+id;
}
function resetItem(id,lasgTag){
	window.location.href="<%=basePath%>vision/efficiency/resetItem.do?id="+id+"&lasgTag="+lasgTag;
}
function followItem(id,name){
	$.messager.confirm("问责确认","确认问责项目："+name+"?",function(r){  
		    if (r){   
				followAction(id,0); //问责
	    	}else{
	    		$.messager.confirm("问责确认","确认不问责项目："+name+"，即完成当前项目的监察?",function(r){  
		    		if (r){   
			    		followAction(id,1); //不问责
		    		}
				}); 
		    		
	    	}
	}); 
}
function followAction(itemId,status){
	$.ajax({
		url : "<%=basePath%>vision/efficiency/jsonfollowItemById.do",
		type : "post",  
    	dataType : "json",		
    	data:{"id":itemId,"isFollow":status},						
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
				action="efficiencyList.do" method="get">
				<div class=pd10>
					<div class="fl">  
						<span>条件查询：</span>
						<input type="text" id="seaarchNameTemp" validType="SpecialWord" class="easyui-validatebox" placeholder="搜索" value="${Role.searchName}" /> 
						<input type="hidden" name="searchName" id="hid_serarch" />						
						<span class="yw-btn bg-blue ml30 cur" onclick="search();">搜索</span>						
					</div>
					<div class="fr">
						<%-- <c:if test="${userOrg.supervision ==1 }">
							<span class="yw-btn bg-green cur" onclick="window.location.href='efficiencyInfo.do?id=0';">添加工作事项</span>							
						</c:if> --%>
						<span class="yw-btn bg-green cur" onclick="window.location.href='efficiencyInfo.do?id=0';">添加工作事项</span>
						
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
					<th width="6%">立项情况</th>
					<th width="4%">状态</th>	
					<th width="20%">工作事项</th>	
					<th width="4%">查看</th>	
					<th width="15%">被监察对象</th>	
					<th width="6%">签收情况</th>	
					<th width="8%">部门完成情况</th>	
					<th width="5%">是否完结</th>	
					<th width="10%">规定办理时间</th>	
					<th width="6%">状态提醒</th>
					<th>操作</th>			
				</tr>
				<c:forEach var="item" items="${itemList}">
					<tr> 							
						<td>
							<c:if test="${item.status == 0 }">
								<span style="color: red;" onclick="setProject(${item.id })">未立项</span>
							</c:if>
							<c:if test="${item.status != 0 }">
									<span>已立项</span>	
							</c:if>
						</td>
						<td  style="color:green;">
							<c:if test="${item.status == 0 }">
								<span>新</span>
							</c:if>
							<c:if test="${item.status == 1 }">
								<span>正常</span>
							</c:if>
							<c:if test="${item.status == 2 }">
								<span>退回</span>
							</c:if>
							<c:if test="${item.status == 3 }">
								<span>逾期</span>
							</c:if>
							<c:if test="${item.status == 4 }">
								<span>完结</span>
							</c:if>
						</td>
						<td>${item.name}</td>
						<td><a style="color:blue;" onclick="showItem(${item.id })">查看</a></td>
						<td>${item.orgName}</td>
						<td>
							<c:if test="${item.isSign <= 1}">							
								<span>未签收</span>
							</c:if>
							<c:if test="${item.isSign > 1}">
								<span style="color:green;">已签收</span>
							</c:if>
						</td>
						<td>
							<c:if test="${item.status == 4 }">
								<span>完成</span>
							</c:if>
							<c:if test="${item.status != 4 }">
								<span>未完成</span>
							</c:if>
						</td>
						<td>
							<c:if test="${item.status == 4 }">
								<span>完结</span>
							</c:if>
							<c:if test="${item.status != 4 }">
								<span>未完结</span>
							</c:if>
						</td>
						<td>${item.showDate}</td>
						<td>
							<c:if test="${item.status == 3 }">
								<span>逾期</span>
							</c:if>
							<c:if test="${item.status != 3 && item.status !=4 }">
								<span>正常</span>
							</c:if>
							<c:if test="${item.status ==4  }">
								<span>完结</span>
							</c:if>
						</td>
						<td><%-- <sapn>${item.lasgTag}</sapn> --%>
							<c:if test="${item.status == 0 and userOrg.id==item.preparerOrgId}">
								<span style="color: red;" onclick="setProject(${item.id })">立项</span>
							</c:if>
							<c:if test="${userOrg.id == item.supervisionOrgId and item.status != 0 and item.isSign <= 1}">
								<a style="color: blue;" onclick="sign(${item.id })">签收</a>
							</c:if>
							<c:if test="${userOrg.id == item.supervisionOrgId && item.isSign >1 && item.lasgTag == 66}">
								<a style="color: blue;" onclick="uploadFile(${item.id},67)">上传资料</a>
							</c:if>
							<c:if test="${item.lasgTag == 67 && userOrg.id==item.preparerOrgId}">
								<a style="color: blue;" onclick="uploadFile(${item.id},68)">监察意见</a>
							</c:if>						
							<c:if test="${item.lasgTag == 69 && userOrg.id == item.supervisionOrgId }">
								<a style="color: blue;" onclick="uploadFile(${item.id},69)">整改操作</a>
							</c:if>
							<c:if test="${item.lasgTag == 666 && userOrg.id==item.preparerOrgId}">
								<a style="color: blue;" onclick="followItem(${item.id},'${item.name}')">问责处理</a>
							</c:if>
							<c:if test="${item.lasgTag == 777 && userOrg.id==item.preparerOrgId}">
								<a style="color: blue;" onclick="uploadFile(${item.id},777)">录入问责资料</a>
							</c:if>
							<c:if test="${item.lasgTag == 778 && userOrg.id==item.supervisionOrgId}">
								<a style="color: blue;" onclick="uploadFile(${item.id},778)">整改操作</a>
							</c:if>
							<%-- <c:if test="${userOrg.id == item.supervisionOrgId and item.status !=0}">
								<a style="color: blue;" onclick="deleteItem(${item.id},'${item.name}')">删除</a>
							</c:if>	 --%>
							<c:if test="${userOrg.id == item.preparerOrgId}">
								<a style="color: blue;" onclick="deleteItem(${item.id},'${item.name}')">删除</a>
							</c:if>					
						</td>
					</tr>
				</c:forEach>
			</table>
			<div class="page" id="pager"></div>
			</div>
		</div>

 		

  </body>
</html>












