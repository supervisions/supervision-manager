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
			//showProcess(true, '温馨提示', '正在加载数据...');
			$("#pager").pager({
			    pagenumber:'${SchemeDetail.pageNo}',                         /* 表示初始页数 */
			    pagecount:'${SchemeDetail.pageCount}',                      /* 表示总页数 */
			    totalCount:'${SchemeDetail.totalCount}',
			    buttonClickCallback:PageClick                     /* 表示点击分页数按钮调用的方法 */                  
			});

			//加载机构树
		 	$("#treeList").tree({	 		
			 	 url: 'jsonLoadGradeSchemeTreeList.do?pid='+0, 			 	 
			 	 onClick:function(node){//单击事件		
			 	 	//获取当前的树
			 	 	var tree = $(this).tree;
					//选中的节点是否为叶子节点
					var isLeaf = tree('isLeaf', node.target);		
			 	 	if(isLeaf){	//是叶子节点
			 	 		//判断该叶子节点是方案节点还是明细节点
			 	 		if(node.gradeId==undefined){ 
			 	 			//如果是方案节点则直接提示改节点下没有指标，不访问服务器
			 	 			$.messager.alert("温馨提示！","该节点下没有指标！",'error');
                        	$("#moudle_Id").tree("unselect");
			 	 		}else{
			 	 			//如果该叶子节点是明细节点，则根据该节点的gradeId和id去查询（节点id作为查询条件的pid）
			 	 			var gradeId=node.gradeId; 	 	
			 	 			var pid=node.id;			 	 		
			 	 			getGradeSchemeDetailListByPid(pid,gradeId);
			 	 		}
			 	 	}else{
			 	 		//单击的节点是父节点的时候，查询条件的pid为0		
			 	 		var gradeId=node.id;	 	 		
			 	 		getGradeSchemeDetailListByPid(0,gradeId);
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
			});	
		});
function getGradeSchemeDetailListByPid(pid,gradeId){
	  $.ajax({
		url : "jsonLoadSchemeDetailListByPid.do?pid="+pid+"&gradeId="+gradeId,
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
function fillOrganList(lst){
	var html = "<tbody>";
	html += "<tr style='background-color:#D6D3D3;font-weight: bold;'><th width='4%' style='display:none'>&nbsp;</th><th><span style='margin-left:40px'>指标名称</span></th><th>上级指标</th><th>所属方案</th><th>分值</th><th>操作</th></tr>";
	for(var i = 0; i<lst.length;i++){
		html += "<tr>";
		html += "<td  style='display:none'>"+lst[i].id+"</td><td align='left' ><span style='margin-left:40px'>"+lst[i].name+"</span></td><td align='left' ><span>"+lst[i].pName+"</span></td><td align='left' >"+lst[i].schemaName+"</td>";
		html += "<td class='supervisionState'>"+lst[i].grade+"</td>";
		html +="<td align='left'>"+"<a style='color:blue' onclick=deleteDetail(\'"+lst[i].id+"\',\'"+lst[i].name+"\')>删除</a> <a style='color:blue'onclick=editDetail(\'"+lst[i].id+"\',\'"+lst[i].pName+"\')>编辑</a> </td>";
		html += "</tr>";
	}
	html += "</tbody>";
	$("#organList").html(html);
}
PageClick = function(pageclickednumber) {
	$("#pager").pager({
	    pagenumber:pageclickednumber,                 /* 表示启示页 */
	    pagecount:'${SchemeDetail.pageCount}',                  /* 表示最大页数pagecount */
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

function deleteDetail(id,name){
	$.messager.confirm("删除确认","确认删除方案明细："+name+"?",function(r){  
		    if (r){   
			$.ajax({
				url : "jsondeleteDetailById.do?id="+id,
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
function goToOrganInfo(organId){
	window.location.href="casedetailInfo.do?id="+id;
}
function editDetail(id,pName){
	window.location.href="casedetailInfo.do?id="+id+"&pName="+pName;
}
</script>
</head>

<body>

	<div class="con-right" id="conRight">
		<div class="fl yw-lump">
			<div class="yw-lump-title">
				<i class="yw-icon icon-partner"></i><span>方案明细列表</span><input type="hidden" value="${Organ.id}" id="hid_organId" />
			</div>
		</div>
		<div class="fl yw-lump mt10">
			<form id="organForm" name="organForm"
				action="casedetailList.do" method="get">
				<div class="pd10-28">
					<div class="fl">
						 <button class="yw-btn bg-blue cur">全部方案</button>  
					</div>
					<div class="fr">
						<input type="text" name="searchName"   validType="SpecialWord" class="easyui-validatebox"
							   style="width: 120px;" placeholder="搜索关键字：名称" value="${SchemeDetail.searchName}" />
						<span class="yw-btn bg-orange ml30 cur" onclick="search();">搜索</span>
						<span class="yw-btn bg-green ml20 cur" onclick="window.location.href='casedetailInfo.do?id=0'">新建</span>
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
					<span class="ml26">方案列表</span>
				</div>
				<div class="yw-organ-tree-list" style="height: 639px;">
					<!-- 加载机构树 -->
					<ul  id="treeList"></ul>
				</div>
			</div>
			<div class="yw-lump wid-atuo ml260s mt10" >
				<div class="yw-cm-title">
					<span class="ml26">全部机构</span>
				</div>
				<table class="yw-cm-table yw-leftSide yw-bg-hover" id="organList">
					<tr style="background-color:#D6D3D3;font-weight: bold;">
						<th width="4%" style="display:none">&nbsp;</th>
						<th><span style='margin-left:40px'>指标名称</span></th>
						<th>上级指标</th>
						<th>所属方案</th>
												
						<th>分数</th>											
						<th>操作</th> 
					</tr>
					<c:forEach var="item" items="${DetailList }">
						<tr>
							<td style="display:none">${item.id }</td>						
							<td><span style='margin-left:40px'>${item.name }</span></td>
							<td  align="left">${item.pName }</td>
							<td  align="left">${item.schemaName }</td>
							<td  align="left">${item.grade }</td>
							<td align="left">
								<a href="javascript:void(0);" style="color:blue" onclick="deleteDetail(${item.id},'${item.name}')">删除</a>
								<a href="javascript:void(0);" style="color:blue" onclick="editDetail(${item.id},'${item.pName }');">编辑</a>
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
