<%@ page language="java" pageEncoding="utf-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>404错误页面</title>
	<script type="text/javascript" src="<%=basePath %>source/js/jquery-2.0.3.min.js"></script>
</head>

<body>
您没有权限访问该页面（404），系统将在<font color="red"><span id="timecount"> </span></font>秒后自动登录，您也可以点击<a href="<%=basePath %>index.do" target="_top">这里</a>重新登录
<script type="text/javascript">
	var count = 5;
	$(document).ready(function(){
		$("#timecount").html(count);

		window.setInterval(showtimeCount,1000);
	});
	function showtimeCount()
	{
		count--;
		if(count == 0)
		{
			top.location.href="<%=basePath %>index.do";
		}else{
			$("#timecount").html(count);
		}
	}
</script>
</body>
</html>
