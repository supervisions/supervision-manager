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
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/source/js/easyUI/themes/default/easyui.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/source/js/easyUI/themes/icon.css"> 
	<script type="text/javascript" src="${pageContext.request.contextPath}/source/js/easyUI/jquery.easyui.min.js"></script>
	<script src="${pageContext.request.contextPath}/source/js/easyUI/easyui-lang-zh_CN.js"></script>
	<script src="${pageContext.request.contextPath}/source/js/common/validate.js"></script>
	<script src="${pageContext.request.contextPath}/source/js/common/common.js"></script>
<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1  ,maximum-scale=1, user-scalable=no" />
	<script src="${pageContext.request.contextPath}/source/js/pager/jquery.pager.js"></script>
	<link href="${pageContext.request.contextPath}/source/js/pager/Pager.css" rel="stylesheet" />
	<link rel="shortcut icon" href="<%=basePath%>source/images/favicon.ico" type="image/x-icon" />
<script type="text/javascript">
	$(document).ready(function(){
			$("#pager").pager({
			    pagenumber:'${Item.pageNo}',                         /* 表示初始页数 */
			    pagecount:'${Item.pageCount}',                      /* 表示总页数 */
			    totalCount:'${Item.totalCount}',
			    buttonClickCallback:PageClick                     /* 表示点击分页数按钮调用的方法 */                  
			});    
			$("#fz").attr("onclick","window.location.href='<%=basePath%>manage/branch/branchZZList.do'"); 
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
				url : "<%=basePath%>manage/branch/jsondeleteItemById.do?id="+id,
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
</script>
</head>

<body>

	<div class="con-right" id="conRight">
		<div class="fl yw-lump">
			<div class="yw-lump-title"> 
				<i class="yw-icon icon-partner"></i><span>项目列表</span><input type="hidden" value="${Organ.id}" id="hid_organId" />
			</div>
		</div>
		<div class="fl yw-lump mt10">
			<form id="organForm" name="organForm"
				action="organList.do" method="get">
				<div class="pd10-28">
					<div class="fl">
						 <button class="yw-btn bg-blue cur">项目列表</button>  
					</div>
					<div class="fr">
						<input type="text" name="searchName"   validType="SpecialWord" class="easyui-validatebox"
							   style="width: 120px;" placeholder="搜索关键字：名称" value="${Organ.searchName}" /> 
						<span class="yw-btn bg-orange ml30 cur" onclick="search();">搜索</span>
						<span class="yw-btn bg-green ml20 cur" onclick="window.location.href='<%=basePath %>manage/branch/branchFHInfo.do'">新建项目</span>
					</div>
					<div class="cl"></div>
				</div>

				<input type="hidden" id="pageNumber" name="pageNo"
					value="" />
			</form>
		</div>
		<div class="fl">
			<div class="fl yw-lump mlwid10per mt10">
				<div class="yw-cm-title">
					<span class="ml26">项目属性</span>
				</div> 
				<div class="yw-organ-tree-list" style="height: 639px;">
					<!-- 加载机构树 -->
					<div id="ff" class="branchPart-active">
						<span>分行完成</span>
					</div> 
					<div id="fz"  class="branchPart" >
						<span>中支完成</span>
					</div>
				</div>
			</div>
			<div class="yw-lump wid-atuo ml10ps mt10">
				<div class="yw-cm-title">
					<span class="ml26">项目列表</span>
				</div>
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
							<td><a style="color: blue;" >${item.name}</a></td>
							<td>${item.sType}</td>
							<td>${item.showDate}</td> 
							<td>${item.preparerOrg}</td>
							<td>${item.orgName}</td>
							<td>
								<c:if test="${logUserOrg == item.preparerOrgId}">
									<a style="color: blue;" onclick="deleteItem(${item.id},'${item.name}')">删除</a>
								</c:if>							
								
								<%-- <c:if test="${logUserOrg != item.supervisionOrgId}"> 
									<c:if test="${Type == 2 }">
										<c:if test="item.status == 4">
											 【已完结】 
										</c:if>
										<c:if test="item.status != 4"> --%>
											<a style="color: blue;"  >上传资料</a>
										<%-- </c:if>
									</c:if>									
								</c:if>	 --%>
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
