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
	<script src="${pageContext.request.contextPath}/source/js/pager/jquery.pager.js"></script>
	<link href="${pageContext.request.contextPath}/source/js/pager/Pager.css" rel="stylesheet" />
	<link rel="shortcut icon" href="<%=basePath%>source/images/favicon.ico" type="image/x-icon" />
<script type="text/javascript">
		$(document).ready(function(){
			//showProcess(true, '温馨提示', '正在加载数据...');
			$("#pager").pager({
			    pagenumber:'${Config.pageNo}',                         /* 表示初始页数 */
			    pagecount:'${Config.pageCount}',                      /* 表示总页数 */
			    totalCount:'${Config.totalCount}',				   /* 表示总记录数 */
			    buttonClickCallback:PageClick                     /* 表示点击分页数按钮调用的方法 */                  
			});		

		//加载机构树
	 	$("#treeList").tree({	 		
			 	 url: 'jsonLoadMetaTreeList.do?rootId='+0, 			 	 
			 	 onClick:function(node){//单击事件			 	 	
   				 	if(node.children.length !=0 ){   				 		
   				 		var pid = node.id; 
   				 		//根据pid查询子级机构
   				 		getOrganListByPid(pid);
 				 	}
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
  				/*  required: false, //是否必须
  				 //multiple:true,  //是否支持多选  				 
  				 editable:false, //是否支持用户自定义输入	  				 		 
  				 onSelect:function(record){ // 	当节点被选中时触发。  	  				 			
				 	 	$("#orgPid").val(record.id); 
  				 },
  				 onBeforeExpand:function(node){ //节点展开前触发，返回 false 则取消展开动作。  				  
  				 	$("#treeList").combotree('tree').tree('options').url = 'area/jsonLoadAreaTreeList.do?pid='+ node.id;
  				 },
  				 onLoadSuccess:function(){ //当数据加载成功时触发。
  				 	
  				 	//根据所对应的机构选中复选框
  				 	$("#treeList").combotree('setValues', orgpid);
  				 	var orgId = $("#orgId").val();  
  				 	
  				 	//判断是新增还是编辑	 	
  				 	if(orgId>0){  				 	
  				 		//var pId = $("#areaId").val();
  				 		//var orgName = $("#orgName").val();
  				 		//$("#treeList").combotree("setText",orgName);  				 		
  				 	}else{
						//$("#cmbParentArea").combotree("disable",true);
	   				 	$("#treeList").combotree("setText","=请选择所属机构=");
					}
  				} */
		});	
		});
function metaState(id,used,name){
	var operation=null;
	if(used==0){
		operation="确认禁用配置："+name+"?";		
	}else if(used==1){
		operation="确认启用配置："+name+"?";	
	}
	$.messager.confirm("修改确认",operation,function(r){  
		    if (r){   
			$.ajax({
				url : "jsonMetaStateById.do?id="+id+"&used="+used,
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
function getOrganListByPid(pid){
	  $.ajax({
		url : "jsonLoadOrganListByPid.do?pid="+pid,
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
  			}else{
				$.messager.alert('错误信息',data.message,'error');
  			} 
		}
	});
};
function fillOrganList(lst){
	var html = "<tbody>";
	html += "<tr style='background-color:#D6D3D3;font-weight: bold;'><th width='4%' style='display:none'>&nbsp;</th><th><span style='margin-left:40px'>机构名称</span></th><th>上级机构</th><th>描述</th><th>操作</th></tr>";
	for(var i = 0; i<lst.length;i++){
		html += "<tr>";
		html += "<td  style='display:none'>"+lst[i].id+"</td><td onclick=goToOrganInfo(\'"+lst[i].id+"\') align='left' ><span style='margin-left:40px'>"+lst[i].name+"</span></td><td onclick=goToOrganInfo(\'"+lst[i].id+"\') align='left' >"+lst[i].parentName+"</td>";
		html += "<td onclick=goToOrganInfo(\'"+lst[i].id+"\')>"+lst[i].description+"</td>";
		html +="<td align='left'>"+"<a href='javascript:void(0);' onclick=OperatOrgan(\'"+lst[i].id+"\',\'DELETE\')  style='padding-left:5px;margin-top:25px' >删除</a> </td>";
		html += "</tr>";
	}
	html += "</tbody>";
	$("#organList").html(html);
}
PageClick = function(pageclickednumber) {
	$("#pager").pager({
	    pagenumber:pageclickednumber,                 /* 表示启示页 */
	    pagecount:'${organ.pageCount}',                  /* 表示最大页数pagecount */
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
	function OperatOrgan(organId,operate){
		showProcess(true, '温馨提示', '正在操作，请等待...');
		$.ajax({
			url : "jsonOperateOrgan.do?organId="+organId+"&status="+operate,
			type : "post",
			dataType:"json",
			success : function(data) {
				showProcess(false);
				if(data.code == 0){
					$.messager.show({
						title:'操作信息',
						msg:'服务器响应操作，请稍后。。。',
						showType:'fade',
						width:300,
						modal:true,
						height:150,
						timeout:4000,
						style:{
							right:'',
							bottom:''
						}
					});
					setTimeout(function () {
						$.messager.alert('操作信息', data.message, 'info',function() {
							var pageNo = $.trim($("#pageNumber").val());
							if(pageNo.length == 0 ||pageNo==""){
								pageNo = 1;
							}
							window.location.href="configList.do?pageNo="+pageNo;
						});
					}, 5000);
				}else{
					$.messager.alert('操作信息', data.message, 'error');
				}
			}
		});
	}
	function goToOrganInfo(organId){
		window.location.href="organInfo.do?organId="+organId;
	}
</script>
</head>

<body>

	<div class="con-right" id="conRight">
		<div class="fl yw-lump">
			<div class="yw-lump-title">
				<i class="yw-icon icon-partner"></i><span>配置列表</span><input type="hidden" value="${Config.id}" id="hid_organId" />
			</div>
		</div>
		<div class="fl yw-lump mt10">
			<form id="organForm" name="organForm"
				action="configList.do" method="get">
				<div class="pd10-28">
					<div class="fl">
						 <button class="yw-btn bg-blue cur">全部配置</button>  
					</div>
					<div class="fr">
						<input type="text" name="searchName"   validType="SpecialWord" class="easyui-validatebox"
							   style="width: 120px;" placeholder="搜索关键字：名称" value="${Config.searchName}" />
						<span class="yw-btn bg-orange ml30 cur" onclick="search();">搜索</span>
						<span class="yw-btn bg-green ml20 cur" onclick="window.location.href='configInfo.do?id=0';">新建</span>
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
					<span class="ml26">配置列表</span>
				</div>
				<div class="yw-organ-tree-list" style="height: 639px;">
					<!-- 加载机构树 -->
					<ul  id="treeList"></ul>
				</div>
			</div>
			<div class="yw-lump wid-atuo ml260s mt10" >
				<div class="yw-cm-title">
					<span class="ml26">全部配置</span>
				</div>
				<table class="yw-cm-table yw-leftSide yw-bg-hover" id="organList">
					<tr style="background-color:#D6D3D3;font-weight: bold;">
						<th width="4%" style="display:none">&nbsp;</th>						
						<th><span style='margin-left:40px'>配置状态</span></th>
						<th>配置名称</th>						
						<th>关键字</th>
						<th>操作</th>
					</tr>
					<c:forEach var="item" items="${configList}">
					<tr>
						<td>
							<c:if test="${item.used == 0 }">禁用</c:if>
							<c:if test="${item.used == 1 }">启用</c:if>						
						</td>
						<td>${item.name}</td>
						<td>${item.key}</td>							
						<td>
							<c:if test="${item.used == 1}">
								<a style="color:blue"
									onclick="metaState(${item.id},0,'${item.name}');">禁用</a>
							</c:if> <c:if test="${item.used == 0}">
								<a style="color:blue"
									onclick="metaState(${item.id},1,'${item.name}');">启用</a>
							</c:if> <a style="color:blue" onclick="window.location.href='configInfo.do?id=${item.id}';">编辑</a>
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
