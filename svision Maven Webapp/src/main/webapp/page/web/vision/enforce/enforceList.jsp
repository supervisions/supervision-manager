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
<title>执法监察</title>
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
function showItem(id){
	window.location.href="<%=basePath%>vision/enforce/showItem.do?id="+id;
}
function uploadFile(id,tag){
	window.location.href="<%=basePath%>vision/enforce/enforceFile.do?id="+id+"&tag="+tag;
}
</script>
</head>
<body>
	<div class="con-right" id="conRight">	
		<div class="fl yw-lump">
			<div class="yw-lump-title">
				<i class="yw-icon icon-partner"></i><span>项目列表</span> 
				<div class="fr mr10">
					<span>状态说明： </span>
					 <img src="<%=basePath %>source/images/new.gif" /> 新立项事项
					 <img src="<%=basePath %>source/images/dui.gif" /> 已完结
					 <img src="<%=basePath %>source/images/green.gif" /> 监察中
					 <img src="<%=basePath %>source/images/red.gif" /> 逾期
					 <img src="<%=basePath %>source/images/yellow.gif" /> 未完成
					 <img src="<%=basePath %>source/images/mark.png" width="15" height="15" /> 未签收
				</div>
			</div>
		</div>
		<div class="fl yw-lump mt10">
			
			<form id="toARfrom" action="toAuthorizationResource.do" method="post">
				<input id="toAid" type="hidden" name="id" value="">
				<input id="toAname" type="hidden" name="name" value="">
			</form>
			<form id="taskForm" name="taskForm"
				action="enforceList.do" method="get">
				<div class=pd10>
					<div class="fl">  
						<span>条件查询：</span>
						<input type="text" id="seaarchNameTemp" validType="SpecialWord" class="easyui-validatebox" placeholder="搜索" value="${Item.searchName}" /> 
						<input type="hidden" name="searchName" id="hid_serarch" /> 
						
						<span class="yw-btn bg-blue ml30 cur" onclick="search();">搜索</span>						
					</div>

					<div class="fr">
						<!-- 执法监察的工作事项只有依法领导小组办公室才有权限添加 -->
						<c:if test="${userOrg.id==16 }">
							<span class="yw-btn bg-green cur" onclick="window.location.href='itemInfo.do?id=0';">录入工作事项</span>						
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
					<th width="5%">立项情况</th>
					<th width="5%">状态</th>	
					<th width="5%">性质</th>	
					<th>工作事项</th>	
					<th width="4%">查看</th>	
					<th>立项监察</th>	
					<th width="10%">被监察对象</th>
					<th>操作一</th>
					<th>操作二</th>			
				</tr>
				<c:forEach var="item" items="${itemList}">
					<tr> 							
						<td>
							<%-- <c:if test="">
								<span style="color: red;" onclick="setProject(${item.id })">未立项</span>
							</c:if> --%>
							<c:if test="${item.status == 0}">
								<label style="color:red">未立项</label>
							</c:if>
							<c:if test="${item.status != 0 }">
									<label>已立项</label>	
							</c:if>
						</td>
						<td  style="color:green;">
							<c:if test="${item.status == 0 }">
								<img alt="新项目" title="新项目" src="<%=basePath %>source/images/new.gif" />
							</c:if>
							<c:if test="${item.status == 1 }">
								<img alt="正在监察" title="正在监察" src="<%=basePath %>source/images/green.gif" />
							</c:if>
							<c:if test="${item.status == 2 }">
								<img alt="正在监察" title="正在监察" src="<%=basePath %>source/images/green.gif" />
							</c:if>
							<c:if test="${item.status == 3 }">
								<img alt="已逾期" title="已逾期" src="<%=basePath %>source/images/red.gif" /> 
							</c:if> 
							<c:if test="${item.status == 4 }">
								<img alt="已完结" title="已完结" src="<%=basePath %>source/images/dui.gif" /> 
							</c:if>
						</td>
						<%-- <td>${item.name}</td> --%>
						<td>${item.itemCategory }</td>
						<td title="${item.name}"><p>${item.name}</p></td>
						<td>
							<img alt="查看" title="查看详情" src="<%=basePath %>source/images/search.png" onclick="showItem(${item.id })"  />
							<%-- <a style="color:blue;" onclick="showItem(${item.id })">查看</a> --%>
						</td>						
						<td title="${item.itemName}"><p>${item.itemName}</p></td>
						<td>${item.orgName}</td>
						<td>
							<%-- <span>${item.lasgTag}</span>  --%>		 								
						    <%-- <c:if test="${item.status == 0 &&  userOrg.orgtype==44}">
								<span style="color: red;" onclick="window.location.href='incorruptInfo.do?id=${item.id }';">立项</span>
							</c:if> --%>
							<!-- 若项目类型为综合执法，监察部门为成都分行监察室 -->
							<c:if test="${item.superItemType ==61 }">
								<c:if test="${item.lasgTag == 131 && userOrg.id==19}">
									<%-- <a style="color: blue;" onclick="uploadFile(${item.id}, 131)">监察意见</a> --%>
									<span class="yw-btn-small bg-lan cur"  onclick="uploadFile(${item.id}, 131)">录入监察意见</span>
								</c:if>
								<c:if test="${item.lasgTag == 133 && userOrg.id==19}">
									<%-- <a style="color: blue;" onclick="uploadFile(${item.id}, 133)">监察意见书</a> --%>
									<span class="yw-btn-small bg-lan cur"  onclick="uploadFile(${item.id}, 133)">录入监察意见书</span>
								</c:if>
								<c:if test="${item.lasgTag == 134 && userOrg.id==item.supervisionOrgId}">
									<%-- <a style="color: blue;" onclick="uploadFile(${item.id}, 134)">录入督促整改情况</a> --%>
									<span class="yw-btn-small bg-lan cur"  onclick="uploadFile(${item.id}, 134)">录入督促整改情况</span>
								</c:if>
								<c:if test="${item.lasgTag == 135 && userOrg.id==19}">
									<%-- <a style="color: blue;" onclick="uploadFile(${item.id}, 135)">监察结论</a> --%>
									<span class="yw-btn-small bg-lan cur" onclick="uploadFile(${item.id}, 135)">录入监察结论</span>
								</c:if>
								<c:if test="${item.status == 0 && userOrg.id==19}">
									<%-- <span style="color: red;" onclick="window.location.href='enforceInfo.do?id=${item.id }';">立项</span> --%>
									<span class="yw-btn-small bg-red cur" onclick="window.location.href='enforceInfo.do?id=${item.id }';">立项</span>
								</c:if>
								<c:if test="${item.lasgTag == 137 && userOrg.id==19}">
									<%-- <a style="color: blue;" onclick="uploadFile(${item.id}, 137)">监察行政意见告知书</a> --%>
									<span class="yw-btn-small bg-lan cur" onclick="uploadFile(${item.id}, 137)">监察行政意见告知书</span>
								</c:if>
								<c:if test="${item.lasgTag == 140 && userOrg.id==19}">
									<%-- <a style="color: blue;" onclick="uploadFile(${item.id}, 140)">监察行政处罚决定书</a> --%>
									<span class="yw-btn-small bg-lan cur"  onclick="uploadFile(${item.id}, 140)">监察行政处罚决定书</span>
								</c:if>
								<c:if test="${item.lasgTag == 145 && userOrg.id==19}">
									<%-- <a style="color: blue;" onclick="uploadFile(${item.id}, 135)">监察结论</a> --%>
									<span class="yw-btn-small bg-lan cur" onclick="uploadFile(${item.id}, 135)">录入监察结论</span>
								</c:if>
							</c:if>
							<!-- 如项目类型为单项执法的时候，监察部门为 userOrg.orgtype=47的机构 -->
							<c:if test="${item.superItemType ==62 }">
								<c:if test="${item.lasgTag == 131 && userOrg.orgtype==47}">
									<%-- <a style="color: blue;" onclick="uploadFile(${item.id}, 131)">监察意见</a> --%>
									<span class="yw-btn-small bg-lan cur" onclick="uploadFile(${item.id}, 131)">录入监察意见</span>
								</c:if>
								<c:if test="${item.lasgTag == 133 && userOrg.orgtype==47}">
									<%-- <a style="color: blue;" onclick="uploadFile(${item.id}, 133)">监察意见书</a> --%>
									<span class="yw-btn-small bg-lan cur" onclick="uploadFile(${item.id}, 133)">录入监察意见书</span>
								</c:if>
								<c:if test="${item.lasgTag == 134 && userOrg.id==item.supervisionOrgId}">
									<%-- <a style="color: blue;" onclick="uploadFile(${item.id}, 134)">录入督促整改情况</a> --%>
									<span class="yw-btn-small bg-lan cur" onclick="uploadFile(${item.id}, 134)">录入督促整改情况</span>
								</c:if>
								<c:if test="${item.lasgTag == 135 && userOrg.orgtype==47}">
									<a style="color: blue;" onclick="uploadFile(${item.id}, 135)">监察结论</a>
									<span class="yw-btn-small bg-lan cur" onclick="uploadFile(${item.id}, 135)">录入监察结论</span>
								</c:if>
								<c:if test="${item.status == 0 && userOrg.orgtype==47}">
									<%-- <span style="color: red;" onclick="window.location.href='enforceInfo.do?id=${item.id }';">立项</span> --%>
									<span class="yw-btn-small bg-red cur" onclick="window.location.href='enforceInfo.do?id=${item.id }';">立项</span>
								</c:if>
								<c:if test="${item.lasgTag == 137 && userOrg.orgtype==47}">
									<%-- <a style="color: blue;" onclick="uploadFile(${item.id}, 137)">监察行政意见告知书</a> --%>
									<span class="yw-btn-small bg-lan cur" onclick="uploadFile(${item.id}, 137)">监察行政意见告知书</span>
								</c:if>
								<c:if test="${item.lasgTag == 140 && userOrg.orgtype==47}">
									<%-- <a style="color: blue;" onclick="uploadFile(${item.id}, 140)">监察行政处罚决定书</a> --%>
									<span class="yw-btn-small bg-lan cur"  onclick="uploadFile(${item.id}, 140)">监察行政处罚决定书</span>
								</c:if>
								<c:if test="${item.lasgTag == 145 && userOrg.orgtype==47}">
									<%-- <a style="color: blue;" onclick="uploadFile(${item.id}, 135)">监察结论</a> --%>
									<span class="yw-btn-small bg-lan cur"  onclick="uploadFile(${item.id}, 135)">录入监察结论</span>
								</c:if>
							</c:if>
							
							
							
							<c:if test="${item.lasgTag == 130 && userOrg.id==item.supervisionOrgId}">
								<%-- <a style="color: blue;" onclick="uploadFile(${item.id}, 130)">录入执法监察立项资料</a> --%>
									<span class="yw-btn-small bg-lan cur"  onclick="uploadFile(${item.id}, 130)">录入执法检查立项资料</span>
							</c:if>
							<c:if test="${item.lasgTag == 230 && userOrg.id==item.supervisionOrgId}">
								<%-- <a style="color: blue;" onclick="uploadFile(${item.id}, 130)">录入执法监察立项资料</a> --%>
									<span class="yw-btn-small bg-lan cur"  onclick="uploadFile(${item.id}, 130)">录入执法检查立项资料</span>
							</c:if>
							
							<c:if test="${item.lasgTag == 132 && userOrg.id==item.supervisionOrgId}">
								<%-- <a style="color: blue;" onclick="uploadFile(${item.id}, 132)">录入监察报告、意见书</a> --%>
									<span class="yw-btn-small bg-lan cur"  onclick="uploadFile(${item.id}, 132)">录入检查报告、检查意见书</span>
							</c:if>
							<c:if test="${item.lasgTag == 232 && userOrg.id==item.supervisionOrgId}">
								<%-- <a style="color: blue;" onclick="uploadFile(${item.id}, 132)">录入监察报告、意见书</a> --%>
									<span class="yw-btn-small bg-lan cur"  onclick="uploadFile(${item.id}, 132)">录入检查报告、检查意见书</span>
							</c:if>
							
							<c:if test="${item.lasgTag == 136 && userOrg.id==item.supervisionOrgId}">
								<%-- <a style="color: blue;" onclick="uploadFile(${item.id}, 136)">行政处罚意见告知书</a> --%>
									<span class="yw-btn-small bg-lan cur"  onclick="uploadFile(${item.id}, 136)">录入行政处罚意见告知书</span>
							</c:if>
							<c:if test="${item.lasgTag == 234 && userOrg.id==item.supervisionOrgId}">
								<%-- <a style="color: blue;" onclick="uploadFile(${item.id}, 136)">行政处罚意见告知书</a> --%>
									<span class="yw-btn-small bg-lan cur"  onclick="uploadFile(${item.id}, 136)">录入行政处罚意见告知书</span>
							</c:if>
							
							<c:if test="${item.lasgTag == 138 && userOrg.id==item.supervisionOrgId}">
								<%-- <a style="color: blue;" onclick="uploadFile(${item.id}, 138)">不听证</a> --%> 
								<span class="yw-btn-small bg-lan cur"  onclick="uploadFile(${item.id}, 138)">不听证</span>
								&nbsp;
								<%-- <a style="color: blue;" onclick="uploadFile(${item.id}, 139)">听证</a>		 --%>
								<span class="yw-btn-small bg-lan cur"  onclick="uploadFile(${item.id}, 139)">听证</span>					
							</c:if>							
							<c:if test="${item.lasgTag == 141 && userOrg.id==item.supervisionOrgId}">
								<%-- <a style="color: blue;" onclick="uploadFile(${item.id}, 141)">录入听证相关资料</a> --%>
								<span class="yw-btn-small bg-lan cur"  onclick="uploadFile(${item.id}, 141)">录入听证相关资料</span>		
							</c:if>
							<c:if test="${item.lasgTag == 142 && userOrg.id==item.supervisionOrgId}">
								<%-- <a style="color: blue;" onclick="uploadFile(${item.id}, 138)">录入行政处罚决定书</a> --%>
								<span class="yw-btn-small bg-lan cur" onclick="uploadFile(${item.id}, 138)">录入行政处罚决定书</span>	
							</c:if>
							<c:if test="${item.lasgTag == 144 && userOrg.id==item.supervisionOrgId}">
								<%-- <a style="color: blue;" onclick="uploadFile(${item.id}, 138)">录入行政处罚决定书</a> --%>
								<span class="yw-btn-small bg-lan cur"  onclick="uploadFile(${item.id}, 138)">录入行政处罚决定书</span>	
							</c:if>
							<c:if test="${item.lasgTag == 143 && userOrg.id==item.supervisionOrgId}">
								<%-- <a style="color: blue;" onclick="uploadFile(${item.id}, 143)">不复议</a> --%>
								<span class="yw-btn-small bg-lan cur"  onclick="uploadFile(${item.id}, 143)">不复议</span>&nbsp;	
								<%-- <a style="color: blue;" onclick="uploadFile(${item.id}, 147)">复议</a> --%>
								<span class="yw-btn-small bg-lan cur" onclick="uploadFile(${item.id}, 147)">复议</span>
							</c:if>							
							<c:if test="${item.lasgTag == 147 && userOrg.id==item.supervisionOrgId}">
								<%-- <a style="color: blue;" onclick="uploadFile(${item.id}, 143)">录入行政处罚情况</a> --%>
								<span class="yw-btn-small bg-lan cur" onclick="uploadFile(${item.id}, 143)">录入行政处罚情况</span>
							</c:if>
							<c:if test="${item.status == 4}">
								<span>【已完结】</span>
							</c:if>
						</td>
						<td>
							<c:if test="${userOrg.orgtype==47 || userOrg.orgtype==46}">
								<%-- <a style="color: blue;" onclick="deleteItem(${item.id},'${item.name}')">删除</a> --%>
								<span class="yw-btn-small bg-lan cur" onclick="deleteItem(${item.id},'${item.name}')">删除</span>
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












