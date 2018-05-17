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
		var pid=0;
		$(document).ready(function(){
			//showProcess(true, '温馨提示', '正在加载数据...');
			$("#pager").pager({
			    pagenumber:'${Organ.pageNo}',                         /* 表示初始页数 */
			    pagecount:'${Organ.pageCount}',                      /* 表示总页数 */
			    totalCount:'${Organ.totalCount}',
			    buttonClickCallback:PageClick                     /* 表示点击分页数按钮调用的方法 */                  
			});
		
		//加载机构树
	 	$("#treeList").tree({	 		
			 	 url: 'jsonLoadOrganTreeList.do?', 			 	 
			 	 onClick:function(node){//单击事件			 	 			 		
				 	pid= node.id; 
				 	//根据pid查询子级机构
				 	getOrganListByPid(pid);
   				 },
   				 onBeforeExpand:function(node){   				 
   				 	$('#treeList').tree('options').url = '<%=basePath %>system/organ/jsonLoadOrganTreeList.do?pid='+ node.id;
   				 },
   				 onLoadSuccess:function(){
   				 	//$("#treeList").combotree('state', 'open');
					//showProcess(false);
   				    var cyId = $.trim($("#hid_companyId").val());
   				 	if(cyId.length>0){
   				 		var node = $("#treeList").tree("find",cyId); 
						$('#treeList').tree("select", node.target);
   				 		
   				 	} 
   				 }	
				});	
				 
		});
function getOrganListByPid(pid){
	  $.ajax({
		url : "<%=basePath %>system/organ/jsonLoadOrganListByPid.do?pid="+pid,
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
				$("#organList").html("");
				fillOrganList(data.list);
				var usedTdLength=$(".usedTds").length;
				var usedValue="";
				var supervisionState="";
				var stateBtn="";
				for(var i=0; i<usedTdLength; i++){
					usedValue=$(".usedTds").eq(i).html();
					stateBtn=$(".stateBut").eq(i).html();
					supervisionState=$(".supervisionState").eq(i).html();
					if(usedValue==0){			
						$(".usedTds").eq(i).html("禁用");
						$(".stateBut").eq(i).html("启用");
					}else if(usedValue==1){
						$(".usedTds").eq(i).html("启用");
						$(".stateBut").eq(i).html("禁用");
					}
					if(supervisionState==1){
						$(".supervisionState").eq(i).html("是");
					}else if(supervisionState==0){
						$(".supervisionState").eq(i).html("否");
					}
				}
  			}else{
				$.messager.alert('错误信息',data.message,'error');
  			} 
		}
	});
};

function deleteOrgan(id,name){
	$.messager.confirm("删除确认","确认删除机构："+name+"?",function(r){  
		    if (r){   
			$.ajax({
				url : "<%=basePath %>system/organ/jsondeleteOrganById.do?id="+id,
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
function fillOrganList(lst){
	var html = "<tbody>";
	html += "<tr style='background-color:#D6D3D3;font-weight: bold;'><th width='4%' style='display:none'>&nbsp;</th><th><span style='margin-left:40px'>机构状态</span></th><th>机构名称</th><th>上级机构</th><th>是否监察部门</th><th>操作一</th><th>操作二</th></tr>";
	for(var i = 0; i<lst.length;i++){
		html += "<tr>";
		html += "<td  style='display:none'>"+lst[i].id+"</td><td align='left' ><span class='usedTds' style='margin-left:40px'>"+lst[i].used+"</span></td><td align='left' ><span>"+lst[i].name+"</span></td><td align='left' >"+lst[i].parentName+"</td>";
		html += "<td class='supervisionState'>"+lst[i].supervision+"</td>";
		html +="<td align='left'>"+"<span class='yw-btn-small bg-lan cur' onclick='goToOrganInfo("+lst[i].id+")'>编辑</span></td>";
		html +="<td align='left'>"+"<span class='yw-btn-small bg-red cur' onclick=deleteOrgan("+lst[i].id+",'"+lst[i].name+"')>删除</span></td>";
		html += "</tr>";
	}
	html += "</tbody>";
	$("#organList").html(html);
}
PageClick = function(pageclickednumber) {
	$("#pager").pager({
	    pagenumber:pageclickednumber,                 /* 表示启示页 */
	    pagecount:'${Organ.pageCount}',                  /* 表示最大页数pagecount */
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
	if ($('#organForm').form('validate')) {
		organForm.submit();
	} 
}

function goToOrganInfo(organId){
	window.location.href="<%=basePath %>system/organ/organInfo.do?id="+organId;
}
</script>
</head>

<body>

	<div class="con-right" id="conRight">
		<div class="fl yw-lump">
			<div class="yw-lump-title">
				<i class="yw-icon icon-partner"></i><span>组织机构列表</span><input type="hidden" value="${Organ.id}" id="hid_organId" />
			</div>
		</div>
		<div class="fl yw-lump mt10">
			<form id="organForm" name="organForm"
				action="organList.do" method="get">
				<div class="pd10-28">
					<div class="fl">
						 <button class="yw-btn bg-blue cur">全部机构</button>  
					</div>
					<div class="fr">
						<input type="text" name="searchName"   validType="SpecialWord" class="easyui-validatebox"
							   style="width: 120px;" placeholder="搜索关键字：名称" value="${Organ.searchName}" />
						<span class="yw-btn bg-orange ml30 cur" onclick="search();">搜索</span>
						<span class="yw-btn bg-green ml20 cur" onclick="window.location.href='<%=basePath %>system/organ/organInfo.do?id=0'">新建</span>
					</div>
					<div class="cl"></div>
				</div>

				<input type="hidden" id="pageNumber" name="pageNo"
					value="" />
			</form>
		</div>
		<div class="fl" style="width:100%">
			<div class="fl yw-lump mlwid250 mt10">
				<div class="yw-cm-title">
					<span class="ml26">机构列表</span>
				</div>
				<div class="yw-organ-tree-list" style="height: 639px;">
					<!-- 加载机构树 -->
					<ul id="treeList"></ul>
				</div>
			</div>
			<div class="yw-lump wid-atuo ml260s mt10">
				<div class="yw-cm-title"> 
					<span class="ml26">全部机构</span>
				</div> 
				<div class="yw-cm-sub-table">
				<div style="max-height: 600px;overflow-x: hidden;">
				<table class="yw-cm-table yw-center yw-bg-hover" id="organList">
					<tr style="background-color:#D6D3D3;font-weight: bold;">
						<th width="4%" style="display:none">&nbsp;</th>						
						<th><span style='margin-left:40px'>机构状态</span></th>
						<th>机构名称</th>
						<th>上级机构</th>
						<th>是否监察部门</th>
						<th>操作一</th>
						<th>操作二</th> 
					</tr>
					<c:forEach var="item" items="${organList }">
						<tr>
							<td style="display:none">${item.id }</td>
							<td  align="left" onclick="goToOrganInfo('')">
								<c:if test="${item.used == 1}">
									<span style='margin-left:40px'>启用</span>
								</c:if> <c:if test="${item.used == 0}">
									<span style='margin-left:40px'>禁用</span>
								</c:if>				
							</td>
							<td  align="left" onclick="goToOrganInfo('')">${item.name }</td>
							<td  align="left" onclick="goToOrganInfo('')">${item.parentName }　</td>
							<td  align="left" onclick="goToOrganInfo('')">
								<c:if test="${item.supervision == 1}">
									<span>是</span>
								</c:if> <c:if test="${item.supervision == 0}">
									<span>否</span>
								</c:if>
							</td>
							<td align="left">								
								<%-- <a style="color:blue" onclick="goToOrganInfo(${item.id })">编辑</a> --%>
								<span class="yw-btn-small bg-lan cur" onclick="goToOrganInfo(${item.id })">编辑</span>
							</td>
							<td>
								<%-- <a style="color:blue" onclick="deleteOrgan(${item.id },'${item.name }')">删除</a> --%>
								<span class="yw-btn-small bg-red cur" onclick="deleteOrgan(${item.id },'${item.name }')">删除</span>
							</td>
						</tr>
					</c:forEach>
				</table>
				</div>
				</div> 
			</div>
		</div>
	</div>
</body>
</html>
