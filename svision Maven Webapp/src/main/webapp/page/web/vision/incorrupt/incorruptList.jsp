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
function showItem(id){
	window.location.href="<%=basePath%>vision/incorrupt/showItem.do?id="+id;
}
function toSaveScheme(id){
	window.location.href="<%=basePath%>vision/incorrupt/toSaveScheme.do?id="+id;
}
function toOpinion(id,lasgTag){
	window.location.href="<%=basePath%>vision/incorrupt/toOpinion.do?id="+id+"&lasgTag="+lasgTag;
}
function toSaveDecision(id){
	window.location.href="<%=basePath%>vision/incorrupt/toSaveDecision.do?id="+id;
}
function toExecution(id){
	window.location.href="<%=basePath%>vision/incorrupt/toExecution.do?id="+id;
}
function toJCExecution(id){
	window.location.href="<%=basePath%>vision/incorrupt/toJCExecution.do?id="+id;
}

function uploadFile(id,tag){
	window.location.href="<%=basePath%>vision/incorrupt/incorruptFile.do?id="+id+"&tag="+tag;
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
				action="incorruptList.do" method="get">
				<div class=pd10>
					<div class="fl">  
						<span>条件查询：</span>
						<input type="text" id="seaarchNameTemp" validType="SpecialWord" class="easyui-validatebox" placeholder="搜索" value="${Item.searchName}" /> 
						<input type="hidden" name="searchName" id="hid_serarch" /> 
						
						<span class="yw-btn bg-blue ml30 cur" onclick="search();">搜索</span>						
					</div>
					
					<div class="fr">
						<c:if test="${userOrg.orgtype ==48 || userOrg.orgtype ==49}">
							<span class="yw-btn bg-green cur" onclick="window.location.href='itemInfo.do';">添加工作事项</span>							
						</c:if>
						
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
					<th width="8%">立项情况</th>
					<th width="5%">状态</th>	
					<th>工作事项</th>
					<th width="5%">查看</th>	
					<th width="12%">项目类别</th>	
					<th width="30%">项目名称</th>	
					<th>被监察对象</th>
					<th>操作一</th>	
					<th>操作二</th>			
				</tr>
				<c:forEach var="item" items="${itemList}">
					<tr> 							
						<td>
							<%-- <c:if test="${item.status == 0 && userOrg.id==item.preparerOrgId}">
								<span style="color: red;" onclick="setProject(${item.id })">未立项</span>
							</c:if> --%>
							<c:if test="${item.status == 0}">
								<span style="color: red;" >未立项</span>
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
						<td>${item.itemCategory}</td>
						<td>${item.itemNmae}</td>
						<td>${item.orgName}</td>
						<td>	<span>${item.lasgTag}</span>			
							    
								<c:if test="${userOrg.orgtype==47 && item.status == 0 }">
									<span style="color: red;" onclick="window.location.href='incorruptInfo.do?id=${item.id }';">立项</span>
								</c:if>
								<c:if test="${item.status != 0 && userOrg.id==item.supervisionOrgId && item.lasgTag==-1}">
									<span style="color: blue;" onclick="uploadFile(${item.id},72)">项目方案</span>
								</c:if>
								<c:if test="${item.lasgTag == 0 && userOrg.id==item.supervisionOrgId}">
									<span style="color: blue;" onclick="uploadFile(${item.id},72)">项目方案</span><!-- 不合规，重新进行录入方案 -->
								</c:if>
								<c:if test="${item.lasgTag == 73 && userOrg.id==item.supervisionOrgId}">
									<span style="color: blue;" onclick="uploadFile(${item.id },73)">录入会议决策</span>
								</c:if>
								<c:if test="${item.lasgTag == 85 && userOrg.id==item.supervisionOrgId}">
									<span style="color: blue;" onclick="uploadFile(${item.id },73)">录入会议决策</span><!-- 党委采纳意见，重新决策 -->
								</c:if>
								<c:if test="${item.lasgTag == 77 && userOrg.id==item.supervisionOrgId}">
									<span style="color: blue;" onclick="uploadFile(${item.id },77)">提请党委审议</span>
								</c:if>
								<c:if test="${item.lasgTag == 75 && userOrg.id==item.supervisionOrgId}">
									<a style="color: blue;" onclick="uploadFile(${item.id}, 75)">执行情况</a><!-- 正常流程的录入执行情况 -->
								</c:if>
								<c:if test="${item.lasgTag == 779 && userOrg.id==item.supervisionOrgId}">
									<a style="color: blue;" onclick="uploadFile(${item.id}, 75)">执行情况</a><!-- 不合规不问责回到录入执行情况 -->
								</c:if>
								<c:if test="${item.lasgTag == 666 && userOrg.id==item.supervisionOrgId}">
									<a style="color: blue;" onclick="uploadFile(${item.id}, 75)">执行情况</a><!-- 不合规问责回到录入执行情况 -->
								</c:if>
								<c:if test="${item.lasgTag == 778 &&  userOrg.orgtype==47}">
									<a style="color: blue;" onclick="uploadFile(${item.id}, 778)">录入问责资料</a>
								</c:if> 
								
								<c:if test="${item.lasgTag == 72 &&  userOrg.orgtype==47}">
									<span style="color: blue;" onclick="uploadFile(${item.id },74)">监察意见</span>
								</c:if>
								<c:if test="${item.lasgTag == 777  &&  userOrg.orgtype==47}">
									<span style="color: blue;" onclick="uploadFile(${item.id },777)">监察意见</span>
								</c:if>
								<c:if test="${item.lasgTag == 76  &&  userOrg.orgtype==47}">
									<a style="color: blue;" onclick="uploadFile(${item.id}, 76)">监察执行情况</a>
								</c:if>
							
								<c:if test="${item.lasgTag == 78  &&  userOrg.orgtype==47}">
									<a style="color: blue;" onclick="uploadFile(${item.id}, 78)">监察结论</a>
								</c:if>
								<c:if test="${item.lasgTag == 86  &&  userOrg.orgtype==47}">
									<a style="color: blue;" onclick="uploadFile(${item.id}, 86)">监察结论</a><!-- 党委维持原决议，给出监察结论 -->
								</c:if>						
							
							<%-- <c:if test="${item.lasgTag == 777 && userOrg.id==item.preparerOrgId}">
								<span style="color: blue;" onclick="toOpinion(${item.id },777)">监察意见</span>
							</c:if> --%>
						</td>
						<td>
							<c:if test="${ userOrg.orgtype==47}">
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












