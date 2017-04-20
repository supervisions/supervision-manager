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
    <script src="<%=basePath %>source/js/jquery.form.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $('#permissionForm').bootstrapValidator({
                message: '录入数据项不能通过验证，请仔细检查',
                feedbackIcons: {
                    valid: 'glyphicon glyphicon-ok',
                    invalid: 'glyphicon glyphicon-remove',
                    validating: 'glyphicon glyphicon-refresh'
                },
                fields: {
                    name: {
                        message: '权限名称不能为空',
                        validators: {
                            notEmpty: {
                                message: '权限名称不能为空'
                            },
                            stringLength: {
                                min: 2,
                                max: 100,
                                message: '权限名称长度必须在2到100位之间'
                            },
                            regexp: {
                                regexp: /^[^@\/\'\\\"#$%&\^\*]+$/,
                                message: '权限名称不能包含特殊字符'
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
                $('#permissionForm').ajaxSubmit({
                    url:'<%=basePath%>system/permission/jsonSaveOrUpdatePermission.do',
                    type: "post",
                    dataType: "json",
                    success: function (item) {
                        if (item.code == returnResult.result_success) {
                            BootstrapDialog.show({
                                title: "操作提示",
                                message: item.message,
                                buttons: [{
                                    label: '确定', action: function (e) {
                                        window.location.href = '<%=basePath%>system/permission/permissionList.do';
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
        function clearSelect(){
            var iList = $("#moudle_collection i[doc='selectedFlag']");
            var ckList = $("#moudle_collection input[type='hidden']");
            $.each(iList,function(index,item){
                if($(item).hasClass("va-checkbox-true")){
                    $(item).removeClass("va-checkbox-true");
                }
                var sp = $(item).parent().find("span");
                sp.removeAttr("style");
            });
            $.each(ckList,function(index,item){
                $(item).removeAttr("checked");
                $(item).removeAttr("name");
            });
        }
        function SelectCheck(obj){
            clearSelect();
            var ck = $(obj).parent().find("input[type='hidden']");
            var sp = $(obj).parent().find("span");
            if($(obj).hasClass("va-checkbox-true")){
                $(obj).removeClass("va-checkbox-true");
                ck.removeAttr("checked");
                ck.removeAttr("name");
                sp.removeAttr("style");
            }else{
                $(obj).addClass("va-checkbox-true");
                ck.attr("checked","checked");
                ck.attr("name","moduleId");
                sp.attr("style","color:#ff0000");
            }
        }
        function nameSelected(obj){
            clearSelect();
            var ik = $(obj).parent().find("i[doc='selectedFlag']");
            var ck = $(obj).parent().find("input[type='hidden']");
            var sp = $(obj).parent().find("span");
            if(ik.hasClass("va-checkbox-true")){
                ik.removeClass("va-checkbox-true");
                ck.removeAttr("checked");
                ck.removeAttr("name");
                sp.removeAttr("style");
            }else{
                ik.addClass("va-checkbox-true");
                ck.attr("checked","checked");
                ck.attr("name","moduleId");
                sp.attr("style","color:#ff0000");
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
                <a style="cursor: text;">权限管理</a>
            </li>
            <li>
                <strong style="cursor: text;">权限${permissions.id == 0?"新增":"编辑"}</strong>
            </li>
        </ol>
    </div>
</div>
<div class="row">
    <div class="col-sm-12">
        <div class="ibox float-e-margins" style=" background-color: #fff;">
            <div class="ibox-title" style="background-color:#22beef;">
                <h5 style="color:#fff;">权限信息</h5>
            </div>
            <div class="ibox-content">
                <form class="form-horizontal m-t" id="permissionForm" autocomplete="off" onsubmit="return submitForm();" method="post">
                    <input type="hidden" value="${permissions.id}" name="id" id="txtd" />
                    <div class="form-group">
                        <label class="control-label form-label-item">权限名称：</label>
                        <div class="col-sm-4">
                            <input id="name" name="name" type="text"  class="form-control"  placeholder="请输入权限名称"  value="${permissions.name}" aria-required="true" aria-invalid="true" class="error"/>
                        </div>
                    </div>
                    <div class="hr-line-dashed"></div>
                    <div class="form-group">
                        <label class="control-label form-label-item">权限描述：</label>
                        <div class="col-sm-4">
                            <input id="description" name="description" class="form-control" type="text"  placeholder="请输入权限描述"  value="${permissions.description}" aria-required="true" aria-invalid="true" class="error" />
                        </div>
                    </div>
                    <div class="hr-line-dashed"></div>
                    <div class="form-group displaynone">
                        <label class="control-label form-label-item">权限状态：</label>
                        <div class="col-sm-4">
                            <div class="radio">
                                <label>
                                    <input type="radio" value="1"  id="status1"  name="status"  <c:if test="${permissions.status == 1 || permissions.status == null}"> checked="checked"</c:if>>启用</label>
                            </div>
                            <div class="radio">
                                <label>
                                    <input type="radio" value="0" id="status0" name="status" <c:if test="${permissions.status == 0}"> checked="checked"</c:if>>禁用</label>
                            </div>
                        </div>
                    </div>
                    <div class="hr-line-dashed displaynone"></div>

                    <div class="form-group">
                        <label class="control-label form-label-item">所属模块：</label>
                        <div class="col-sm-11" id="moudle_collection">

                            <span class="va-function-item"><span>通用模块</span></span>
                            <span  class="va-subfunction-item">
                            <label class="va-checkbox va-item-span">
                                <i class="mt4 mr4 <c:if test="${permissions.id == 0}">va-checkbox-true</c:if>"  onClick="SelectCheck(this);" doc="selectedFlag"></i>
                                <input type="hidden"  value="99999" <c:if test="${permissions.id == 0}">checked="checked" name="moduleId" </c:if>><span  onclick="nameSelected(this);" <c:if test="${permissions.id == 0}">style="color:#ff0000;" </c:if>>通用模块</span>
                            </label>
                            </span>
                            <c:forEach var="item" items="${funcitonList}">
                                <c:if test="${item.name == '首页'}">
                                    <span class="va-function-item"><span>${item.name}</span></span>
                                    <span  class="va-subfunction-item">
                                         <label class="va-checkbox va-item-span">
                                             <i id="i_id_${item.id}" class="mt4 mr4 <c:if test="${permissions.moduleId == item.id}">va-checkbox-true</c:if>"  onClick="SelectCheck(this);" doc="selectedFlag"></i>
                                             <input id="moduleId_${item.id}" type="hidden"  value="${item.id}" <c:if test="${permissions.moduleId == item.id}">checked="checked" name="moduleId" </c:if>>
                                             <span  onclick="nameSelected(this);" <c:if test="${permissions.moduleId == item.id}">style="color:#ff0000;" </c:if>>${item.name}</span>
                                         </label>
                                    </span>
                                </c:if>
                                <c:if test="${item.name != '首页'}">
                                    <span class="va-function-item"><span>${item.name}</span></span>
                                    <c:if test="${item.childMenulist != null}">
                                        <c:forEach var="subItem" items="${item.childMenulist}">
                                        <span  class="va-subfunction-item">
                                             <label class="va-checkbox va-item-span">
                                                 <i id="i_id_${subItem.id}" class="mt4 mr4 <c:if test="${permissions.moduleId == subItem.id}">va-checkbox-true</c:if>"  onClick="SelectCheck(this);" doc="selectedFlag"></i>
                                                 <input id="moduleId_${subItem.id}" type="hidden"  value="${subItem.id}" <c:if test="${permissions.moduleId == subItem.id}">checked="checked" name="moduleId" </c:if>>
                                                 <span  onclick="nameSelected(this);" <c:if test="${permissions.moduleId == subItem.id}">style="color:#ff0000;" </c:if>>${subItem.name}</span>
                                             </label>
                                        </span>
                                        </c:forEach>
                                    </c:if>
                                </c:if>
                            </c:forEach>
                        </div>
                    </div>
                    <div class="hr-line-dashed"></div>
                    <div class="form-group">
                        <label class="control-label form-label-item"></label>
                        <div class="col-sm-4" style="text-align: center">
                            <button class="btn btn-primary" type="submit">保存</button>
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
