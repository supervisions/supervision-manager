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
  
   <title>项目量化</title>
     
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/source/js/easyUI/themes/default/easyui.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/source/js/easyUI/themes/icon.css"> 
	<script type="text/javascript" src="${pageContext.request.contextPath}/source/js/easyUI/jquery.easyui.min.js"></script>
	<script src="${pageContext.request.contextPath}/source/js/easyUI/easyui-lang-zh_CN.js"></script>
	<script src="${pageContext.request.contextPath}/source/js/common/validate.js"></script>
	<script src="${pageContext.request.contextPath}/source/js/common/common.js"></script>
	
	<!-- 以下两个引的文件用于layer -->
	<link type="text/css" rel="stylesheet" href="<%=basePath%>source/js/layer/skin/layer.css"/>	
	<script src="<%=basePath%>source/js/layer/layer.js"></script>
       
<script type="text/javascript">
	$(document).ready(function(){	  
 	 	 $("#conLeft").attr("style","height:120%;");
	 });
	
	//新增/编辑项目
	function saveItem(){	
		var isValued = $("#hid_isVlaue").val();
		var obj = {};
		obj.itemId = $.trim($("#hid_itemId").val());
		obj.isValue = isValued;
		if(isValued == 1) {
			var pId = $.trim($("#valueTypeId").val());
			if(pId == "-1"){
				$.messager.alert("操作提示","请选择量化模型，并量化分值","error"); 
			    return;
			}
			
			obj.gradeSchemeId = pId;
			var valueArray = [];
			var detailArray = [];
			var value_collect = $("#value_table input[name='values']"); 
			var det_id_collect = $("#value_table input[name='detailId']");
			$.each(value_collect,function(index,item){
				if($.trim(item.value) != ""){
					valueArray.push(item.value);
				}
			});
			if(valueArray.length == 0){
				$.messager.alert("操作提示","请量化各项三级指标分值","error");  
			    return;
			}
			$.each(det_id_collect,function(index,item){
				detailArray.push(item.value);
			});   
			if(detailArray.length != valueArray.length){
				$.messager.alert("操作提示","请完善量化各项三级指标分值，不允许有空值","error");   
			    return;
			}else{
				obj.values = valueArray.toString();
				obj.detailId =  detailArray.toString(); 
			}
		}
		layer.confirm('确认信息已经填写完整，并且保存？', {
			btn: ['确认','取消'] //按钮
		}, function(){//点击确认按钮调用
			layer.close(layer.confirm());//关闭当前弹出层
			$.ajax({
		        cache: true, //是否缓存当前页面
		        type: "POST", //请求类型
		        url: "<%=basePath%>manage/support/jsonSaveOrUpdateItemValue.do",
		        data:obj,//发送到服务器的数据，序列化后的值
		        async: true, //发送异步请求	  
		        dataType:"json", //响应数据类型      
		        success: function(data) {
		        	if(data.code==0){ 
		        		$.messager.alert("操作提示",data.message,"info",function(){
		        			window.location.href='<%=basePath%>manage/support/supportList.do';
		        		});   
		        	}else{
		        		$.messager.alert("操作提示",data.message,"error");  
		        	}	
		            
		        }
	   		});
		}, function(){
			
		});	   
         
	}
	function downLoadFile(path,name){
		var filePath = encodeURI(encodeURI(path));
		var fileName = encodeURI(encodeURI(name));
		window.open("<%=basePath %>system/upload/downLoadFile.do?filePath="+filePath+"&fileName="+fileName);
	}
	function gradeChange(){
		var pId = $.trim($("#valueTypeId").val());
		if(pId == "-1"){
			$("#dia_title").text("请选择量化模型，并量化分值");
			var mesDia = $("#dialog1").dialog({
		      resizable: false,
		      height:150,
		      modal: true,
		      open: function (event, ui) {
                  $(".ui-dialog-titlebar-close", $(this).parent()).hide();
              },
		      buttons: {
		        "确定": function() {
		    		 $(this).dialog("close");
		        } 
		      }
		    }); 
		    return;
		}
		$("#sp_total_value").text("未量化");
		$.ajax({ 
	        type: "POST", //请求类型
	        url: "<%=basePath%>manage/support/jsonLoadGradeSchemeDetail.do?gradeId="+pId,  
	        dataType:"json", //响应数据类型      
	        success: function(data) {
	        	if(data != undefined && data != null){ 
	        		 if(data.length >0){ 
	        			var aHtml ="";
	        			for(var i = 0; i< data.length;i++)
	        			{    
	        				if(data[i].level == 0){ 
	        					aHtml +="<tr><td colspan='3'><label>一级指标：</label><span>"+data[i].name+"</span><label style='margin-left:6%;'>权重：</label><span>"+data[i].grade+"</span></td><td></td></tr>";
								if(data[i].children != null && data[i].children.length>0){
									for(var j = 0; j< data[i].children.length;j++){ 
										aHtml +="<tr><td width='3%'></td><td colspan='2'><label>二级指标：</label><span>"+data[i].children[j].name+"</span><label style='margin-left:3%;'>权重：</label><span>"+data[i].children[j].grade+"</span></td><td></td></tr>";
										if(data[i].children[j].children != null && data[i].children[j].children.length>0){
											for(var m = 0;m<data[i].children[j].children.length;m++){
												aHtml +="<tr name='tr_"+i+"'><td colspan='2' width='6%'></td> <td><label>三级指标：</label><span>"+data[i].children[j].children[m].name+"</span><label>标准分：</label><span>"+data[i].children[j].children[m].grade+"，</span> ";
												aHtml +="<label>得分：</label><input type='hidden' name='detailId' value='"+data[i].children[j].children[m].id+"' /><input doc='ipt_value' type='text' name='values' class='easyui-validatebox' onchange='getValue(this,"+i+","+data[i].children[j].children[m].grade+")' validType='number' /></td><td></td></tr>"; 
											}
										}   
									}   
								}  
	        				}  
	        				aHtml +="<tr><td colspan='3'><label style='color:red'>该一级指标得分：</label><span id='sp_subTotal_"+i+"' style='color:red;font-weight:bold;'>未量化</span></td><td></td></tr>";
	        			}
	        			//aHtml += "<tr><td colspan='3'><a class='yw-btn bg-red' style='margin-left: 300px;' onclick=''>计算得分</a></td><td></td></tr>"
	        			$("#value_table").html(aHtml); 
	        		 }else{
	        		 	$("#dia_title").text("该模型未量化指标，请在量化指标模块完善");
						 $("#dialog1").dialog({
					      resizable: false,
					      height:150,
					      modal: true,
					      open: function (event, ui) {
			                  $(".ui-dialog-titlebar-close", $(this).parent()).hide();
			              },
					      buttons: {
					        "确定": function() {
					    		 $(this).dialog("close");
					        } 
					      }
					    }); 
	        		 }
	        	}else{
	        		$("#dia_title").text("加载量化模型指标失败");
					 $("#dialog1").dialog({
				      resizable: false,
				      height:150,
				      modal: true,
				      open: function (event, ui) {
		                  $(".ui-dialog-titlebar-close", $(this).parent()).hide();
		              },
				      buttons: {
				        "确定": function() {
				    		 $(this).dialog("close");
				        } 
				      }
				    });     	
	        	}	
	            
	        }
   		});
	} 
function getValue(obj,index,maxValue){
	if($(obj).val()>maxValue){ 
		 $("#dia_title").text("量化分值，不能超过标准分值");
			var mesDia = $("#dialog1").dialog({
		      resizable: false,
		      height:150,
		      modal: true,
		      open: function (event, ui) {
                  $(".ui-dialog-titlebar-close", $(this).parent()).hide();
              },
		      buttons: {
		        "确定": function() {
		    		 $(this).dialog("close");
		        } 
		      }
		    }); 
		 $(obj).val(maxValue); 
		 getValue(obj,index,maxValue);
	}else{
		var ipt_collect = $("#value_table tr[name='tr_"+index+"'] input[doc='ipt_value']");
		var subTotalValue = 0;
		$.each(ipt_collect,function(s,item){ 
			if(item.value != ""){
				if(!isNaN(Number(item.value))){
					subTotalValue = subTotalValue + Number(item.value); 
				}
			}
		});
		$("#sp_subTotal_"+index).text(subTotalValue+"分"); 
		
		var totalValue = 0;
		var totla_collect = $("#value_table input[doc='ipt_value']");
		$.each(totla_collect,function(s,item){ 
			if(item.value != ""){
				if(!isNaN(Number(item.value))){
					totalValue = totalValue + Number(item.value); 
				}
			}
		});
		$("#sp_total_value").text(totalValue+"分");
	}
} 
function overStatusClick(stus){
	if(stus==0){
		if(!$("#tr_IsValue").hasClass("displaynone")){
			$("#tr_IsValue").addClass("displaynone");
			$("#tr_IsValue_detail").addClass("displaynone");
		}  
		$("#hid_isVlaue").val(0);
	}else{
		if($("#tr_IsValue").hasClass("displaynone")){
			$("#tr_IsValue").removeClass("displaynone");
			$("#tr_IsValue_detail").removeClass("displaynone");
		}  
		$("#hid_isVlaue").val(1);
	} 
}
	function returnPage(){
		layer.confirm('当前项目资料尚未提交，是否离开当前页面？', {
			btn: ['确认','取消'] //按钮
		}, function(){//点击确认按钮调用
			layer.close(layer.confirm());//关闭当前弹出层
			window.location.href='<%=basePath%>manage/support/supportList.do';
		}, function(){
			
		});
	}
</script>
 </head> 
 <body>
<div class="con-right" id="conRight">
	<div class="fl yw-lump">
		<div class="yw-lump-title"> 												
				<i id="i_back" class="yw-icon icon-back" onclick="window.location.href='<%=basePath%>manage/support/supportList.do'"></i><span>中支立项中支完成</span>
		</div>
	</div>
	<div class="fl yw-lump mt10">
		<div class="yw-bi-rows">
			<div class="yw-bi-tabs mt5" id="ywTabs">
			<span class="yw-bi-now">上传资料</span>
				
			</div>
			<div class="fr">
				<!-- <span class="yw-btn bg-green mr26 hide" id="editBtn"  onclick="editTask();">编辑</span> -->
				
				
			</div>
		</div>
			<form id="itemInfoForm" name="itemInfoForm" >
				<div id="tab1" class="yw-tab">
					<table class="font16 taskTable"  cellpadding="0" cellspacing="0">
						<tr>
							<td width="15%" align="right">项目名称：</td>
							<td colspan="3">
								 <label>${Item.name } </label>     
							</td> 
						</tr>
						<tr>
							<td align="right">项目分类：</td>
							<td colspan="3">
							 <label>${Item.sType } </label>   
							</td>								
						</tr>
						<tr>
							<td align="right">立项时间：</td>
							<td colspan="3">
							 <label>${Item.preparerTimes } </label>   
							</td>								
						</tr>
						<tr>
							<td align="right" style="height:100px;">立项审批表、方案：</td>
							<td colspan="3">
							 <label>${ItemProcess.content } </label>  
							</td>		
						</tr> 
						<tr>
							<td align="right"style="height:80px;">附件列表：</td>
							<td colspan="3"> 
								<table style="width:100%;height:100%;min-height:80px;">
									<c:forEach var="fileItem" items="${ItemProcess.fileList }">
										<tr style="height:25px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
									</c:forEach> 
									<tr><td style="border:0px;"></td><tr>
								</table>
							</td>		
						</tr> 
						<tr>
							<td align="right" style="height:100px;">上传文件说明：</td>
							<td colspan="3"> 
								<label>${FileItemProcess.content } </label>  
							</td>	
						</tr>	 
						<tr>
							<td align="right">上传文件列表：</td>
							<td colspan="3"> 
								<table style="width:100%;height:100%;min-height:80px;">
									<c:forEach var="fileItem" items="${FileItemProcess.fileList }">
										<tr style="height:25px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
									</c:forEach> 
									<tr><td style="border:0px;"></td><tr>
								</table>
							</td>		
						</tr>
						<tr>
							<td align="right" style="height:40px;">是否量化指标：</td>
							<td colspan="3">  
                            	<input type="hidden" id="hid_itemId" value="${Item.id }" /> 
                            	<input type="hidden" id="hid_isVlaue" value="0" />
								<label><input type="radio" name="isOver" value="0" checked="checked"   onclick="overStatusClick(0);" />不量化</label> 
								<label><input type="radio" name="isOver" value="1"  onclick="overStatusClick(1);" />量化</label>
							 </td>	
						</tr> 
						<tr id="tr_IsValue" class="displaynone">
							<td align="right" style="height:70px;" >选择量化模型：</td>
							<td colspan="3">   
								<select id="valueTypeId" style="width:254px;height:35px;" onchange="gradeChange()">
									<option value="-1">=请选择量化模型=</option>									
									<c:forEach var="item" items="${GradeSchemeList}">
										<option value="${item.id}" >${item.name}</option>
									</c:forEach> 
								</select> 	
								<label style='color:red'>量化指标总得分：</label><span id='sp_total_value' style='color:red;font-weight:bold;'>未量化</span>
							 </td>	
						</tr>
						<tr id="tr_IsValue_detail" class="displaynone"> 
							<td align="right" style="height:270px;" >量化分值：</td>  
							<td colspan="2" id="testd">    
								<div style="width:100%; max-height:270px;overflow-x:hidden;">
									<table id="value_table">
										 
									</table> 
								</div>
							</td>			
						</tr> 
						<tr>
							<td></td>
							<td>
								<span class="yw-btn bg-red" style="margin-left: 10px;" id="saveBtn" onclick="saveItem();">提交</span>
								<span class="yw-btn bg-green" style="margin-left: 50px;margin-right: 10px;" onclick="returnPage();">返回</span>
							</td>							
						</tr> 
					</table>
				</div>
			</form>
		</div> 
	
	<div class="cl"></div>
</div>
<div class="cl"></div>
</div> 
</body>
</html>  
