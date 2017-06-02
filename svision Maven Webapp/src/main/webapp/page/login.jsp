<%@ page language="java" pageEncoding="utf-8"%>
<%@taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
	String url = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";

%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<META http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no' name='viewport' />
	<title>电子监察平台-登录</title>
	<link type="text/css" href="<%=basePath%>source/css/base.css" rel="stylesheet"/>
	<link type="text/css" href="<%=basePath%>source/css/global.css" rel="stylesheet"/>
	<link type="text/css" href="<%=basePath%>source/js/easyUI/themes/default/easyui.css" rel="stylesheet"/>
	<link type="text/css" href="<%=basePath%>source/js/easyUI/themes/icon.css" rel="stylesheet"/>
	<link rel="shortcut icon" href="<%=basePath%>source/images/favicon.ico" type="image/x-icon" />
	<script type="text/javascript" src="<%=basePath%>source/js/jquery-1.11.2.min.js"></script>
	<script src="<%=basePath%>source/js/easyUI/jquery.easyui.min.js" type="text/javascript"></script>
	<script src="<%=basePath%>source/js/easyUI/easyui-lang-zh_CN.js" type="text/javascript"></script>
	<script src="<%=basePath%>source/js/common/validate.js"></script>
	<script src="<%=basePath%>source/js/login/pw.js"></script>
	<script type="text/javascript">
		var baseurl = '<%=url%>';
		$(document).ready(function() { 
			//加载机构树
		 	$("#orgParentTree").combotree({
				 	 url: '<%=basePath %>loadOrganTreeList.do',  
	  				 required: false, //是否必须
	  				 //multiple:true,  //是否支持多选  				  
	  				 editable:false, //是否支持用户自定义输入	
	  				 cascadeCheck:false,  				 		 
	  				 onSelect:function(record){ // 	当节点被选中时触发。 
	  				 	$('#loginName').combobox({  
						    url:'<%=basePath %>loadUserListByOrgId.do?orgId='+record.id,
						    valueField:'account',  
						    textField:'name',
						    onLoadSuccess:function(){
						    	var sess= $.trim($("#hid_loginName").val());
						    	if(sess.length>0){
							    	var datas = $('#loginName').combobox("getData");
							    	if(datas.length>0){
							    		$.each(datas,function(index,obj){
							    			if(obj.account == sess){
							    				$('#loginName').combobox("setValue",sess);
							    				GetPwdAndChkByUserAccount(sess);
							    			}
							    		});
							    	}else{
							    	   	$('#loginName').combobox("setText","=请选择登录用户=");
							    	}
						    	}else{
						    	   	$('#loginName').combobox("setText","=请选择登录用户=");
						    	}
						    },
						    onSelect:function(urec){ // 	当节点被选中时触发。 
			  				 	 $("#hid_loginName").val(urec.account);
			  				 } 
						});  
	  				 },
	  				 onBeforeExpand:function(node){ //节点展开前触发，返回 false 则取消展开动作。
	  				 	$("#orgParentTree").combotree('tree').tree('options').url = '<%=basePath %>loadOrganTreeList.do?pid='+ node.id;
	  				 },
	  				 onLoadSuccess:function(){ //当数据加载成功时触发。 
	   				 	$("#orgParentTree").combotree("setText","=请选择所属机构=");  
	  				 }
			});	
			$('#loginName').combobox("setText","=请选择登录用户=");
			//针对IE不支持placeholder的处理
			var p2 = document.getElementById("password").getAttribute("placeholder");
			if(p2!=""){
				$("#password").hide().after('<input type="text" class="login-input login-pwd easyui-validatebox" name="password2" id="password2" value="请输入密码" />');
			}
			$("#password2").focus(function(){
				$(this).hide();
				$("#password").show().focus();
			});
			$("#password").blur(function(){
				var v = $(this).val();
				if(v == ""){
					$(this).hide();
					$("#password2").show();
				}
			});

			/* var p1 = document.getElementById("loginName").getAttribute("placeholder");
			$("#loginName").val(p1).focus(function(){
				if($(this).val()==p1){
					$(this).val("");
				}
			}).blur(function(){
				var v = $(this).val();
				if(v == ""){
					$(this).val(p1);
				}
			});
			// 在这里写你的代码...
			$("#loginName").keypress(function(e){
				$("#login-alert").hide();
				if(e.keyCode == 13){
					$("#password").focus();
				}
			}); */
			$("#password").keydown(function(e){
				$("#login-alert").hide();
				if(e.keyCode == 13){
					login();
				}
			});  
		});
		function loginCheck(obj){
			var ck = $(obj).parent().find("input[type='checkbox']");
			if($(obj).hasClass("yw-checkbox-true")){
				$(obj).removeClass("yw-checkbox-true");
				ck.attr("value","false");
			}else{
				$(obj).addClass("yw-checkbox-true");
				ck.attr("value","true");
			}
		}
		function remeberMe(obj){
			var ik = $(obj).parent().find("i[doc='loginCheckFlag']");
			if(ik.hasClass("yw-checkbox-true")){
				ik.removeClass("yw-checkbox-true");
				$(obj).attr("value","false");
			}else{
				ik.addClass("yw-checkbox-true");
				$(obj).attr("value","true");
			}
		}
		function login(){

			if ($('#loginForm').form('validate')) {
				$('#loginForm').form('submit', {
					url:"userLogin.do",
					success:function(data){
						var item = eval("(" + data + ")");
						if(item.code == 200){
							SetPwdAndChk();
							/* window.location.href =baseurl+item.gotoUrl; */
							window.location.href = baseurl +"moudle/model/modelSelect.do"
							$("#login-alert").html("");
							$("#login-alert").hide();
						}
						else{
							$("#login-alert").html("<span style='color:red;'>"+item.message+"</span>");
							$("#login-alert").show();
						}
					}
				});
			}
		}
	</script>
</head>

<body class="login">
<div style="width:100%">
	<ul class="head-ul mr300 mt123"> 
	</ul>
</div>
<div class="box">
	<div class="logo">
		<div>
			<img src="<%=basePath%>source/images/lo_title.jpg"  /> 
		</div> 
	</div>
	<form method="post"  id="loginForm" >
		<div class="login-panel"> 
			<div class="fl login-left"> 
				<div class="fl login-title">登录</div> 
				<div class="fl panel">
					<p class="login-rows mt30">
						<input id="orgParentTree"  style="width:239px;height:38px;" checkbox="true"  class="easyui-combotree" />
					</p>
					<p class="login-rows mt30">
						<input type="hidden" id="hid_loginName" />
						<input id="loginName" name="account" class="easyui-combobox"  style="width:239px;height:38px;" />  
						<%-- <input type="text" name="account" id="loginName" class="login-input login-name easyui-validatebox" placeholder="用户名"  validType="Length[4,22]" data-options="required:true" value="<shiro:principal/>" onblur="GetPwdAndChk();"/> --%>
					</p>
					<p class="login-rows mt30">
						<input type="password" name="pwd" id="password" class="login-input login-pwd easyui-validatebox" placeholder="密码"  validType="Length[4,22]" data-options="required:true"/>
					</p>
					<p class="login-rows mt30">
						<label class="yw-checkbox">
							<i class="mt4 mr10"  doc="loginCheckFlag" onClick="loginCheck(this);" id="icheckspan"></i>
							<input type="checkbox" name="rememberMe" value="false" id="chkRememberPwd"><span  onclick="remeberMe(this);">记住密码</span>
						</label>
					</p>
					<div id="login-alert" class="login-rows" style="display:none;"></div>
					<p class="login-rows mt10">
						<span class="login-btn" onclick="login()">登 录</span>
					</p> 
				</div>
			</div>

			<div class="fl login-line"></div>
			<div class="fl login-right txt-center">
				<img src="<%=basePath%>source/images/gy_pic.jpg" class="twocode"/>
			</div>
		</div>
	</form>
	<div class="cl"></div>
</div>
</body>
</html>