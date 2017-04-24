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
<title>任务管理</title>
<meta http-equiv="refresh" content="3600">
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
		}); 		 
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
	if ($('#taskForm').form('validate')) {
		taskForm.submit();
	}
}
function showdialog(){
	var wz = getDialogPosition($('#taskInfoWindow').get(0),100);
	$('#taskInfoWindow').window({
		  	top: 100,
		    left: wz[1],
		    onBeforeClose: function () {
		    },
		    onClose:function(){
		    	$('#saveTaskForm .easyui-validatebox').val(''); 
		    }
	});
	$('#taskInfoWindow').window('open');
}
function saveTask(obj){
	if ($('#saveTaskForm').form('validate')) {
		$(obj).attr("onclick", ""); 
		showProcess(true, '温馨提示', '正在提交数据...'); 
		 $('#saveTaskForm').form('submit',{
		  		success:function(data){ 
					showProcess(false);
		  			data = $.parseJSON(data);
		  			if(data.code==0){
	  					$('#taskInfoWindow').window('close');
		  				$.messager.alert('保存信息',data.message,'info',function(){
	        			});
	  					search();
		  			}else{
						$.messager.alert('错误信息',data.message,'error',function(){
	        			});
						$(obj).attr("onclick", "saveTask(this);"); 
		  			}
		  		}
		  	 });  
	}
}  
function getDateModel(date){
	var year = date.getFullYear();
	var month = date.getMonth()+1;
	if(month <10){
		month = "0"+month;
	}
	var day = date.getDate();
	if(day <10){
		day = "0"+day;
	}
	var dates = year+"-"+month+"-"+day;
	return dates;
}
function getSelectDate(date){
	var dates = getDateModel(date);
	$("#startTimes").val(dates);
}
function sltSchStime(date){
	var dates = getDateModel(date);
	$("#startedTimes").val(dates);
}
function sltSchEtime(date){
	var dates = getDateModel(date);
	$("#endTimes").val(dates);
}
 function runTask(id){
	$.messager.confirm("执行确认","确认执行该任务,并在后台自动运行?",function(r){  
		    if (r){  
		  //  $.messager.alert('任务开始启动!');
			$.ajax({
				url : "userInfo.do?id="+id,
				type : "post",  
		    	dataType : "json",								
				success : function(data) { 									
		  			if(data.code == 0){ 
		  				$.messager.alert('任务启动信息',data.message,'info',function(){ 
		  					search(); 
		  					//window.location.href="taskList.do";
		      		});
		  			}else{		  			    
						$.messager.alert('错误信息','任务启动失败！','error');
		  			}  
			    } 
			});
	    }  
	}); 
}  
function runTaskNow(id){
	$.messager.confirm("执行确认","确认立即执行该任务?",function(r){  
		    if (r){  
		  //  $.messager.alert('任务开始启动!');
			$.ajax({
				url : "<%=basePath%>dataUtil/jsonloadTaskRun.do?id="+id,
				type : "post",  
		    	dataType : "json",								
				success : function(data) { 									
		  			if(data.code == 0){ 
		  				$.messager.alert('任务启动信息',data.message,'info',function(){ 
		  					runTaskAction(id);
		  					//window.location.href="taskList.do";
		      			});
		  			}else{		  			    
						$.messager.alert('错误信息','任务启动失败！','error');
		  			}  
			    } 
			});
	    }  
	}); 
} 
function runTaskAction(id){
 //  $.messager.alert('任务开始启动!');
	$.ajax({
		url : "<%=basePath%>dataUtil/jsonloadTaskRunRightNow.do?id="+id,
		type : "post",  
    	dataType : "json",								
		success : function(data) {  
	    } 
	}); 
	search();  
}
function deleteTask(id){
	$.messager.confirm("删除确认","确认删除该任务?",function(r){  
		    if (r){   
			$.ajax({
				url : "jsondeleteTaskById.do?id="+id,
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
function StopTask(id){
	$.messager.confirm("终止确认","确认立即终止该任务?",function(r){  
			    if (r){   
				$.ajax({
					url : "jsonloadTaskStop.do?id="+id,
					type : "post",  
			    	dataType : "json",								
					success : function(data) { 									
			  			if(data.code == 0){ 
			  				$.messager.alert('操作信息',data.message,'info',function(){ 
			  					search(); 
			  					//window.location.href="taskList.do";
			      		});
			  			}else{		  			    
							$.messager.alert('错误信息','任务终止失败！','error');
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
				<i class="yw-icon icon-partner"></i><span>机构列表</span> 
			</div>
		</div>
		<div class="fl yw-lump mt10">
			<form id="taskForm" name="taskForm"
				action="userList.do" method="get">
				<div class=pd10>
					<div class="fl">  
						<span>条件查询：</span>
						<input type="text" id="seaarchNameTemp" validType="SpecialWord" class="easyui-validatebox" placeholder="搜索" value="${Task.searchName}" /> 
						<input type="hidden" name="searchName" id="hid_serarch" /> 
						
						<span class="yw-btn bg-blue ml30 cur" onclick="search();">搜索</span>						
					</div>

					<div class="fr">
					<span class="yw-btn bg-green cur" onclick="window.location.href='userInfo.do?id=0';">新增机构</span> 
					</div>
						<div class="cl"></div>				
                     <input type="hidden" id="pageNumber" name="pageNo" value="${Task.pageNo}" />
                     </div>
		     	</form>
		     	</div>
				
           <div class="fl yw-lump"> 
				<table class="yw-cm-table yw-center yw-bg-hover" id="taskList">
					<tr style="background-color:#D6D3D3;font-weight: bold;">
					
					<th width="8%">状态</th>
					<th width="8%">是否监察部门</th>
					
					<th width="8%">机构名称</th>
					<th width="8%">状态</th>
					
							
					
					</tr>
					<c:forEach var="item" items="${userList}">
						<tr> 
							<td><c:if test="${item.used == 1}">
								<span>有效</span>
							</c:if> <c:if test="${item.used == 0}">
								<span>无效</span>
							</c:if></td>
							<td>${item.name}</td>
						<td>${item.account}</td>

						<td><c:if test="${item.used == 1}">
								<a style="color:blue" onclick="runTask(${item.id});">删除</a>
							</c:if> 
							<c:if test="${item.used == 0}">
								<a style="color:blue" onclick="runTask(${item.id});">删除</a>
							</c:if>
							<%-- <a style="color:blue" onclick="window.location.href='userInfo.do?id=${item.id}';">编辑</a>&nbsp;&nbsp; --%>
							</td>
						</tr>
					</c:forEach>
				</table>
				<div class="page" id="pager"></div>
				</div>
			</div>

 		

  </body>
</html>












