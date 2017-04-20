<%@ page language="java" pageEncoding="utf-8"%>
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
    <title>用户管理</title>
    <script src="<%=basePath %>source/js/jquery.form.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $('#usersForm').bootstrapValidator({
                message: '录入数据项不能通过验证，请仔细检查',
                feedbackIcons: {
                    valid: 'glyphicon glyphicon-ok',
                    invalid: 'glyphicon glyphicon-remove',
                    validating: 'glyphicon glyphicon-refresh'
                },
                fields: {
                    account: {
                        message: '用户账号不能为空',
                        validators: {
                            notEmpty: {
                                message: '用户账号不能为空'
                            },
                            stringLength: {
                                min: 4,
                                max: 22,
                                message: '用户账号长度必须在4到22位之间'
                            },
                            regexp: {
                                regexp: /^[a-zA-Z0-9_]+$/,
                                message: '用户账号只能包含大写、小写、数字和下划线'
                            }
                        }
                    },
                    password: {
                        message: '登录密码不能为空',
                        validators: {
                            notEmpty: {
                                message: '登录密码不能为空'
                            },
                            stringLength: {
                                min: 4,
                                max: 22,
                                message: '登录密码长度必须在4到22位之间'
                            },
                            regexp: {
                                regexp: /^[a-zA-Z0-9_]+$/,
                                message: '登录密码只能包含大写、小写、数字和下划线'
                            }
                        }
                    },
                    name: {
                        message: '用户名不能为空',
                        validators: {
                            notEmpty: {
                                message: '用户名不能为空'
                            },
                            stringLength: {
                                min: 2,
                                max: 30,
                                message: '用户名长度必须在2到30位之间'
                            },
                            regexp: {
                                regexp: /^[^@\/\'\\\"#$%&\^\*]+$/,
                                message: '用户名不能包含特殊字符'
                            }
                        }
                    },
                    email: {
                        message: '请输入正确的邮箱地址',
                        validators: {
                            emailAddress: {
                                message: '邮箱地址格式有误'
                            }
                        }
                    },
                    phone: {
                        message: '请输入正确的电话号码',
                        validators: {
                            stringLength: {
                                min: 11,
                                max: 11,
                                message: '请输入11位手机号码'
                            },
                            regexp: {
                                regexp: /^1[3|5|7|8]{1}[0-9]{9}$/,
                                message: '请输入正确的手机号码'
                            }
                        }
                    }
                },
                submitHandler: function (validator, form, submitButton) {
                }
            })
        });
        $.validator.setDefaults({
            highlight: function (element) {
                $(element).closest('.form-group').removeClass('has-success').addClass('has-error');
            },
            success: function (element) {
                element.closest('.form-group').removeClass('has-error').addClass('has-success');
            },
            errorElement: "span",
            errorClass: "help-block m-b-none",
            validClass: "help-block m-b-none"
        });
        var status = true;
        function submitForm() {
            if (status){
                $('#usersForm').ajaxSubmit({
                    url: '<%=basePath%>system/user/jsonSaveOrUpdateUser.do',
                    type: "post",
                    dataType: "json",
                    success: function (item) {
                        if (item.code == returnResult.result_success) {
                            BootstrapDialog.show({
                                title: "操作提示",
                                message: item.message,
                                buttons: [{
                                    label: '确定', action: function (e) {
                                        window.location.href = '<%=basePath%>system/user/userList.do';
                                    }
                                }]
                            });
                        }
                        else {
                            BootstrapDialog.show({
                                title: "操作提示",
                                message: item.message,
                                buttons: [{
                                    label: '确定', action: function () {
                                        $.each(BootstrapDialog.dialogs, function (id, dialog) {
                                            status = true;
                                            dialog.close();
                                        });
                                    }
                                }]
                            });
                        }
                    }
                });
            }
            status = false;
            return false;
        }
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
                <a style="cursor: text;">用户管理</a>
            </li>
            <li>
                <strong style="cursor: text;">用户${users.id == 0?"新增":"编辑"}</strong>
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
                <form class="form-horizontal m-t" id="usersForm" autocomplete="off" method="post" onsubmit="return submitForm();" >
                    <input type="hidden" value="${users.id}" name="id" id="txtd" />
                    <c:if test="${users.id == 0}">
                        <div class="form-group">
                            <label class="control-label form-label-item">登录账号：</label>
                            <div class="col-sm-4">
                                <input id="account" name="account" class="form-control" placeholder="请输入登录账号" type="text" autocomplete="off" aria-required="true" aria-invalid="true" class="error" />
                            </div>
                        </div>
                        <div class="hr-line-dashed"></div>
                        <div class="form-group">
                            <label class="control-label form-label-item">登录密码：</label>
                            <div class="col-sm-4">
                                <input id="password" name="password" class="form-control" placeholder="请输入登录密码"  type="text" autocomplete="off"  onfocus="this.type='password'" aria-required="true" aria-invalid="true" class="error"/>
                            </div>
                        </div>
                        <div class="hr-line-dashed"></div>
                    </c:if>
                    <%--<div class="form-group">
                        <label class="control-label form-label-item">所属机构：</label>
                        <div class="col-sm-4">
                            <select class="form-control m-b" name="orgId">
                                <option value="1">选项 1</option>
                                <option value="2">选项 2</option>
                                <option value="3">选项 3</option>
                                <option value="4">选项 4</option>
                            </select>
                        </div>
                    </div>
                    <div class="hr-line-dashed"></div>--%>
                    <div class="form-group">
                        <label class="control-label form-label-item">用户姓名：</label>
                        <div class="col-sm-4">
                            <input id="name" name="name" type="text"  class="form-control"  placeholder="请输入真实姓名"  value="${users.name}" aria-required="true" aria-invalid="true" class="error"/>
                        </div>
                    </div>
                    <div class="hr-line-dashed"></div>
                    <div class="form-group">
                        <label class="control-label form-label-item">手机号码：</label>
                        <div class="col-sm-4">
                            <input id="phone" name="phone" class="form-control" type="tel"  placeholder="请输入手机号码"  value="${users.phone}"<%-- aria-required="true" aria-invalid="true" class="error" --%> />
                        </div>
                    </div>
                    <div class="hr-line-dashed"></div>
                    <div class="form-group">
                        <label class="control-label form-label-item">电子邮箱：</label>
                        <div class="col-sm-4">
                            <input id="email" name="email" class="form-control" type="email"  placeholder="请输入电子邮箱"  value="${users.email}" <%--aria-required="true" aria-invalid="true" class="error" --%>/>
                        </div>
                    </div>
                    <div class="hr-line-dashed"></div>
                    <div class="form-group">
                        <label class="control-label form-label-item">用户性别：</label>
                        <div class="col-sm-4">
                            <div class="radio">
                                <label>
                                    <input type="radio" value="0" id="sex0" name="sex" <c:if test="${users.sex == 0}"> checked="checked"</c:if>>保密</label>
                            </div>
                            <div class="radio">
                                <label>
                                    <input type="radio" value="1" id="sex1" name="sex"  <c:if test="${users.sex == 1 || users.sex == null}"> checked="checked"</c:if>>男</label>
                            </div>
                            <div class="radio">
                                <label>
                                    <input type="radio" value="2" id="sex2" name="sex" <c:if test="${users.sex == 2}"> checked="checked"</c:if>>女</label>
                            </div>
                        </div>
                    </div>
                    <div class="hr-line-dashed"></div>
                    <div class="form-group displaynone">
                        <label class="control-label form-label-item">用户类型：</label>
                        <div class="col-sm-4">
                            <div class="radio">
                                <label>
                                    <input type="radio" value="1"  id="type1"  name="type" <c:if test="${users.type == 1 || users.type == null}"> checked="checked"</c:if>>系统管理员</label>
                            </div>
                            <div class="radio">
                                <label>
                                    <input type="radio" value="0" id="type0" name="type" <c:if test="${users.type == 0 }"> checked="checked"</c:if>>普通用户</label>
                            </div>
                        </div>
                    </div>
                    <div class="hr-line-dashed displaynone"></div>
                    <div class="form-group">
                        <label class="control-label form-label-item">用户角色：</label>
                        <div class="col-sm-4">
                            <c:forEach var="item" items="${roleList}" varStatus="status">
                                <c:if test="${status.index == 0}">
                                    <div class="radio">
                                        <label>
                                            <input type="radio" value="${item.id}"  id="role${item.id}" <c:if test="${users.roleId == item.id || users.roleId ==null }"> checked="checked"</c:if> name="roleId">${item.nameCn}</label>
                                    </div>
                                </c:if>
                                <c:if test="${status.index > 0}">
                                    <div class="radio">
                                        <label>
                                            <input type="radio" value="${item.id}"  id="role${item.id}"  name="roleId" <c:if test="${users.roleId == item.id }"> checked="checked"</c:if>>${item.nameCn}</label>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>
                    </div>
                    <div class="hr-line-dashed"></div>
                    <div class="form-group">
                        <label class="control-label form-label-item">用户状态：</label>
                        <div class="col-sm-4">
                            <div class="radio">
                                <label>
                                    <input type="radio" value="1"  id="status1"  name="status"  <c:if test="${users.status == 1 || users.status == null}"> checked="checked"</c:if>>启用</label>
                            </div>
                            <div class="radio">
                                <label>
                                    <input type="radio" value="2" id="status0" name="status" <c:if test="${users.status == 2}"> checked="checked"</c:if>>禁用</label>
                            </div>
                        </div>
                    </div>
                    <div class="hr-line-dashed"></div>
                    <div class="form-group">
                        <label class="control-label form-label-item"></label>
                        <div class="col-sm-4" style="text-align: center">
                            <button class="btn btn-primary"  type="submit" >保存</button>
                            <button class="btn btn-active" style="margin-left: 30px;" onclick="window.location.href = '<%=basePath%>system/user/userList.do'">取消</button>
                        </div>
                    </div>
                    <div class="hr-line-dashed"></div>
                </form>
            </div>
        </div>
    </div>
</div>

</body>
</html>
