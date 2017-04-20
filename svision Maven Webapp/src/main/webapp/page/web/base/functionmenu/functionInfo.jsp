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
    <title>菜单管理</title>
    <script src="<%=basePath %>source/js/jquery.form.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $('#functionForm').bootstrapValidator({
                message: '录入数据项不能通过验证，请仔细检查',
                feedbackIcons: {
                    valid: 'glyphicon glyphicon-ok',
                    invalid: 'glyphicon glyphicon-remove',
                    validating: 'glyphicon glyphicon-refresh'
                },
                fields: {
                    name: {
                        message: '菜单名称不能为空',
                        validators: {
                            notEmpty: {
                                message: '菜单名称不能为空'
                            },
                            stringLength: {
                                min: 2,
                                max: 100,
                                message: '菜单名称长度必须在2到100位之间'
                            },
                            regexp: {
                                regexp: /^[^@\/\'\\\"#$%&\^\*]+$/,
                                message: '菜单名称不能包含特殊字符'
                            }
                        }
                    },
                    url: {
                        message: '菜单地址不能为空',
                        validators: {
                            notEmpty: {
                                message: '菜单地址不能为空'
                            },
                            stringLength: {
                                min: 2,
                                max: 100,
                                message: '菜单地址长度必须在2到100位之间'
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
                $('#functionForm').ajaxSubmit({
                    url:'<%=basePath%>system/function/jsonSaveOrUpdateFunction.do',
                    type: "post",
                    dataType: "json",
                    success: function (item) {
                        if (item.code == returnResult.result_success) {
                            BootstrapDialog.show({
                                title: "操作提示",
                                message: item.message,
                                buttons: [{
                                    label: '确定', action: function (e) {
                                        window.location.href = '<%=basePath%>system/function/functionList.do';
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
        function selectSubItem(obj){
            var subItme = $("#functionForm div[doc='subitem']");
            if(obj>0){
                $.each(subItme,function(index,item){
                    if( $(item).hasClass("displaynone")) {
                        $(item).removeClass("displaynone");
                    }
                });
            }else{
                $.each(subItme,function(index,item){
                    if(!$(item).hasClass("displaynone")) {
                        $(item).addClass("displaynone");
                    }
                });
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
                <a style="cursor: text;">菜单管理</a>
            </li>
            <li>
                <strong style="cursor: text;">菜单${functionMenus.id == 0?"新增":"编辑"}</strong>
            </li>
        </ol>
    </div>
</div>
<div class="row">
    <div class="col-sm-12">
        <div class="ibox float-e-margins" style=" background-color: #fff;">
            <div class="ibox-title" style="background-color:#22beef;">
                <h5 style="color:#fff;">菜单信息</h5>
            </div>
            <div class="ibox-content">
                <form class="form-horizontal m-t" id="functionForm" autocomplete="off" action="<%=basePath%>system/function/jsonSaveOrUpdateFunction.do" method="post">
                    <input type="hidden" value="${functionMenus.id}" name="id" id="txtd" />
                    <div class="form-group">
                        <label class="control-label form-label-item">菜单名称：</label>
                        <div class="col-sm-4">
                            <input id="name" name="name" type="text"  class="form-control"  placeholder="请输入菜单名称"  value="${functionMenus.name}" aria-required="true" aria-invalid="true" class="error"/>
                        </div>
                    </div>
                    <div class="hr-line-dashed"></div>
                    <div class="form-group">
                        <label class="control-label form-label-item">菜单地址：</label>
                        <div class="col-sm-4">
                            <input id="url" name="url" class="form-control" type="text"  placeholder="请输入菜单地址"  value="${functionMenus.url}" aria-required="true" aria-invalid="true" class="error" />
                        </div>
                    </div>
                    <div class="hr-line-dashed"></div>
                    <div class="form-group">
                        <label class="control-label form-label-item">菜单描述：</label>
                        <div class="col-sm-4">
                            <input id="key" name="key" class="form-control" type="text"  placeholder="请输入菜单描述"  value="${functionMenus.description}"  />
                        </div>
                    </div>
                    <div class="hr-line-dashed"></div>
                    <c:if test="${functionMenus.id == 0}">
                        <div class="form-group">
                            <label class="control-label form-label-item">菜单类型：</label>
                            <div class="col-sm-4">
                                <div class="radio">
                                    <label>
                                        <input type="radio" value="0"  id="resourceType0"  name="resourceType"  <c:if test="${resourceType.resourceType == 0}"> checked="checked"</c:if>>客户端菜单</label>
                                </div>
                                <div class="radio">
                                    <label>
                                        <input type="radio" value="1" id="resourceType1" name="resourceType" <c:if test="${functionMenus.resourceType == 1 || functionMenus.resourceType == null}"> checked="checked"</c:if>>服务端菜单</label>
                                </div>
                            </div>
                        </div>
                        <div class="hr-line-dashed"></div>
                        <div class="form-group">
                            <label class="control-label form-label-item">是否末级：</label>
                            <div class="col-sm-4">
                                <div class="radio">
                                    <label>
                                        <input type="radio" value="false"  id="leaf0" onclick="selectSubItem(0);"  name="leaf"  <c:if test="${functionMenus.leaf == false}"> checked="checked"</c:if>>模块菜单</label>
                                </div>
                                <div class="radio">
                                    <label>
                                        <input type="radio" value="true" id="leaf1"  onclick="selectSubItem(1);"  name="leaf" <c:if test="${functionMenus.leaf == true || functionMenus.leaf == null}"> checked="checked"</c:if>>末级菜单</label>
                                </div>
                            </div>
                        </div>
                        <div class="hr-line-dashed"></div>
                        <div doc="subitem" class="form-group">
                            <label class="control-label form-label-item">所属模块：</label>
                            <div class="col-sm-4">
                                <div class="radio">
                                    <label>
                                        <input type="radio" value="0" id="type0" name="parentId" <c:if test="${functionMenus.parentId == 0}"> checked="checked"</c:if>>无</label>
                                </div>
                                <c:forEach var="item" items="${parentList}">
                                    <div class="radio">
                                        <label>
                                            <input type="radio" value="${item.id}" id="type${item.id}" name="parentId" <c:if test="${functionMenus.parentId == item.id}"> checked="checked"</c:if>>${item.name}</label>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                        <div doc="subitem"  class="hr-line-dashed"></div>
                    </c:if>
                    <c:if test="${functionMenus.parentId >0}">
                        <div doc="subitem" class="form-group">
                            <label class="control-label form-label-item">所属模块：</label>
                            <div class="col-sm-4">
                                <div class="radio">
                                    <label>
                                        <input type="radio" value="0" id="type0" name="parentId" <c:if test="${functionMenus.parentId == 0}"> checked="checked"</c:if>>无</label>
                                </div>
                                <c:forEach var="item" items="${parentList}">
                                    <div class="radio">
                                        <label>
                                            <input type="radio" value="${item.id}" id="type${item.id}" name="parentId" <c:if test="${functionMenus.parentId == item.id}"> checked="checked"</c:if>>${item.name}</label>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                        <div doc="subitem"  class="hr-line-dashed"></div>
                    </c:if>
                    <div class="form-group">
                        <label class="control-label form-label-item">菜单状态：</label>
                        <div class="col-sm-4">
                            <div class="radio">
                                <label>
                                    <input type="radio" value="0"  id="flag0"  name="flag"  <c:if test="${functionMenus.flag == 0}"> checked="checked"</c:if>>禁用</label>
                            </div>
                            <div class="radio">
                                <label>
                                    <input type="radio" value="1" id="status1" name="flag" <c:if test="${functionMenus.flag == 1 || functionMenus.flag == null}"> checked="checked"</c:if>>启用</label>
                            </div>
                        </div>
                    </div>
                    <div class="hr-line-dashed"></div>
                    <div class="form-group">
                        <div class="col-sm-8">
                            <button class="btn btn-primary" onclick="submitForm();" style="margin-left: 240px;">保存</button>
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
