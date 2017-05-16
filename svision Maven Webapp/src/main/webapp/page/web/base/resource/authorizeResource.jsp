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
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/source/js/easyUI/themes/default/easyui.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/source/js/easyUI/themes/icon.css"> 
	<script type="text/javascript" src="${pageContext.request.contextPath}/source/js/easyUI/jquery.easyui.min.js"></script>
	<script src="${pageContext.request.contextPath}/source/js/easyUI/easyui-lang-zh_CN.js"></script>
	<script src="${pageContext.request.contextPath}/source/js/common/validate.js"></script>
	<script src="${pageContext.request.contextPath}/source/js/common/common.js"></script>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <META http-equiv="X-UA-Compatible" content="IE=edge" />
    <link rel="shortcut icon" href="<%=basePath%>source/img/favicon.ico" type="image/x-icon" >
    <meta content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no' name='viewport' />
    <meta name="description" content="">
    <title>资源管理</title>
    <meta name="author" content="">
    <script src="<%=basePath %>source/js/jquery.form.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $('#resourceForm').bootstrapValidator({
                message: '录入数据项不能通过验证，请仔细检查',
                feedbackIcons: {
                    valid: 'glyphicon glyphicon-ok',
                    invalid: 'glyphicon glyphicon-remove',
                    validating: 'glyphicon glyphicon-refresh'
                },
                fields: {
                    name: {
                        message: '资源名称不能为空',
                        validators: {
                            notEmpty: {
                                message: '资源名称不能为空'
                            },
                            stringLength: {
                                min: 2,
                                max: 100,
                                message: '资源名称长度必须在2到100位之间'
                            },
                            regexp: {
                                regexp: /^[^@\/\'\\\"#$%&\^\*]+$/,
                                message: '资源名称不能包含特殊字符'
                            }
                        }
                    },
                    src: {
                        message: '资源地址不能为空',
                        validators: {
                            notEmpty: {
                                message: '资源地址不能为空'
                            },
                            stringLength: {
                                min: 2,
                                max: 100,
                                message: '资源地址长度必须在2到100位之间'
                            }
                        }
                    },
                    key: {
                        message: '资源关键字不能为空',
                        validators: {
                            notEmpty: {
                                message: '资源关键字不能为空'
                            },
                            stringLength: {
                                min: 2,
                                max: 100,
                                message: '资源关键字长度必须在2到100位之间'
                            },
                            regexp: {
                                regexp: /^[^@\/\'\\\"#$%&\^\*]+$/,
                                message: '资源关键字不能包含特殊字符'
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
            if (status) {
                $('#resourceForm').ajaxSubmit({
                    url:'<%=basePath%>system/resource/jsonSaveOrUpdateResource.do',
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        var item = eval("(" + data + ")");
                        if (item.code == returnResult.result_success) {
                            BootstrapDialog.show({
                                title: "操作提示",
                                message: item.message,
                                buttons: [{
                                    label: '确定', action: function (e) {
                                        window.location.href = '<%=basePath%>system/resource/resourceList.do';
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
                <a style="cursor: text;">资源管理</a>
            </li>
            <li>
                <strong style="cursor: text;">资源${resourceConfigs.id == 0?"新增":"编辑"}</strong>
            </li>
        </ol>
    </div>
</div>
<div class="row">
    <div class="col-sm-12">
        <div class="ibox float-e-margins" style=" background-color: #fff;">
            <div class="ibox-title" style="background-color:#22beef;">
                <h5 style="color:#fff;">资源信息</h5>
            </div>
            <div class="ibox-content">
                <form class="form-horizontal m-t" id="resourceForm" autocomplete="off"  onsubmit="return submitForm();" method="post">
                    <input type="hidden" value="${resourceConfigs.id}" name="id" id="txtd" />
                    <div class="form-group">
                        <label class="control-label form-label-item">资源名称：</label>
                        <div class="col-sm-4">
                            <input id="name" name="name" type="text"  class="form-control"  placeholder="请输入资源名称"  value="${resourceConfigs.name}" aria-required="true" aria-invalid="true" class="error"/>
                        </div>
                    </div>
                    <div class="hr-line-dashed"></div>
                    <div class="form-group">
                        <label class="control-label form-label-item">资源地址：</label>
                        <div class="col-sm-4">
                            <input id="src" name="src" class="form-control" type="text"  placeholder="请输入资源地址"  value="${resourceConfigs.src}" aria-required="true" aria-invalid="true" class="error" />
                        </div>
                    </div>
                    <div class="hr-line-dashed"></div>
                    <div class="form-group">
                        <label class="control-label form-label-item">&nbsp;&nbsp;&nbsp;关键字：</label>
                        <div class="col-sm-4">
                            <input id="key" name="key" class="form-control" type="text"  placeholder="请输入资源关键字"  value="${resourceConfigs.key}"  />
                        </div>
                    </div>
                    <div class="hr-line-dashed"></div>
                    <div class="form-group">
                        <label class="control-label form-label-item">资源类型：</label>
                        <div class="col-sm-4">
                            <div class="radio">
                                <label>
                                    <input type="radio" value="0" id="type0" name="type" <c:if test="${resourceConfigs.type == 0 || resourceConfigs.type == null}"> checked="checked"</c:if>>方法</label>
                            </div>
                            <div class="radio">
                                <label>
                                    <input type="radio" value="1" id="type1" name="type"  <c:if test="${resourceConfigs.type == 1}"> checked="checked"</c:if>>页面</label>
                            </div>
                            <div class="radio">
                                <label>
                                    <input type="radio" value="2" id="type2" name="type" <c:if test="${resourceConfigs.type == 2}"> checked="checked"</c:if>>按键</label>
                            </div>
                        </div>
                    </div>
                    <div class="hr-line-dashed"></div>
                    <div class="form-group">
                        <label class="control-label form-label-item">资源状态：</label>
                        <div class="col-sm-4">
                            <div class="radio">
                                <label>
                                    <input type="radio" value="1"  id="status1"  name="status"  <c:if test="${resourceConfigs.status == 1 || resourceConfigs.status == null}"> checked="checked"</c:if>>启用</label>
                            </div>
                            <div class="radio">
                                <label>
                                    <input type="radio" value="0" id="status0" name="status" <c:if test="${resourceConfigs.status == 0}"> checked="checked"</c:if>>禁用</label>
                            </div>
                        </div>
                    </div>
                    <div class="hr-line-dashed"></div>
                    <div class="form-group">
                        <label class="control-label form-label-item"></label>
                        <div class="col-sm-4" style="text-align: center">
                            <button class="btn btn-primary" type="submit">保存</button>
                            <button class="btn btn-active" style="margin-left: 30px;" onclick="window.location.href='<%=basePath%>system/resource/resourceList.do'">取消</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
</body>
</html>
