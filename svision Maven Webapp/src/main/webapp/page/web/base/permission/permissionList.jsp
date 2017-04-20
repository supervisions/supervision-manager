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
    <%--<!-- Bootstrap table -->--%>
    <title>权限管理</title>
    <script src="<%=basePath %>source/js/plugins/bootstrap-table/bootstrap-table.min.js"></script>
    <script src="<%=basePath %>source/js/plugins/bootstrap-table/bootstrap-table-mobile.min.js"></script>
    <script src="<%=basePath %>source/js/plugins/bootstrap-table/locale/bootstrap-table-zh-CN.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {

            //showProcess(true, '温馨提示', '正在加载数据...');
            $("#pager").pager({
                pagenumber: '${permissions.pageNo}', /* 表示初始页数 */
                pagecount: '${permissions.pageCount}', /* 表示总页数 */
                totalCount: '${permissions.totalCount}',
                buttonClickCallback: PageClick                  /* 表示点击分页数按钮调用的方法 */
            });
            var searchName = $.trim($("#searchName").val());
            if(searchName.length>0){
                $("#div-togle-search").toggle();
            }
        });
        PageClick = function (pageclickednumber) {
            $("#pager").pager({
                pagenumber: pageclickednumber, /* 表示启示页 */
                pagecount: '${permissions.pageCount}', /* 表示最大页数pagecount */
                buttonClickCallback: PageClick                 /* 表示点击页数时的调用的方法就可实现javascript分页功能 */
            });

            $("#pageNumber").val(pageclickednumber);
            /* 给pageNumber从新赋值 */ /* 给pageNumber从新赋值 */
            /* 执行Action */
            $("#hid_search").val(encodeURI($("#searchName").val()));
            PermissionForm.submit();
        }
        function search() {
            $("#pageNumber").val("1");
            $("#hid_search").val(encodeURI($("#searchName").val()));
            PermissionForm.submit();
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
                <strong style="cursor: text;">权限列表</strong>
            </li>
            <li style="float:right;">
                <a href="javascript:void(0);" onclick="searchToggle();"> <button type="button" class="btn btn-large btn-danger">搜索</button></a>
                <a href="javascript:void(0);" onclick="window.location.href='<%=basePath%>system/permission/permissionInfo.do?id=0'" style="margin-left: 20px;"> <button type="button" class="btn btn-large btn-success">新建</button></a>
            </li>
        </ol>
    </div>
</div>

<div id="div-togle-search">
    <form method="post" id="PermissionForm" action="<%=basePath%>system/permission/permissionList.do">
        <table cellspacing="3" cellpadding="4">
            <tr>
                <td>
                </td>
                <td>
                    <input id="searchName" type="text" class="form-control" placeholder="请输入查询内容..."   onkeydown="keybDown(event)"  value="${permissions.searchName}" />
                    <input type="hidden" name="searchName" id="hid_search" />
                </td>
                <td><a href="javascript:void(0);"> <button type="button" class="btn btn-large btn-success"  onclick="search();">查询</button></a></td>
            </tr>
        </table>
        <input type="hidden" id="pageNumber" name="pageNo" value="${permissions.pageNo}"/>
    </form>
</div>
<div class="row row-lg">
    <div class="col-sm-12">
        <div class="ibox-content" style=" background-color: #fff;">
            <!-- Example Card View -->
            <div class="example">
                <table id="datatable" cellpadding="0" cellspacing="0" data-toggle="table" data-card-view="true" data-mobile-responsive="true">
                    <thead>
                    <tr >
                        <th>状态</th>
                        <th>权限名称</th>
                        <th>所属模块</th>
                        <th>备注说明</th>
                        <th>操作</th>
                    </tr>

                    </thead>
                    <tbody>
                    <c:forEach var="item" items="${permissionList}">
                        <tr id="tdtable">
                            <td>
                                <c:if test="${item.status == 0}">
                                    已作废
                                </c:if>
                                <c:if test="${item.status == 1}">
                                    使用中
                                </c:if>
                            </td>
                            <td>${item.name}</td>
                            <td>${item.moudleName}</td>
                            <td>${item.description}</td>
                            <td>
                                <a href="<%=basePath%>system/permission/assignResource.do?id=${item.id}"> <button type="button" class="btn btn-success btn-xs">资源分配</button></a>
                                <a href="<%=basePath%>system/permission/permissionInfo.do?id=${item.id}"><button type="button" class="btn btn-info btn-xs"> 编辑</button></a>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>

            </div>
        </div></div>
    <div class="page" id="pager" style="margin: 30px;">
    </div>
    <!-- End Example Card View -->
</div>
</body>
</html>
