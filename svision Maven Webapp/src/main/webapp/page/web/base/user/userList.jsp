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
    <title>用户管理</title>
    <%--<!-- Bootstrap table -->--%>
    <script src="<%=basePath %>source/js/plugins/bootstrap-table/bootstrap-table.min.js"></script>
    <script src="<%=basePath %>source/js/plugins/bootstrap-table/bootstrap-table-mobile.min.js"></script>
    <script src="<%=basePath %>source/js/plugins/bootstrap-table/locale/bootstrap-table-zh-CN.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            //showProcess(true, '温馨提示', '正在加载数据...');
            $("#pager").pager({
                pagenumber: '${user.pageNo}', /* 表示初始页数 */
                pagecount: '${user.pageCount}', /* 表示总页数 */
                totalCount: '${user.totalCount}',
                buttonClickCallback: PageClick                  /* 表示点击分页数按钮调用的方法 */
            });
            var searchName = $.trim($("#searchName").val());
            var userStatus = $("#sct_userStatus").val();
            if(searchName.length>0 || userStatus > 0){
                $("#div-togle-search").toggle();
                if(userStatus>0){
                    $("#sct_userStatus").val(userStatus);
                }
            }
        });
        PageClick = function (pageclickednumber) {
            $("#pager").pager({
                pagenumber: pageclickednumber, /* 表示启示页 */
                pagecount: '${user.pageCount}', /* 表示最大页数pagecount */
                buttonClickCallback: PageClick                 /* 表示点击页数时的调用的方法就可实现javascript分页功能 */
            });

            $("#pageNumber").val(pageclickednumber);
            /* 给pageNumber从新赋值 */
            /* 执行Action */
            UserForm.submit();
        }
        function search() {
            $("#pageNumber").val("1");
            $("#hid_search").val(encodeURI($("#searchName").val()));
            UserForm.submit();
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
        function resetPwd(uid){
            $.ajax({
                url: "<%=basePath%>system/user/jsonReSetPwd.do?id=" + uid,
                type: "post",
                dataType: "json",
                success: function (data) {
                    if (data.code == returnResult.result_success) {
                        BootstrapDialog.show({title:"操作提示", message: data.message });
                    } else {
                        BootstrapDialog.show({title:"操作提示", message: data.message });
                    }
                }
            });
        }
        function checkUser(uid,status){
            $.ajax({
                url: "<%=basePath%>system/user/jsonCheckUser.do?id=" + uid+"&status="+status,
                type: "post",
                dataType: "json",
                success: function (data) {
                    if (data.code == returnResult.result_success) {
//                        BootstrapDialog.alert({title:"操作提示", message: data.message });
                        BootstrapDialog.show({title:"操作提示", message: data.message,buttons: [{label: '确定',action: function(e) {window.location.href='<%=basePath%>system/user/userList.do?pageNo='+$("#pageNumber").val();}}] });
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
                <a style="cursor: text;">用户管理</a>
            </li>
            <li>
                <strong style="cursor: text;">用户列表</strong>
            </li>
            <li style="float:right;">
                <a href="javascript:void(0);" onclick="searchToggle();"> <button type="button" class="btn btn-large btn-danger">搜索</button></a>
                <a href="javascript:void(0);" onclick="window.location.href='<%=basePath%>system/user/userInfo.do?id=0'" style="margin-left: 20px;"> <button type="button" class="btn btn-large btn-success">新建</button></a>
            </li>
        </ol>
    </div>
</div>

<div id="div-togle-search">
    <form method="post" id="UserForm" action="<%=basePath%>system/user/userList.do">
        <table cellspacing="3" cellpadding="4">
            <tr>
                <td>
                    <select id="sct_userStatus" class="form-control" name="status" value="${user.status}">
                        <option value="">请选择用户状态</option>
                        <option value="0">未激活</option>
                        <option value="1">已启用</option>
                        <option value="2">已禁用</option>
                        <option value="3">已删除</option>
                    </select>
                </td>
                <td>
                    <input id="searchName" type="text" class="form-control" placeholder="请输入查询内容..."   onkeydown="keybDown(event)"  value="${user.searchName}" />
                    <input type="hidden" name="searchName" id="hid_search" />
                    <input type="hidden" id="pageNumber" name="pageNo" value="${user.pageNo}"/>
                </td>
                <td><a href="javascript:void(0);"> <button type="button" class="btn btn-large btn-success"  onclick="search();">查询</button></a></td>
            </tr>
        </table>
    </form>
</div>
<div class="row row-lg">

    <%--<div class="col-sm-3" >

        <div class="ibox-content" style=" background-color: #fff;">
            <!--左侧导航开始-->
            <nav role="navigation" style="background:#fff;">
                <div class="nav-close"><i class="fa fa-times-circle"></i>
                </div>
                <div class="sidebar-collapse">
                    <ul class="nav" id="side-menu">
                        <li class="nav-header"  style="background:#22beef;">
                            <div class="dropdown profile-element">
                                <a data-toggle="dropdown" class="dropdown-toggle" href="#">
                                <span class="clear">
                                    <span class="block m-t-xs" style="font-size:20px;">
                                        <i class="fa fa-sliders"></i>
                                        <strong class="font-bold">机构树</strong>
                                    </span>
                                </span>
                                </a>
                            </div>
                            <div class="logo-element">机构
                            </div>
                        </li>
                        <li class="line dk"></li>
                        <li  style="background:#fff;">
                            <a href="#" style="background-color:#cfd4d6;color:#424256"><i class="fa fa-edit"></i> <span class="nav-label">云格致力</span><span class="fa arrow"></span></a>
                            <ul class="nav nav-second-level" style="border-bottom: 1px solid #f0f3f4;border-left: 1px solid #f0f3f4;border-right: 1px solid #f0f3f4;border-top:0px;">
                                <li><a class="J_menuItem" href="form_basic.html">研发部</a>
                                </li>
                                <li>
                                    <a href="#">产品部 <span class="fa arrow"></span></a>
                                    <ul class="nav nav-third-level">
                                        <li><a class="J_menuItem" href="form_webuploader.html">产品一部</a>
                                        </li>
                                        <li><a class="J_menuItem" href="form_file_upload.html">产品二部</a>
                                        </li>
                                    </ul>
                                </li>
                                <li>
                                    <a href="#">销售部 <span class="fa arrow"></span></a>
                                    <ul class="nav nav-third-level">
                                        <li><a class="J_menuItem" href="form_editors.html">售前服务</a>
                                        </li>
                                        <li><a class="J_menuItem" href="form_simditor.html">售后服务</a>
                                        </li>
                                    </ul>
                                </li>
                                <li>
                                    <a href="#">维护部 <span class="fa arrow"></span></a>
                                    <ul class="nav nav-third-level">
                                        <li><a class="J_menuItem" href="form_editors.html">运维一部</a>
                                        </li>
                                        <li><a class="J_menuItem" href="form_simditor.html">运维二部</a>
                                        </li>
                                        <li><a class="J_menuItem" href="form_markdown.html">运维三部</a>
                                        </li>
                                    </ul>
                                </li>
                            </ul>
                        </li>


                    </ul>
                    </li>
                    </ul>
                    </li>
                    </ul>
                </div>
            </nav>
            <!--左侧导航结束-->
        </div> </div>--%>

    <div class="col-sm-12">
        <div class="ibox-content" style=" background-color: #fff;">
            <!-- Example Card View -->
            <div class="example">
                <table id="datatable" cellpadding="0" cellspacing="0" data-toggle="table" data-card-view="true" data-mobile-responsive="true">
                    <thead>
                    <tr >
                        <th>状态</th>
                        <th>姓名</th>
                        <%--<th>组织机构</th>--%>
                        <th>用户账号</th>
                        <th>性别</th>
                        <th>联系电话</th>
                        <th>电子邮箱</th>
                        <th>角色</th>
                        <%--<th>显示水印</th>--%>
                        <th>操作</th>
                        <th>应用授权</th>
                    </tr>

                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${userList}">
                            <tr id="tdtable">
                                <td>
                                    <c:if test="${item.status == 0}">
                                        未激活
                                    </c:if>
                                    <c:if test="${item.status == 1}">
                                        已启用
                                    </c:if>
                                    <c:if test="${item.status == 2}">
                                        已禁用
                                    </c:if>
                                    <c:if test="${item.status == 3}">
                                        已删除
                                    </c:if>
                                </td>
                                <td>${item.name}</td>
                                <%--<td></td>--%>
                                <td>${item.account}</td>
                                <td>
                                    <c:if test="${item.sex ==0}">
                                        保密
                                    </c:if>
                                    <c:if test="${item.sex ==1}">
                                        男
                                    </c:if>
                                    <c:if test="${item.sex ==2}">
                                        女
                                    </c:if>
                                </td>
                                <td>${item.phone}</td>
                                <td>${item.email}</td>
                                <td></td>
                               <%-- <td>
                                    <c:if test="${item.mark == 0}">不显示</c:if>
                                    <c:if test="${item.mark == 1}">显示</c:if>
                                </td>--%>
                                <td>
                                    <c:if test="${item.status == 0}">
                                        <a href="javascript:void(0);" onclick="checkUser(${item.id},1);"> <button type="button" class="btn btn-xs btn-success">激活</button></a>
                                    </c:if>
                                    <c:if test="${item.status == 1}">
                                        <a href="javascript:void(0);" onclick="checkUser(${item.id},2);"> <button type="button" class="btn btn-danger btn-xs">禁用</button></a>
                                        <a href="<%=basePath%>system/user/userInfo.do?id=${item.id}"><button type="button" class="btn btn-info btn-xs">编辑</button></a>
                                        <a href="javascript:void(0);" onclick="resetPwd(${item.id});"> <button type="button" class="btn btn-xs btn-warning">重置密码</button></a>
                                    </c:if>
                                    <c:if test="${item.status == 2}">
                                        <a href="javascript:void(0);" onclick="checkUser(${item.id},1);"> <button type="button" class="btn btn-success btn-xs">启用</button></a>
                                    </c:if>
                                    <a href="javascript:void(0);" onclick="checkUser(${item.id},3);"> <button type="button" class="btn btn-xs btn-danger">删除</button></a>
                                   <%-- <c:if test="${item.status == 3}">
                                        已删除
                                    </c:if>--%>
                                </td>
                                <td> <a href="<%=basePath%>system/user/assignAppRoleToUser.do?id=${item.id}"> <button type="button" class="btn btn-xs btn-success">应用授权</button></a></td>
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
