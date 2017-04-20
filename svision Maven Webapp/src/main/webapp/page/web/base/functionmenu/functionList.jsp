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
    <title>菜单管理</title>
    <%--<!-- Bootstrap table -->--%>
    <script src="<%=basePath %>source/js/plugins/bootstrap-table/bootstrap-table.min.js"></script>
    <script src="<%=basePath %>source/js/plugins/bootstrap-table/bootstrap-table-mobile.min.js"></script>
    <script src="<%=basePath %>source/js/plugins/bootstrap-table/locale/bootstrap-table-zh-CN.min.js"></script>
    <script type="text/javascript">
        function search() {
            $("#hid_search").val(encodeURI($("#searchName").val()));
            FunctionForm.submit();
        }
        function searchToggle(){
            $("#div-togle-search").toggle(500);
        }
        /*按下回车进行搜索*/
        function keybDown(e) {
            var ev= window.event||e;
            if (ev.keyCode == 13){
                search();
            }
        }
        function showItems(id){
            var collection = $("#datatable tr[doc=tr_"+id+"]");
            $.each(collection,function(index,item){
                if($(item).hasClass("displaynone")){
                    $(item).removeClass("displaynone");
                }else{
                    $(item).addClass("displaynone");
                }
            });

        }
        function checkFunction(uid,status){
            $.ajax({
                url: "<%=basePath%>system/function/jsonCheckFunction.do?id=" + uid+"&flag="+status,
                type: "post",
                dataType: "json",
                success: function (data) {
                    if (data.code == returnResult.result_success) {
                        BootstrapDialog.show({title:"操作提示", message: data.message,buttons: [{label: '确定',action: function(e) {window.location.href='<%=basePath%>system/function/functionList.do';}}] });
                    } else {
                        BootstrapDialog.show({title:"操作提示", message: data.message });
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
                <a style="cursor: text;">菜单管理</a>
            </li>
            <li>
                <strong style="cursor: text;">菜单列表</strong>
            </li>
            <li style="float:right;">
                <a href="javascript:void(0);" onclick="searchToggle();"> <button type="button" class="btn btn-large btn-danger">搜索</button></a>
                <a href="javascript:void(0);" onclick="window.location.href='<%=basePath%>system/function/functionInfo.do?id=0'" style="margin-left: 20px;"> <button type="button" class="btn btn-large btn-success">新建</button></a>
            </li>
        </ol>
    </div>
</div>

<div id="div-togle-search">
    <form method="post" id="FunctionForm" action="<%=basePath%>system/function/functionList.do">
        <table cellspacing="3" cellpadding="4">
            <tr>
                <td>
                </td>
                <td>
                    <input id="searchName" type="text" class="form-control" placeholder="请输入查询内容..."   onkeydown="keybDown(event)"  value="${functions.searchName}" />
                    <input type="hidden" name="searchName" id="hid_search" />
                </td>
                <td><a href="javascript:void(0);"> <button type="button" class="btn btn-large btn-success"  onclick="search();">查询</button></a></td>
            </tr>
        </table>
    </form>
</div>
<div class="row row-lg">
    <div class="col-sm-12">
        <div class="ibox-content" style=" background-color: #fff;">
            <!-- Example Card View -->
            <div class="example">
                <table id="datatable" cellpadding="0" cellspacing="0"   class="gwe-table">
                    <thead>
                    <tr >
                        <th>状态</th>
                        <th>菜单名称</th>
                        <th>菜单类型</th>
                        <th>菜单序号</th>
                        <th>访问路径</th>
                        <th>备注描述</th>
                        <th>操作</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="item" items="${funcitonList}">
                        <tr id="tdtable">
                            <td>
                                <c:if test="${item.flag == 0}">
                                    已停用
                                </c:if>
                                <c:if test="${item.flag == 1}">
                                    使用中
                                </c:if>
                            </td>
                            <td><strong>${item.name}</strong></td>
                            <td>
                                <c:if test="${item.resourceType == 0}">
                                    客户端菜单
                                </c:if>
                                <c:if test="${item.resourceType == 1}">
                                    管理端菜单
                                </c:if>
                            </td>
                            <td>${item.sort}</td>
                            <td>${item.url}</td>
                            <td>${item.description}</td>
                            <td>
                                <c:if test="${item.childMenulist != null}">
                                    <a id="showItems" href="javascript:void(0);" onclick="showItems(${item.id});"><button type="button" class="btn btn-success btn-xs">子模块</button></a>
                                </c:if>
                                <c:if test="${item.flag == 0}">
                                    <a href="javascript:void(0);" onclick="javascript:$('#div_content').html('确定启用主菜单 ${item.name}  ？');$('#btn_confirm').attr('onclick', 'checkFunction(${item.id},1);');" data-toggle="modal" data-target="#confirmModal"> <button type="button" class="btn btn-success btn-xs">启用</button></a>
                                </c:if>
                                <c:if test="${item.flag == 1}">
                                    <a href="javascript:void(0);" onclick="javascript:$('#div_content').html('确定禁用主菜单  ${item.name} ？');$('#btn_confirm').attr('onclick', 'checkFunction(${item.id},0);');" data-toggle="modal" data-target="#confirmModal"> <button type="button" class="btn btn-danger btn-xs">禁用</button></a>
                                </c:if>
                                <a href="<%=basePath%>system/function/functionInfo.do?id=${item.id}"><button type="button" class="btn btn-info btn-xs"> 编辑</button></a>
                            </td>
                        </tr>
                        <c:if test="${item.childMenulist != null}">
                            <c:forEach var="subItem" items="${item.childMenulist}">
                                <tr doc="tr_${item.id}" class="displaynone" style="background-color: rgba(121, 132, 136, 0.32);">
                                    <td></td>
                                    <td>${subItem.name}</td>
                                    <td>
                                        <c:if test="${item.resourceType == 0}">
                                            客户端菜单
                                        </c:if>
                                        <c:if test="${item.resourceType == 1}">
                                            管理端菜单
                                        </c:if>
                                    </td>
                                    <td>${subItem.sort}</td>
                                    <td>${subItem.url}</td>
                                    <td>${subItem.description}</td>
                                    <td>
                                        <c:if test="${item.flag == 1}">
                                            <c:if test="${subItem.flag == 0}">
                                                <a href="javascript:void(0);" onclick="javascript:$('#div_content').html('确定启用子模块菜单 ${subItem.name} ？');$('#btn_confirm').attr('onclick', 'checkFunction(${subItem.id},1);');" data-toggle="modal" data-target="#confirmModal"> <button type="button" class="btn btn-success btn-xs">启用</button></a>
                                            </c:if>
                                            <c:if test="${subItem.flag == 1}">
                                                <a href="javascript:void(0);" onclick="javascript:$('#div_content').html('确定禁用子模块菜单 ${subItem.name} ？');$('#btn_confirm').attr('onclick', 'checkFunction(${subItem.id},0);');" data-toggle="modal" data-target="#confirmModal"> <button type="button" class="btn btn-danger btn-xs">禁用</button></a>
                                            </c:if>
                                        </c:if>
                                        <a href="<%=basePath%>system/function/functionInfo.do?id=${subItem.id}"><button type="button" class="btn btn-info btn-xs"> 编辑</button></a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:if>
                    </c:forEach>
                    </tbody>
                </table>

            </div>
        </div></div>
    <!-- End Example Card View -->
</div>


<div class="modal fade" id="confirmModal" tabindex="-1" role="dialog" aria-labelledby="confirmModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                    &times;
                </button>
                <h4 class="modal-title" id="confirmModalLabel">
                    操作确认
                </h4>
            </div>
            <div id="div_content" class="modal-body">
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消
                </button>
                <button id="btn_confirm" type="button" class="btn btn-primary"  >
                    确定
                </button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal -->
</div>
</body>
</html>
