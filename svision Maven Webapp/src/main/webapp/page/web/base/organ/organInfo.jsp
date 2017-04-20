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
            + path;
%>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <META http-equiv="X-UA-Compatible" content="IE=edge" />
    <link rel="shortcut icon" href="<%=basePath%>source/img/favicon.ico" type="image/x-icon" >
    <meta content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no' name='viewport' />
    <meta name="description" content="">
    <meta name="author" content="">
    <title>机构管理</title>
    <script type="text/javascript">
        $(document).ready(function () {

        });
    </script>

</head>

<body class="gray-bg">
<div class="row wrapper border-bottom white-bg page-heading" style="margin-top:25px; margin-bottom:25px;">
    <div class="col-lg-12">
        <h2>基础数据</h2>
        <ol class="breadcrumb">
            <li>
                <a href="<%=basePath%>server/introduction.do">主页</a>
            </li>
            <li>
                <a style="cursor: text;">机构管理</a>
            </li>
            <li>
                <strong style="cursor: text;">机构${user.id == 0?"新增":"编辑"}</strong>
            </li>
        </ol>
    </div>
</div>
<div class="row">
    <div class="col-sm-12">
        <div class="ibox float-e-margins" style=" background-color: #fff;">
            <div class="ibox-title" style="background-color:#22beef;">
                <h5 style="color:#fff;">用户信息</h5>
            </div>
            <div class="ibox-content">
                <form class="form-horizontal m-t" id="signupForm">
                    <div class="form-group">
                        <label class="control-label form-label-item">登录账号：</label>
                        <div class="col-sm-4">
                            <input id="firstname" name="firstname" class="form-control" type="text" aria-required="true" aria-invalid="true" class="error">
                        </div>
                    </div>
                    <div class="hr-line-dashed"></div>
                    <div class="form-group">
                        <label class="control-label form-label-item">登录密码：</label>
                        <div class="col-sm-4">
                            <input id="password" name="password" class="form-control" type="password">
                        </div>
                    </div>
                    <div class="hr-line-dashed"></div>
                    <div class="form-group">
                        <label class="control-label form-label-item">所属机构：</label>
                        <div class="col-sm-4">
                            <select class="form-control m-b" name="account">
                                <option>选项 1</option>
                                <option>选项 2</option>
                                <option>选项 3</option>
                                <option>选项 4</option>
                            </select>
                        </div>
                    </div>
                    <div class="hr-line-dashed"></div>
                    <div class="form-group">
                        <label class="control-label form-label-item">手机号码：</label>
                        <div class="col-sm-4">
                            <input id="lastname" name="lastname" class="form-control" type="text" >
                        </div>
                    </div>
                    <div class="hr-line-dashed"></div>
                    <div class="form-group">
                        <label class="control-label form-label-item">用户姓名：</label>
                        <div class="col-sm-4">
                            <input id="username" name="username" class="form-control" type="text" >
                        </div>
                    </div>
                    <div class="hr-line-dashed"></div>
                    <div class="form-group">
                        <label class="control-label form-label-item">电子邮箱：</label>
                        <div class="col-sm-4">
                            <input id="email" name="email" class="form-control" type="email">
                        </div>
                    </div>
                    <div class="hr-line-dashed"></div>
                    <div class="form-group">
                        <label class="control-label form-label-item">用户性别：</label>
                        <div class="col-sm-4">
                            <div class="radio">
                                <label>
                                    <input type="radio" checked="" value="option1" id="optionsRadios1" name="sex">保密</label>
                            </div>
                            <div class="radio">
                                <label>
                                    <input type="radio" value="option2" id="optionsRadios2" name="sex">男</label>
                            </div>
                            <div class="radio">
                                <label>
                                    <input type="radio" value="option3" id="optionsRadios3" name="sex">女</label>
                            </div>
                        </div>
                    </div>
                    <div class="hr-line-dashed"></div>
                    <div class="form-group">
                        <label class="control-label form-label-item">管理权限：</label>
                        <div class="col-sm-4">
                            <div class="radio">
                                <label>
                                    <input type="radio" checked="" value="option4"  name="userRole">系统管理员</label>
                            </div>
                            <div class="radio">
                                <label>
                                    <input type="radio" value="option5" id="optionsRadios5" name="userRole">普通用户</label>
                            </div>

                        </div>
                    </div>
                    <div class="hr-line-dashed"></div>
                    <div class="form-group">
                        <div class="col-sm-8">
                            <button class="btn btn-primary" style="margin-left: 240px;">保存</button>
                            <button class="btn btn-active" style="margin-left: 30px;" onclick="javascript:history.back();">取消</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
</body>
</html>
