<%@ page language="java" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
    <title>权限分配</title>
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
                            BootstrapDialog.show({title:"操作提示", message: item.message,buttons: [{label: '确定',action: function(e) {window.location.href='<%=basePath%>system/role/roleList.do';}}] });
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
                <a style="cursor: text;">角色管理</a>
            </li>
            <li>
                <strong style="cursor: text;">权限分配</strong>
            </li>
        </ol>
    </div>
</div>
<div class="row">
    <div class="col-sm-12">
        <div class="ibox float-e-margins" style=" background-color: #fff;">
            <div class="ibox-title" style="background-color:#22beef;">
                <h5 style="color:#fff;">权限分配</h5>
            </div>
            <div class="ibox-content">
                <form class="form-horizontal m-t" id="permissionForm" autocomplete="off" action="<%=basePath%>system/role/jsonSaveOrUpdateRolePermission.do" method="post">
                    <input type="hidden" value="${roles.id}" name="roleId" id="txtd" />
                    <div class="form-group">
                        <label class="control-label form-label-item">角色名称：</label>
                        <div class="col-sm-4">
                            <input  type="text"  class="form-control" value="${roles.name}" readonly="readonly" />
                        </div>
                    </div>
                    <div class="hr-line-dashed"></div>
                    <div class="form-group">
                        <label class="control-label form-label-item">权限分配：</label>
                        <div class="col-sm-11">
                            <span class="va-function-type-item"><span > 系统模块</span></span>
                            <c:forEach var="item" items="${functionMenuList}" varStatus="status">
                                <%--<c:if test="${item.resourceType == 1}">--%>
                                <span class="va-function-item mt4"><span>${item.name}<%--<c:if test="${item.permissionList == null}"><span style="color:#1c2b36;">(未分配权限)</span></c:if>--%></span></span>
                                <c:if test="${item.permissionList != null}">
                                    <c:forEach var="subItem" items="${item.permissionList}">
                                            <span  class="va-subfunction-item">
                                                 <label class="va-checkbox va-item-span">
                                                     <i id="i_item_${subItem.id}" class="mt4 mr4 <c:forEach var="idItem" items="${idList}"><c:if test="${idItem ==subItem.id}">va-checkbox-true</c:if></c:forEach>"  onClick="SelectCheck(this);" doc="selectedFlag"></i>
                                                     <input id="ipt_item_${subItem.id}" type="hidden"  value="${subItem.id}"  <c:forEach var="idItem" items="${idList}"><c:if test="${idItem ==subItem.id}">checked="checked" name="idList" </c:if></c:forEach>>
                                                     <span id="sp_item_${subItem.id}"  onclick="nameSelected(this);"  <c:forEach var="idItem" items="${idList}"><c:if test="${idItem ==subItem.id}">style="color:red;" </c:if></c:forEach>>${subItem.name}</span>
                                                 </label>
                                            </span>
                                    </c:forEach>
                                </c:if>
                            </c:forEach>
                            <span class="va-function-type-item"><span >通用模块</span></span>
                            <span class="va-function-item mt4"><span>通用模块</span></span>
                            <c:forEach var="staticItem" items="${StaticModuleList}">
                                    <span  class="va-subfunction-item">
                                         <label class="va-checkbox va-item-span">
                                             <i id="i_item_${staticItem.id}" class="mt4 mr4 <c:forEach var="idItem" items="${idList}"><c:if test="${idItem ==staticItem.id}">va-checkbox-true</c:if></c:forEach>"  onClick="SelectCheck(this);" doc="selectedFlag"></i>
                                             <input id="ipt_item_${staticItem.id}" type="hidden"  value="${staticItem.id}"  <c:forEach var="idItem" items="${idList}"><c:if test="${idItem ==staticItem.id}">checked="checked" name="idList" </c:if></c:forEach>>
                                             <span id="sp_item_${staticItem.id}"  onclick="nameSelected(this);"  <c:forEach var="idItem" items="${idList}"><c:if test="${idItem ==staticItem.id}">style="color:red;" </c:if></c:forEach>>${staticItem.name}</span>
                                         </label>
                                    </span>
                            </c:forEach>
                        </div>
                    </div>
                    <div class="hr-line-dashed"></div>
                    <div class="form-group">
                        <label class="control-label form-label-item"></label>
                        <div class="col-sm-4" style="text-align: center">
                            <button class="btn btn-primary" onclick="submitForm();" >保存</button>
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
