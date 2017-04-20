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
    <title>应用角色授权分配</title>
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
                ck.attr("name","appRoleIdList");
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
                ck.attr("name","appRoleIdList");
                sp.attr("style","color:#ff0000");
            }
        }
        function submitForm(){
            var appRoleList = $("#applicationRoleForm input[checked='checked']");
            var aIdList = "";
            if(appRoleList == undefined || appRoleList.length == 0){
                BootstrapDialog.show({title:"操作提示", message: "未选择任何应用角色进行授权分配" });
                return;
            }
            $.each(appRoleList,function(index,app){
                aIdList +=$(app).val()+",";
            });
            aIdList = aIdList.substring(0,aIdList.length-1);
            var userId = $("#txtd").val();
            var jsonData = {};
            jsonData.userId = userId
            jsonData.appRoleIdList = aIdList;
            $.ajax({
                url: "<%=basePath%>system/user/jsonSaveOrUpdateUserAppRole.do",
                type: "post",
                dataType: "json",
                data:jsonData,
                success: function (item) {
//                    var item = eval("(" + data + ")");
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
                                        dialog.close();
                                    });
                                }
                            }]
                        });
                    }
                }
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
                <a style="cursor: text;">用户管理</a>
            </li>
            <li>
                <strong style="cursor: text;">用户应用授权</strong>
            </li>
        </ol>
    </div>
</div>
<div class="row">
    <div class="col-sm-12">
        <div class="ibox float-e-margins" style=" background-color: #fff;">
            <div class="ibox-title" style="background-color:#22beef;">
                <h5 style="color:#fff;">用户应用授权</h5>
            </div>
            <div class="ibox-content">
                <form class="form-horizontal m-t" id="applicationRoleForm">
                    <input type="hidden" value="${users.id}" name="userId" id="txtd" />
                    <div class="form-group">
                        <label class="control-label form-label-item">当前选择用户：</label>
                        <div class="col-sm-4">
                            <input  type="text"  class="form-control" value="${users.name}" readonly="readonly" />
                        </div>
                    </div>
                    <div class="hr-line-dashed"></div>
                    <div class="form-group" style="max-height: 500px;overflow: auto;">
                        <label class="control-label form-label-item">用户应用授权：</label>
                        <div class="col-sm-11">
                            <c:forEach var="item" items="${appRoleList}">
                                <span  class="va-subfunction-item">
                                     <label class="va-checkbox va-item-span">
                                         <i id="i_item_${item.id}" class="mt4 mr4 <c:forEach var="idItem" items="${idList}"><c:if test="${idItem ==item.id}">va-checkbox-true</c:if></c:forEach>"  onClick="SelectCheck(this);" doc="selectedFlag"></i>
                                         <input id="ipt_item_${item.id}" type="hidden"  value="${item.id}" <c:forEach var="idItem" items="${idList}"><c:if test="${idItem ==item.id}">checked="checked" name="appRoleIdList" </c:if></c:forEach>>
                                         <span id="sp_item_${item.id}"  onclick="nameSelected(this);" <c:forEach var="idItem" items="${idList}"><c:if test="${idItem ==item.id}">style="color:red;" </c:if></c:forEach>>${item.name}</span>
                                     </label>
                                </span>
                            </c:forEach>
                        </div>
                    </div>
                   <%-- <div class="hr-line-dashed"></div>
                    <div class="form-group">
                        <div class="col-sm-8">
                            <button class="btn btn-primary" onclick="submitForm();" style="margin-left: 240px;">保存</button>
                            <button class="btn btn-active" type="submit" style="margin-left: 30px;" onclick="javascript:history.back();">取消</button>
                        </div>
                    </div>--%>
                </form>
            </div>
        </div>
    </div>
</div>
<div class="col-sm-12" style="background-color: white;padding: 5px 5px;position: fixed;margin-top: -20px;">
    <button class="btn btn-primary" onclick="submitForm();" style="margin-left: 240px;">保存</button>
    <button class="btn btn-active" type="submit" style="margin-left: 30px;" onclick="javascript:history.back();">取消</button>
</div>
</body>
</html>
