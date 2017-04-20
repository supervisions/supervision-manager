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
    <title>角色管理</title>
    <script src="<%=basePath %>source/js/jquery.form.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $('#roleForm').bootstrapValidator({
                message: '录入数据项不能通过验证，请仔细检查',
                feedbackIcons: {
                    valid: 'glyphicon glyphicon-ok',
                    invalid: 'glyphicon glyphicon-remove',
                    validating: 'glyphicon glyphicon-refresh'
                },
                fields: {
                    nameCn: {
                        message: '角色中文名称不能为空',
                        validators: {
                            notEmpty: {
                                message: '角色中文名称不能为空'
                            },
                            stringLength: {
                                min: 2,
                                max: 30,
                                message: '角色中文名称长度必须在2到30位之间'
                            },
                            regexp: {
                                regexp: /^[^@\/\'\\\"#$%&\^\*]+$/,
                                message: '角色中文名称不能包含特殊字符'
                            }
                        }
                    },
                    name: {
                        message: '角色简称不能为空',
                        validators: {
                            notEmpty: {
                                message: '角色简称不能为空'
                            },
                            stringLength: {
                                min: 2,
                                max: 30,
                                message: '角色简称长度必须在2到30位之间'
                            },
                            regexp: {
                                regexp: /^[^@\/\'\\\"#$%&\^\*]+$/,
                                message: '角色简称不能包含特殊字符'
                            }
                        }
                    },
                    description: {
                        message: '',
                        validators: {
                            regexp: {
                                regexp: /^[^@\/\'\\\"#$%&\^\*]+$/,
                                message: '角色描述不能包含特殊字符'
                            }
                        }
                    }
                },
                submitHandler: function (validator, form, submitButton) {
                }
            });
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
        function submitForm(){
            if (status){
                $('#roleForm').ajaxSubmit({
                    url:'<%=basePath%>system/role/jsonSaveOrUpdateRole.do',
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        if (data.code == returnResult.result_success) {
                            BootstrapDialog.show({
                                title: "操作提示",
                                message: data.message,
                                buttons: [{
                                    label: '确定', action: function (e) {
                                        window.location.href = '<%=basePath%>system/role/roleList.do';
                                    }
                                }]
                            });
                        }
                        else {
                            BootstrapDialog.show({
                                title: "操作提示",
                                message: data.message,
                                buttons: [{
                                    label: '确定', action: function () {
                                        status = true;
                                        $.each(BootstrapDialog.dialogs, function (id, dialog) {
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
        function checkRoleType(value){
            var uid = $("#txtd").val();
            if(uid==0){
                return;
            }
            var roleType = $("#hid_roleType").val();
            if(roleType != value){
                BootstrapDialog.show({title:"操作提示", message: "更改用户角色，系统将会清除原有角色的相关权限，修改之后需要重新授权"});
            }
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
                <a style="cursor: text;">角色管理</a>
            </li>
            <li>
                <strong style="cursor: text;">角色${roles.id == 0?"新增":"编辑"}</strong>
            </li>
        </ol>
    </div>
</div>
<div class="row">
    <div class="col-sm-12">
        <div class="ibox float-e-margins" style=" background-color: #fff;">
            <div class="ibox-title" style="background-color:#22beef;">
                <h5 style="color:#fff;">角色信息</h5>
            </div>
            <div class="ibox-content">
                <form class="form-horizontal m-t" id="roleForm" autocomplete="off"  onsubmit="return submitForm();"  method="post">
                    <input type="hidden" value="${roles.id}" name="id" id="txtd" />
                    <div class="form-group">
                        <label class="control-label form-label-item">中文名称：</label>
                        <div class="col-sm-4">
                            <input id="nameCn" name="nameCn" type="text"  class="form-control"  placeholder="请输入角色中文名称"  value="${roles.nameCn}" aria-required="true" aria-invalid="true" class="error"/>
                        </div>
                    </div>
                    <div class="hr-line-dashed"></div>
                    <div class="form-group">
                        <label class="control-label form-label-item">简写名称：</label>
                        <div class="col-sm-4">
                            <input id="name" name="name" type="text"  class="form-control"  placeholder="请输入角色简写名称"  value="${roles.name}" aria-required="true" aria-invalid="true" class="error"/>
                        </div>
                    </div>
                    <div class="hr-line-dashed"></div>
                    <div class="form-group">
                        <label class="control-label form-label-item">角色描述：</label>
                        <div class="col-sm-4">
                            <input id="description" name="description" class="form-control" type="text"  placeholder="请输入角色描述"  value="${roles.description}" aria-required="true" aria-invalid="true" class="error" />
                        </div>
                    </div>
                    <div class="hr-line-dashed"></div>
                    <div class="form-group">
                        <label class="control-label form-label-item">角色类型：</label>
                        <div class="col-sm-4">
                            <input type="hidden" id="hid_roleType" value="${roles.type}" />
                            <div class="radio">
                                <label>
                                    <input type="radio" value="0"  id="type0"  name="type" onclick="checkRoleType(0);" <c:if test="${roles.type == 0 || roles.type == null}"> checked="checked"</c:if>>用户类型</label>
                            </div>
                            <div class="radio">
                                <label>
                                    <input type="radio" value="1" id="type1" name="type"  onclick="checkRoleType(1);"  <c:if test="${roles.type == 1}"> checked="checked"</c:if>>管理员类型</label>
                            </div>
                        </div>
                    </div>
                    <div class="hr-line-dashed"></div>
                    <div class="form-group displaynone">
                        <label class="control-label form-label-item">角色状态：</label>
                        <div class="col-sm-4">
                            <div class="radio">
                                <label>
                                    <input type="radio" value="1"  id="status1"  name="status"  <c:if test="${roles.status == 1 || roles.status == null}"> checked="checked"</c:if>>启用</label>
                            </div>
                            <div class="radio">
                                <label>
                                    <input type="radio" value="0" id="status0" name="status" <c:if test="${roles.status == 0}"> checked="checked"</c:if>>禁用</label>
                            </div>
                        </div>
                    </div>
                    <div class="hr-line-dashed displaynone"></div>
                    <div class="form-group">
                        <label class="control-label form-label-item"></label>
                        <div class="col-sm-4" style="text-align: center">
                            <button class="btn btn-primary" type="submit">保存</button>
                            <button class="btn btn-active" style="margin-left: 30px;" onclick="window.location.href = '<%=basePath%>system/role/roleList.do'">取消</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
</body>
</html>
