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
			
			var pid =-1;
			//加载机构树
		 	$("#treeList").tree({	 		
			 	 url: 'jsonLoadMetaTreeList.do?rootId='+0, 			 	 
			 	 onClick:function(node){//单击事件	
  				 		pid = node.id; 
  				 		//根据pid查询下级配置
  				 		getMetaListByPid(pid);	 				 	
   				 },
   				 onBeforeExpand:function(node){    //节点展开前触发，返回 false 则取消展开动作。
 				 	 	$('#treeList').tree('options').url ='jsonLoadMetaTreeList.do?pid='+ node.id;
 				 },
   				 /* onBeforeSelect:function(node){                    
                    //返回树对象
					var tree = $(this).tree;
					//选中的节点是否为叶子节点,如果不是叶子节点,清除选中
					var isLeaf = tree('isLeaf', node.target);	
					alert(isLeaf);				
                    if(!isLeaf){
                    	 $.messager.alert("温馨提示！","根节点不可选，请选择子节点！",'error');
                        $("#moudle_Id").tree("unselect");
                       
                    }
                 }, */
   				 onLoadSuccess:function(){
   				 	   				 	
   				 }
			});	
		});
//修改配置状态		
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
function deleteConfig(id,name){
	$.messager.confirm("删除确认","确认删除配置："+name+"?",function(r){  
		    if (r){   
			$.ajax({
				url : "jsonDeleteConfigById.do?id="+id,
				type : "post",  
		    	dataType : "json",								
				success : function(data) {											
		  			if(data.code == 0){ 
		  				$.messager.alert('操作信息',data.message,'info',function(){ 
		  					search();  
		      			});
		  			}else{		  			    
						$.messager.alert('错误信息','删除配置失败！','error');
		  			}  
			    } 
			});
	    }  
	}); 
}

//根据pid去查询配置
function getMetaListByPid(pid){
	  $.ajax({
		url : "jsonLoadConfigListByPid.do?pid="+pid,
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
  			}else{
				$.messager.alert('错误信息',data.message,'error');
  			} 
		}
	});
};
function fillMetaList(lst){
	var html = "<tbody>";
	html += "<tr style='background-color:#D6D3D3;font-weight: bold;'><th width='4%' style='display:none'>&nbsp;</th><th><span style='margin-left:40px'>配置状态</span></th><th>配置名称</th><th>关键字</th><th>操作</th></tr>";
	for(var i = 0; i<lst.length;i++){
		html += "<tr>";
		html += "<td  style='display:none'>"+lst[i].id+"</td><td onclick=goToMetaInfo(\'"+lst[i].id+"\') align='left' ><span class='usedTds' style='margin-left:40px'>"+lst[i].used+"</span></td><td onclick=goToMetaInfo(\'"+lst[i].id+"\') align='left' >"+lst[i].name+"</td>";
		html += "<td onclick=goToMetaInfo(\'"+lst[i].id+"\')>"+lst[i].key+"</td>";
		html += "<td align='left'>"+"<a href='javascript:void(0);' onclick=goToMetaInfo(\'"+lst[i].id+"\')  style='margin-top:25px;color:blue' >编辑</a>&nbsp;<a href='javascript:void(0);' class='stateBut' onclick=metaState(\'"+lst[i].id+"\',\'"+lst[i].used+"\',\'"+lst[i].name+"\')  style='margin-top:25px;color:blue' >启用</a>&nbsp;<a href='javascript:void(0);' onclick=deleteConfig(\'"+lst[i].id+"\',\'"+lst[i].name+"\')  style='margin-top:25px;color:blue' >删除</a></td>";
		html += "</tr>";
	}
	html += "</tbody>";
	$("#metaList").html(html);
}

PageClick = function(pageclickednumber) {
	$("#pager").pager({
	    pagenumber:pageclickednumber,                 /* 表示启示页 */
	    pagecount:'${Config.pageCount}',               /* 表示最大页数pagecount */
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
	if ($('#configForm').form('validate')) {
		configForm.submit();
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
function goToMetaInfo(metaId){
	window.location.href="configInfo.do?id="+metaId;
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
			<form id="configForm" name="configForm"
				action="configList.do" method="get">
				<div class="pd10-28">
					<div class="fl">
						 <button class="yw-btn bg-blue cur">全部配置</button>  
					</div>
					<div class="fr">
						<input type="text" id="searchName" name="searchName"  validType="SpecialWord" class="easyui-validatebox"
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
				<table class="yw-cm-table yw-leftSide yw-bg-hover" id="metaList">
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
							<c:if test="${item.used == 0 }"><span style='margin-left:40px'>禁用</span></c:if>
							<c:if test="${item.used == 1 }"><span style='margin-left:40px'>启用</span></c:if>						
						</td>
						<td>${item.name}</td>
						<td>${item.key}</td>							
						<td>
							<a style="color:blue" onclick="window.location.href='configInfo.do?id=${item.id}';">编辑</a>
							<a style="color:blue" onclick="deleteConfig(${item.id},'${item.name}');">删除</a>
							<c:if test="${item.used == 1}">
								<a style="color:blue"
									onclick="metaState(${item.id},${item.used},'${item.name}');">禁用</a>
							</c:if> <c:if test="${item.used == 0}">
								<a style="color:blue"
									onclick="metaState(${item.id},${item.used},'${item.name}');">启用</a>
							</c:if>							
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
