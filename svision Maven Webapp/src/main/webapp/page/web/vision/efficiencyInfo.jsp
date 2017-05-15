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
    
    <title>效能监察</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta name="viewport"
	content="width=device-width, initial-scale=1, minimum-scale=1  ,maximum-scale=1, user-scalable=no" /> 
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	<script type="text/javascript">
		$(document).ready(function(){
			$("#cmbParentArea").combotree({
				 url: 'area/jsonLoadAreaTreeList.do',  
   				 required: false,
   				 onSelect:function(record){ 
 				 	 	$("#areaId").val(record.id); 
   				 },
   				 onBeforeExpand:function(node){
   				 	$("#cmbParentArea").combotree('tree').tree('options').url = 'area/jsonLoadAreaTreeList.do?pid='+ node.id;
   				 },
   				 onLoadSuccess:function(){
   				 	var deviceId = $("#deviceId").val();
   				 	
   				 	if(deviceId>0){
   				 		//var pId = $("#areaId").val();
   				 		var areaName = $("#areaName").val();
   				 		$("#cmbParentArea").combotree("setText",areaName);
   				 		
   				 	}else{
						//$("#cmbParentArea").combotree("disable",true);
	   				 	$("#cmbParentArea").combotree("setText","=请选择所属区域=");
					}
   				 }
			});
		});
		  
		
		function saveDevicePoint(obj) {
			var areaId = $("#cmbParentArea").combotree("getValue");
			var flag = $("#hid_flag").val();
			$("#areaId").val(areaId);
			if ($('#devicePointForm').form('validate')) {
				$(obj).attr("onclick", "");
				showProcess(true, '温馨提示', '正在提交数据...');
				$('#devicePointForm').form('submit',{
					success : function(data) {
						showProcess(false);
						data = $.parseJSON(data);
						if (data.code == 0) {
							$.messager.alert('保存信息',data.message,'info',
											function() {
												window.location.href = "device/deviceList.do?flag="+flag;
											});
							//$("#i_back").click();
						} else {
							$.messager.alert('错误信息',
									data.message, 'error',
									function() {
									});
							$(obj).attr("onclick",
									"saveDevicePoint(this);");
						}
					}
				});
			}
		}
	</script>
  </head>
  
  <body>
    <div class="con-right" id="conRight">
		<div class="fl yw-lump">
			<div class="yw-lump-title">
				<i  id="i_back"  class="yw-icon icon-back" onclick="javascript:history.back();"></i>
				<span>项目列表</span> 			
			</div>
		</div>

		<div class="fl yw-lump mt10">
			<div class="yw-bi-rows">
				<div class="yw-bi-tabs mt5" id="ywTabs">
					<span class="yw-bi-now">基本信息</span>
				</div>
				<div class="fr">
					<span class="yw-btn bg-red mr26" id="saveBtn" onclick="saveDevicePoint(this);">保存</span> 
					<span class="yw-btn bg-green mr26"  onclick="$('#i_back').click();">返回</span>
				</div>
			</div>
			<div>
	<form id="devicePointForm" name="devicePointForm" action="device/jsonSaveOrUpdatePoint.do" method="post">
		<div id="tab1" class="yw-tab">
			<table class="yw-cm-table font16">
				<tr>	
					<td align="right" width="12%">监察项目：</td>
					<td  align="left" ><input  name="pointName" doc="pointInfo"  onblur="valueTrim(this);"   type="text" value="${Device.pointName}" class="easyui-validatebox" required="true" validType="Length[1,100]" style="width:354px;height:28px;" />
					<span style="color:red">*</span>
					</td>
					
				</tr>
				
				<tr>	
					<td align="right">监察内容：</td>
					<td  align="left" ><input  name="type" doc="pointInfo"  onblur="valueTrim(this);"   type="text" value="${Device.type}" class="easyui-validatebox"  validType="Length[1,30]" style="width:354px;height:28px;" />
					<span style="color:red">*</span>
					</td>
				</tr>
				<tr>	
					<td align="right">规定完成时间：</td>
					<td  align="left" ><input  name="pointNumber" doc="pointInfo" onblur="valueTrim(this);"    type="text" value="${Device.pointNumber}" class="easyui-validatebox" required="true" validType="Length[1,100]" style="width:354px;height:28px;" />
					<span style="color:red">*</span>
					</td> 
			    </tr>
				<tr>
					<td align="right">是否分节点监察：</td>
					<td  align="left" ><input  name="pointNaming" doc="pointInfo"  onblur="valueTrim(this);"   type="text" value="${Device.pointNaming}" class="easyui-validatebox" required="true" validType="Length[1,250]" style="width:354px;height:28px;" />
					<span style="color:red">*</span>
					</td> 
			    </tr>
				<tr>	
					<td align="right">被监察对象:</td>
					<td  align="left" ><input  name="ipAddress" doc="pointInfo"  type="text" value="${Device.ipAddress}" class="easyui-validatebox" required="true" validType="IP" style="width:354px;height:28px;" />
					<span style="color:red">*</span> 
					</td> 
				</tr>
				<tr>	
					<td align="right">责任领导:</td>
					<td  align="left" ><input  name="port" doc="pointInfo"  type="text" value="${Device.port}" class="easyui-validatebox" required="true" validType="number" style="width:354px;height:28px;" />
					<span style="color:red">*</span>
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
  </body>
</html>
