<%@ page language="java" pageEncoding="utf-8"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
	<link rel="shortcut icon" href="<%=basePath%>source/img/favicon.ico" type="image/x-icon" >
	<meta content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no' name='viewport' />
	<meta name="description" content="">
	<meta name="author" content="">
	<title>云端超级应用平台-登录</title>
	<link rel="stylesheet" type="text/css" href="<%=basePath %>source/css/cloud-admin.css" >

	<link href="<%=basePath %>source/font-awesome/css/font-awesome.min.css" rel="stylesheet">
	<script src="<%=basePath %>source/js/jquery-2.0.3.min.js"></script>
	<script src="<%=basePath %>source/js/jquery.cookie.js"></script>
	<!-- JQUERY UI-->
	<script src="<%=basePath %>source/js/jquery-ui-1.10.3.custom.min.js"></script>
	<!-- BOOTSTRAP -->
	<script src="<%=basePath %>source/js/bootstrap.min.js"></script>


	<!-- UNIFORM -->
	<script type="text/javascript" src="<%=basePath %>source/js/uniform/jquery.uniform.min.js"></script>
	<!-- BACKSTRETCH -->
	<script type="text/javascript" src="<%=basePath %>source/js/jquery.backstretch.min.js"></script>
	<!-- CUSTOM SCRIPT -->
	<script src="<%=basePath %>source/js/script.js"></script>
	<script src="<%=basePath %>source/js/jquery.form.js"></script>
	<script src="<%=basePath %>source/js/login/pw.js"></script>
	<script src="<%=basePath %>source/js/common.js"></script>
	<!-- DATE RANGE PICKER -->

	<!-- UNIFORM -->
	<link rel="stylesheet" type="text/css" href="<%=basePath %>source/js/uniform/css/uniform.default.min.css" />
	<script type="text/javascript">
		var baseurl = '<%=url%>';
		$(document).ready(function() {
			App.setPage("login_bg");  //Set current page
			App.init(); //Initialise plugins and elements
			// 在这里写你的代码...
			$("#loginName").keypress(function(e){
				$("#login-alert").hide();
				if(e.keyCode == constantsValue.enterValue){
					$("#password").focus();
				}
			});
			$("#password").keydown(function(e){
				$("#login-alert").hide();
				if(e.keyCode == constantsValue.enterValue){
					login();
				}
			});
			if ($.cookie !=  undefined && $.cookie("rmbUser") == "true") {
				var obj =  $("#ck_remme");
				$(obj).removeAttr("value");
				$(obj).attr("value","true");
				$(obj).parent().addClass("checked");
				$(obj).parent().parent().addClass("focus");
				$("#loginName").val($.cookie("username"));
				$("#password").val($.cookie("password"));
			}
		});
		function loginCheck(){
			var obj =  $("#ck_remme");
			if(document.getElementById('ck_remme').value == "false"){
				$(obj).removeAttr("value");
				$(obj).attr("value","true");
				$(obj).parent().addClass("checked");
				$(obj).parent().parent().addClass("focus");
			}else{
				$(obj).removeAttr("value");
				$(obj).attr("value","false");
				$(obj).parent().removeClass("checked");
				$(obj).parent().parent().removeClass("focus");
			}
		}
		function swapScreen(id) {
			jQuery('.visible').removeClass('visible animated fadeInUp');
			jQuery('#'+id).addClass('visible animated fadeInUp');
		}
		function login(){
			$('#loginForm').submit(function(data){
				$('#loginForm').ajaxSubmit({
					success: function (data) {
						var item = eval("(" + data + ")");
						if(item.code == returnResult.result_success){
							SetPwdAndChk();
							window.location.href =baseurl+item.gotoUrl;
						}
						else{
							$("#login-alert").html("<br /><span style='color:white;'>"+item.message+"</span>");
							$("#login-alert").show();
						}
					}
				});
				return false;
			});
		}
	</script>
</head>

<body class="login">
	<section id="page">
		<!-- HEADER -->

		<!--/HEADER -->
		<!-- LOGIN -->
		<section id="login_bg" class="visible">
			<div class="container">
				<div class="row">
					<div class="col-md-4 col-md-offset-4">
						<div class="login-box">
							<h2 class="bigintro" style="max-width:350px; text-align:center;"><img src="<%=basePath %>source/img/login/logo.png" width="99%;"></h2>
							<div class="divide-40"></div>
							<form role="form" id="loginForm"  method="post" action="<%=basePath%>userLogin.do">
								<div class="form-group">
									<label for="exampleInputEmail1">用户名</label>
									<i class="fa fa-user"></i>
									<input type="text"  name="account"  onfocus="javascript:$('#login-alert').hide();" class="form-control" id="loginName"  onblur="GetPwdAndChk();"  >
								</div>
								<div class="form-group">
									<label for="exampleInputPassword1">密码</label>
									<i class="fa fa-lock"></i>
									<input type="password"  name="password"   onfocus="javascript:$('#login-alert').hide();" class="form-control" id="password" >
								</div>
								<div>
									<label class="checkbox" onclick="loginCheck();"> <input id="ck_remme" name="rememberMe"  type="checkbox" class="uniform" value="false"  > 记住密码</label>

									<div class="login-helpers"  style="display:none;">
										<strong><a href="#" onClick="swapScreen('forgot_bg');return false;">忘记密码</a> </strong>

									</div>
									<button onclick="login();" class="btn btn-danger">登录</button>
									<div id="login-alert"  style="display:none; text-align: center;"></div>
								</div>
							</form>
							<!-- SOCIAL LOGIN -->
							<div class="divide-20"></div><div class="divide-20"></div>
							<div class="center" style="display:none;">
								<strong>还没有账号？ <a href="#" onclick="swapScreen('register_bg');return false;">
									立即注册!</a></strong>
							</div>

							<!-- /SOCIAL LOGIN -->

						</div>
					</div>
				</div>
			</div>
		</section>
		<!--/LOGIN -->
		<!-- REGISTER -->
		<section id="register_bg" class="font-400">
			<div class="container">
				<div class="row">
					<div class="col-md-4 col-md-offset-4">
						<div class="login-box">
							<h2 class="bigintro">用户注册</h2>
							<div class="divide-40"></div>
							<form role="form">
								<div class="form-group">
									<label for="exampleInputName">公司名字</label>
									<i class="fa fa-font"></i>
									<input type="text" class="form-control" id="exampleInputName" >
								</div>
								<div class="form-group">
									<label for="exampleInputUsername">用户名</label>
									<i class="fa fa-user"></i>
									<input type="text" class="form-control" id="exampleInputUsername" >
								</div>
								<div class="form-group">
									<label for="exampleInputEmail1">邮箱</label>
									<i class="fa fa-envelope"></i>
									<input type="email" class="form-control" id="exampleInputEmail1" >
								</div>
								<div class="form-group">
									<label for="exampleInputPassword1">密码</label>
									<i class="fa fa-lock"></i>
									<input type="password" class="form-control" id="exampleInputPassword1" >
								</div>
								<div class="form-group">
									<label for="exampleInputPassword2">确认密码</label>
									<i class="fa fa-check-square-o"></i>
									<input type="password" class="form-control" id="exampleInputPassword2" >
								</div>
								<div>
									<label class="checkbox"> <input type="checkbox" class="uniform" value=""> 我同意 <a href="#">Terms of Service</a> and <a href="#">Privacy Policy</a></label>
									<button type="submit" class="btn btn-success">Sign Up</button>
								</div>
							</form>
							<!-- SOCIAL REGISTER -->
							<div class="divide-20"></div>
							<div class="center">
								<strong>Or register using your social account</strong>
							</div>
							<div class="divide-20"></div>
							<div class="social-login center">
								<a class="btn btn-primary btn-lg">
									<i class="fa fa-facebook"></i>
								</a>
								<a class="btn btn-info btn-lg">
									<i class="fa fa-twitter"></i>
								</a>
								<a class="btn btn-danger btn-lg">
									<i class="fa fa-google-plus"></i>
								</a>
							</div>
							<!-- /SOCIAL REGISTER -->
							<div class="login-helpers">
								<a href="#" onClick="swapScreen('login_bg');return false;"> Back to Login</a> <br>
							</div>
						</div>
					</div>
				</div>
			</div>
		</section>
		<!--/REGISTER -->
		<!-- FORGOT PASSWORD -->
		<section id="forgot_bg">
			<div class="container">
				<div class="row">
					<div class="col-md-4 col-md-offset-4">
						<div class="login-box">
							<h2 class="bigintro">找回密码</h2>
							<div class="divide-40"></div>
							<form role="form">
								<div class="form-group">
									<label for="exampleInputEmail1">请输入您的注册邮箱</label>
									<i class="fa fa-envelope"></i>
									<input type="email" class="form-control" id="exampleInputEmail1" >
								</div>
								<div>
									<button type="submit" class="btn btn-info">新密码已经发到您的邮箱</button>
								</div>
							</form>
							<div class="login-helpers">
								<a href="#" onClick="swapScreen('login_bg');return false;">返回登录页面</a> <br>
							</div>
						</div>
					</div>
				</div>
			</div>
		</section>
		<!-- FORGOT PASSWORD -->
	</section>
</body>
</html>