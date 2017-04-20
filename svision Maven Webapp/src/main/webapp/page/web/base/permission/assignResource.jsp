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
    <title>资源分配</title>
    <script src="<%=basePath %>source/js/jquery.form.js"></script>
    <script type="text/javascript">
        function SelectCheck(obj){
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
                ck.attr("name","idList");
                sp.attr("style","color:#ff0000");
            }
        }
        function nameSelected(obj){
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
                ck.attr("name","idList");
                sp.attr("style","color:#ff0000");
            }
        }


        function submitForm(){
            $('#permissionForm').submit(function(req){
                $('#permissionForm').ajaxSubmit({
                    success: function (data) {
                        var item = eval("(" + data + ")");
                        if(item.code == returnResult.result_success){
                            BootstrapDialog.show({title:"操作提示", message: item.message,buttons: [{label: '确定',action: function(e) {window.location.href='<%=basePath%>system/permission/permissionList.do';}}] });
                        }
                        else{
                            BootstrapDialog.show({title:"操作提示", message: item.message,buttons: [{label: '确定',action: function() {$.each(BootstrapDialog.dialogs, function(id, dialog){dialog.close();});}}] });
                        }
                    }
                });
                return false;
            });
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
                <strong style="cursor: text;">资源分配</strong>
            </li>
        </ol>
    </div>
</div>
<div class="row">
    <div class="col-sm-12">
        <div class="ibox float-e-margins" style=" background-color: #fff;">
            <div class="ibox-title" style="background-color:#22beef;">
                <h5 style="color:#fff;">资源分配</h5>
            </div>
            <div class="ibox-content">
                <form class="form-horizontal m-t" id="permissionForm" autocomplete="off" action="<%=basePath%>system/permission/jsonSaveOrUpdatePermissionResource.do" method="post">
                    <input type="hidden" value="${permissions.id}" name="permissionId" id="txtd" />
                    <div class="form-group">
                        <label class="control-label form-label-item">权限名称：</label>
                        <div class="col-sm-4">
                            <input  type="text"  class="form-control" value="${permissions.name}" readonly="readonly" />
                        </div>
                    </div>
                    <div class="hr-line-dashed"></div>

                    <div class="form-group">
                        <label class="control-label form-label-item">授权资源：</label>
                        <div class="col-sm-8">
                            <c:forEach var="item" items="${resourceList}">
                                <span  class="va-resource-item">
                                     <label class="va-checkbox va-item-span">
                                         <i id="i_id_${item.id}" class="mt4 mr4 <c:if test="${item.selected != null && item.selected}">va-checkbox-true</c:if>"  onClick="SelectCheck(this);" doc="selectedFlag"></i>
                                         <input id="ck_id_${item.id}" type="hidden" <c:if test="${item.selected != null && item.selected}">checked="checked" name="idList"</c:if> value="${item.id}" >
                                         <span  onclick="nameSelected(this);" <c:if test="${item.selected != null && item.selected}">style="color:#ff0000;"</c:if>>${item.name}</span>
                                     </label>
                                </span>
                            </c:forEach>
                        </div>
                    </div>
                    <div class="hr-line-dashed"></div>
                    <div class="form-group">
                        <div class="col-sm-8">
                            <button class="btn btn-primary" onclick="submitForm();" style="margin-left: 240px;">保存</button>
                            <button class="btn btn-active"  style="margin-left: 30px;" onclick="javascript:history.back();">取消</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
</body>
</html>
