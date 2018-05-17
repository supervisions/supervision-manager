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
<title>量化指标管理</title> 
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/source/js/easyUI/themes/default/easyui.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/source/js/easyUI/themes/icon.css"> 
	<script type="text/javascript" src="${pageContext.request.contextPath}/source/js/easyUI/jquery.easyui.min.js"></script>
	<script src="${pageContext.request.contextPath}/source/js/easyUI/easyui-lang-zh_CN.js"></script>
	<script src="${pageContext.request.contextPath}/source/js/common/validate.js"></script>
	<script src="${pageContext.request.contextPath}/source/js/common/common.js"></script>
<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1  ,maximum-scale=1, user-scalable=no" /> 
	<link rel="shortcut icon" href="<%=basePath%>source/images/favicon.ico" type="image/x-icon" />
<script type="text/javascript">
		$(document).ready(function(){
			  $("#SchemeTree").tree({
			  	url:'<%=basePath %>manage/casedetail/jsonLoadGradeSchemeTreeList.do',
			  	onClick:function(node){   
			  		if(node.isLeaf == 1){
			  			loadGradeSchemeDetial(node.gradeId,node.level);
			  		}else{
			  			loadGradeSchemeDetial(node.id,null);
			  		}
			  	}
			  }); 
		}); 
function fillOrganList(lst){
	var html = "<tbody>";
	html += "<tr style='background-color:#D6D3D3;font-weight: bold;'><th width='4%' style='display:none'>&nbsp;</th><th><span style='margin-left:40px'>指标等级</span></th><th>指标名称</th><th>上级指标</th><th>所属模型</th><th>权重/标准分</th><th>操作一</th><th>操作二</th></tr>";
	for(var i = 0; i<lst.length;i++){
		html += "<tr>";
		html += "<td  style='display:none'>"+lst[i].id+"</td><td align='left' ><span style='margin-left:40px'>";
		if(lst[i].level == 0){
			html += "一级指标";
		}else if(lst[i].level == 1){
			html += "二级指标";
		}else if(lst[i].level == 2){
			html += "三级指标";
		}
		html +="</span></td><td align='left' >"+lst[i].name+"</td><td align='left' >";
		if(lst[i].pName != null && lst[i].pName != ""){
			html += lst[i].pName;
		} 
		html += "</td><td align='left' >"+lst[i].schemaName+"</td><td class='supervisionState'>"+lst[i].grade+"</td>";
		html +="<td align='left'>"+"<span class='yw-btn-small bg-lan cur' onclick=editDetail("+lst[i].id+",'"+lst[i].name+"');>编辑</span>";
		if(lst[i].level == 0){
			html +="<span class='yw-btn-small bg-lan cur' style='margin-left:5px;'  onclick=window.location.href='<%=basePath %>manage/casedetail/casedetailInfo.do?id=0&level=1&pid="+lst[i].id+"'>添加二级指标</span>";
		}else if(lst[i].level == 1){
			html +="<span class='yw-btn-small bg-lan cur' style='margin-left:5px;' onclick=window.location.href='<%=basePath %>manage/casedetail/casedetailInfo.do?id=0&level=2&pid="+lst[i].id+"'>添加三级指标</span>";
		}
		html += "</td>";
		html += "<td align='left' >"+"<span class='yw-btn-small bg-red cur' onclick=deleteDetail("+lst[i].id+",'"+lst[i].name+"')>删除</span></td></tr>";
	}
	html += "</tbody>";
	$("#organList").html(html);
} 
function loadGradeSchemeDetial(gId,level){
	 var obj = {};
	 obj.gradeId = gId;
	 if(level != undefined && level != null){
	 	obj.level = level;
	 }
	$.ajax({
		url:'<%=basePath %>manage/casedetail/jsonLoadGradeSchemeDetailList.do', 
		dataType:"json",
		type : "post",  
		data: obj,
		success : function(data) {
  			if(data != undefined && data != null){ 
  				if(data.length>0){
  					fillOrganList(data);
  				}
  			}else{	 
			 	$.messager.alert('错误信息','加载量化指标失败！','error'); 
  			}  
	    } 
	});
} 
function deleteDetail(id,name){
	$.messager.confirm("删除确认","确认删除模型明细："+name+"?",function(r){  
		    if (r){   
			$.ajax({
				url : "<%=basePath %>manage/casedetail/jsondeleteDetailById.do?id="+id,
				type : "post",  
		    	dataType : "json",								
				success : function(data) {
		  			if(data.code == 0){ 
		  				$.messager.alert('操作信息',data.message,'info',function(){ 
		  					window.location.href="<%=basePath %>manage/casedetail/casedetailList.do";
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
	window.location.href="<%=basePath %>manage/casedetail/casedetailInfo.do?id="+id;
}
function editDetail(id,pName){
	window.location.href="<%=basePath %>manage/casedetail/casedetailInfo.do?id="+id+"&pName="+pName;
}
</script>
</head>

<body>

	<div class="con-right" id="conRight">
		<div class="fl yw-lump">
			<div class="yw-lump-title">
				<i class="yw-icon icon-partner"></i><span>模型明细列表</span><input type="hidden" value="${Organ.id}" id="hid_organId" />
			</div>
		</div>
		<div class="fl yw-lump mt10">
			<form id="organForm" name="organForm"
				action="<%=basePath %>manage/casedetail/casedetailList.do" method="get">
				<div class="pd10-28">
					<div class="fl">
						 <button class="yw-btn bg-blue cur">全部模型</button>  
					</div> 
					<div class="fr"> 
						<input type="hidden" value="${SchemeId }" id="hid_SchemeId" />
						<span class="yw-btn bg-green" style="margin-left: 10px;"   onclick="window.location.href='<%=basePath %>manage/casedetail/casedetailInfo.do?id=0&level=0&pid=0'">添加一级指标</span> 
					</div>
					<div class="cl"></div>
				</div> 
			</form>
		</div>
		<div class="fl">
			<div class="fl yw-lump mlwid250 mt10">
				<div class="yw-cm-title">
					<span class="ml26">模型列表</span>
				</div>
				<div class="yw-organ-tree-list" style="height: 639px;">
					<!-- 加载机构树 -->
					<ul id="SchemeTree"> </ul> 
				</div>
			</div>
			<div class="yw-lump wid-atuo ml260s mt10" >
				<div class="yw-cm-title">
					<span class="ml26">全部指标</span>
				</div>
				<div class="yw-cm-sub-table">
				<div style="max-height: 600px;overflow-x: hidden;">
				<table class="yw-cm-table yw-leftSide yw-bg-hover" id="organList">
					<tr style="background-color:#D6D3D3;font-weight: bold;">
						<th><span style='margin-left:40px'>指标等级</span></th> 		 
						<th>指标名称</th> 
						<th>上级指标</th> 		 
						<th>所属模型</th> 		
						<th>权重</th>											   
						<th>操作一</th> 
						<th>操作二</th>
					</tr>
					<c:forEach var="item" items="${DetailList }">
						<tr> 			
							<td  align="left">
								<c:if test="${item.level == 0 }"> 
									<span style='margin-left:40px'>一级指标</span>
								</c:if>
								<c:if test="${item.level == 1 }"> 
									<span style='margin-left:40px'>二级指标</span>
								</c:if>
								<c:if test="${item.level == 2 }"> 
									<span style='margin-left:40px'>三级指标</span>
								</c:if>
							</td>		
							<td>${item.name }</td> 
							<td align="left">${item.pName }</td>
							<td align="left">${item.schemaName }</td>
							<td align="left">${item.grade }</td>
							<td align="left">
								
								<%-- <a href="javascript:void(0);" style="color:blue" onclick="editDetail(${item.id},'${item.pName }');">编辑</a> --%>
								<span class="yw-btn-small bg-lan cur" onclick="editDetail(${item.id},'${item.pName }');">编辑</span>
								<c:if test="${item.level == 0 }"> 
								
									<span class="yw-btn-small bg-lan cur" onclick="window.location.href='<%=basePath %>manage/casedetail/casedetailInfo.do?id=0&level=1&pid=${item.id }'">添加二级指标</span>
									<%-- <a href="javascript:void(0);" style="color:blue" onclick="window.location.href='<%=basePath %>manage/casedetail/casedetailInfo.do?id=0&level=1&pid=${item.id }'">添加二级指标</a> --%> 
								</c:if>
								<c:if test="${item.level == 1 }"> 
									<span class="yw-btn-small bg-lan cur" onclick="window.location.href='<%=basePath %>manage/casedetail/casedetailInfo.do?id=0&level=2&pid=${item.id }'">添加三级指标</span>
									<%-- <a href="javascript:void(0);" style="color:blue" onclick="window.location.href='<%=basePath %>manage/casedetail/casedetailInfo.do?id=0&level=2&pid=${item.id }'">添加三级指标</a> --%> 
								</c:if>
							</td>
							<td>
								<%-- <a href="javascript:void(0);" style="color:blue" onclick="deleteDetail(${item.id},'${item.name}')">删除</a> --%>
								<span class="yw-btn-small bg-red cur" onclick="deleteDetail(${item.id},'${item.name}')">删除</span>
							</td>
						</tr>
					</c:forEach>
				</table> </div>
			</div>
			</div>
		</div>
	</div>
</body>
</html>
