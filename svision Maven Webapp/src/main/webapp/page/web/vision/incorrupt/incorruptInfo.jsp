<%@ page language="java" import="java.util.*" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
   <base href="<%=basePath%>">
  
   <title>廉政监察</title>
   
<meta name="viewport"
content="width=device-width, initial-scale=1, minimum-scale=1  ,maximum-scale=1, user-scalable=no" /> 
<!--
<link rel="stylesheet" type="text/css" href="styles.css">
-->

    <%--//////////--%>
    <%--<link type="text/css" rel="stylesheet" href="<%=basePath%>source/js/plupload/css/bootstrap.css" media="screen" />--%> 
	<script src="${pageContext.request.contextPath}/source/js/common/common.js"></script>
    <link type="text/css" rel="stylesheet" href="<%=basePath%>source/js/plupload/css/my.css" media="screen" />
    <link type="text/css" rel="stylesheet" href="<%=basePath%>source/js/plupload/css/prettify.css" media="screen" />
    <link type="text/css" rel="stylesheet" href="<%=basePath%>source/js/plupload/css/shCore.css" media="screen" />
    <link type="text/css" rel="stylesheet" href="<%=basePath%>source/js/plupload/css/shCoreEclipse.css" media="screen" />
    <link type="text/css" rel="stylesheet" href="<%=basePath%>source/js/plupload/css/jquery-ui.min.css" media="screen" />
    <link type="text/css" rel="stylesheet" href="<%=basePath%>source/js/plupload/css/jquery.ui.plupload.css" media="screen" />

    <script type="text/javascript" src="<%=basePath%>source/js/plupload/shCore.js" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=basePath%>source/js/plupload/shBrushjScript.js" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=basePath%>source/js/plupload/jquery-ui.min.js" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=basePath%>source/js/plupload/plupload.full.min.js" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=basePath%>source/js/plupload/jquery.ui.plupload.min.js" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=basePath%>source/js/plupload/zh_CN.js" charset="UTF-8"></script>
    
    <!-- 以下两个引的文件用于layer -->
	<link type="text/css" rel="stylesheet" href="<%=basePath%>source/js/layer/skin/layer.css"/>	
	<script src="<%=basePath%>source/js/layer/layer.js"></script>
    
    
    <!--[if lte IE 7]>
    <link rel="stylesheet" type="text/css" href="<%=basePath%>source/js/plupload/css/my_ie_lte7.css" />
    <![endif]-->
    <link href="<%=basePath%>source/js/plupload/css/Breeserif.css" rel="stylesheet" type="text/css">
    <!--[if IE]>
    <link href="<%=basePath%>source/js/plupload/css/opensans.css" rel="stylesheet" type="text/css">
    <link href="<%=basePath%>source/js/plupload/css/opensans-300.css" rel="stylesheet" type="text/css">
    <link href="<%=basePath%>source/js/plupload/css/opensans-400.css" rel="stylesheet" type="text/css">
    <link href="<%=basePath%>source/js/plupload/css/opensans-600.css" rel="stylesheet" type="text/css">
    <link href="<%=basePath%>source/js/plupload/css/opensans-700.css" rel="stylesheet" type="text/css">
    <link href="<%=basePath%>source/js/plupload/css/opensans-300s.css" rel="stylesheet" type="text/css">
    <link href="<%=basePath%>source/js/plupload/css/opensans-400s.css" rel="stylesheet" type="text/css">
    <link href="<%=basePath%>source/js/plupload/css/opensans-600s.css" rel="stylesheet" type="text/css">
    <link href="<%=basePath%>source/js/plupload/css/Breeserif-400.css" rel="stylesheet" type="text/css">
    <![endif]-->
    <!--[if IE 7]>
    <link rel="stylesheet" href="<%=basePath%>source/js/plupload/css/font-awesome-ie7.min.css">
    <![endif]-->
    <!--[if lt IE 9]>
    <script src="<%=basePath%>source/js/plupload/html5shiv.js"></script>
    <![endif]-->
    <%--///////////////////--%>

<script type="text/javascript">
	$(document).ready(function(){	 
		$("#datepicker").datepicker(); 
		$("#datepicker").datepicker("option", "dateFormat", "yy-mm-dd");	
	 	 	
	 });
	
	//新增/编辑项目
	function saveItem(obj){
		layer.confirm('确认信息已经填写完整，并且保存？', {
			btn: ['确认','取消'] //按钮
		}, function(){//点击确认按钮调用
			layer.close(layer.confirm());//关闭当前弹出层
			if(isNull()!=false){
				$.ajax({
			        cache: true, //是否缓存当前页面
			        type: "POST", //请求类型
			        url: "<%=basePath %>vision/incorrupt/jsonsetProjectById.do",
			        data:$('#itemInfoForm').serialize(),//发送到服务器的数据，序列化后的值
			        async: true, //发送异步请求	  
			        dataType:"json", //响应数据类型      
			        success: function(data) {
			        	if(data.code==0){ 
			        		layer.confirm('立项成功！', {
								btn: ['确认'] //按钮
							}, function(){//点击确认按钮调用
								layer.close(layer.confirm());//关闭当前弹出层
								window.location.href = '<%=basePath%>vision/incorrupt/incorruptList.do';
							});
			        	}else{
			        		layer.alert(data.message);	        	
			        	}	            
			        }
		   		});
			}	
		}, function(){
			
		});        
	}
	
	function isNull(){		
		if($("#itemName").val()==null || $("#itemName").val()==""){	
			layer.alert('请输入项目名称！');				
			return false;
		} 		
		var superItemType=$("#superItemType").val();
		if(superItemType<0 || superItemType==null){
			layer.alert('请选择项目类别！');	
			return false;
		}
		if($("#datepicker").val()==null || $("#datepicker").val()==""){
			layer.alert('请输入规定完成时间！');			
			return false;
		}  
	}
	
	function returnPage(){
		layer.confirm('当前项目资料尚未提交，是否离开当前页面？', {
			btn: ['确认','取消'] //按钮
		}, function(){//点击确认按钮调用
			layer.close(layer.confirm());//关闭当前弹出层
			window.location.href='<%=basePath%>vision/incorrupt/incorruptList.do';
		}, function(){
			
		});
	}
</script>
 </head> 
 <body>
<div class="con-right" id="conRight">
	<div class="fl yw-lump">
		<div class="yw-lump-title"> 												
				<i id="i_back" class="yw-icon icon-back" onclick="window.location.href='<%=basePath%>vision/efficiency/efficiencyList.do'"></i><span>项目列表</span>
		</div>
	</div>
	<div class="fl yw-lump mt10">
		<div class="yw-bi-rows">
			<div class="yw-bi-tabs mt5" id="ywTabs">
			<span class="yw-bi-now">基本信息</span>
				
			</div>
			<div class="fr">
				<!-- <span class="yw-btn bg-green mr26 hide" id="editBtn"  onclick="editTask();">编辑</span> -->
				
				
			</div>
		</div>
		<div style="width:100%;max-height:700px; overflow-x:hidden; ">
			<form id="itemInfoForm" name="itemInfoForm"  >
				<div id="tab1" class="yw-tab">
					<table class="font16" id="taskTable">
						<tr>
							<td width="15%" align="right">项目名称：</td>
							<td colspan="3"><input id="itemName" 
								name="name" type="text" doc="taskInfo" value=""  style="width:95%;height:28px;" />  
								<span style="color:red">*</span>                            	
                            	<input type="hidden" name="preparerOrgId" value="${userOrg.id }">
                            	<input type="hidden" name="id" value="${itemId }">
                            	<input type="hidden" id="hid_isFileUpload" value="0" />
								<input type="hidden" id="hid_dia_title" value="立项成功" />
							</td> 
						</tr>							
						<tr>
							<td align="right"  >项目类别：</td>
							<td colspan="3">
								<select id="superItemType" name="superItemType" style="width:51%;height:32px;">
									<option value="-1">==请选择项目类别==</option>	
									<c:forEach var="item" items="${meatListByKey }">
										<option value="${item.id }">${item.name }</option>
									</c:forEach>																
								</select> 
								<span style="color:red">*</span>							   
							</td>								
						</tr>
						<tr>
							<td align="right" >规定完成时间：</td>
							<td colspan="3">								
							  <input type="text" name="endTimes" value="" id="datepicker" style="width:50%;height:26px;">
							 	<span style="color:red">*</span> 
							</td>								
						</tr>
						<tr>
							<td></td>
							<td>
								<span class="yw-btn bg-red" style="margin-left: 10px;" id="saveBtn" onclick="saveItem(this);">提交</span>
								<span class="yw-btn bg-green" style="margin-left: 50px;margin-right: 10px;" onclick="returnPage();">返回</span>
							</td>
						</tr>
					</table>
				</div>
			</form>
		</div> 
	</div>
	<div class="cl"></div>
</div>
<div class="cl"></div>
</div>
</body>
</html>  
