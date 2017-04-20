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
    <title>机构管理</title>
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
        });
        PageClick = function (pageclickednumber) {
            $("#pager").pager({
                pagenumber: pageclickednumber, /* 表示启示页 */
                pagecount: '${user.pageCount}', /* 表示最大页数pagecount */
                buttonClickCallback: PageClick                 /* 表示点击页数时的调用的方法就可实现javascript分页功能 */
            });

            $("#pageNumber").val(pageclickednumber);
            /* 给pageNumber从新赋值 */
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
                <a style="cursor: text;">机构管理</a>
            </li>
            <li>
                <strong style="cursor: text;">机构列表</strong>
            </li>
            <li style="float:right;">
                <a href="javascript:void(0);" onclick="window.location.href='<%=basePath%>system/user/organInfo.do?id=0'"> <button type="button" class="btn btn-large btn-success">新建</button></a>
            </li>
        </ol>
        <input type="hidden" id="pageNumber" name="pageNo" value="${user.pageNo}"/>
    </div>
</div>
<div class="row row-lg">

    <div class="col-sm-3" >

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
        </div> </div>

    <div class="col-sm-9">
        <div class="ibox-content" style=" background-color: #fff;">
            <!-- Example Card View -->
            <div class="example">
                <table id="datatable" cellpadding="0" cellspacing="0" data-toggle="table" data-card-view="true" data-mobile-responsive="true">
                    <thead>
                    <tr >
                        <th>机构名称</th>
                        <th>上级机构</th>
                        <th>备注说明</th>
                        <th>操作</th>
                    </tr>

                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${organList}">
                            <tr id="tdtable">
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
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
