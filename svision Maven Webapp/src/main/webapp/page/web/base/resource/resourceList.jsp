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
    <title>资源管理</title>
    <meta name="author" content="">
    <%--<!-- Bootstrap table -->--%>
    <script src="<%=basePath %>source/js/plugins/bootstrap-table/bootstrap-table.min.js"></script>
    <script src="<%=basePath %>source/js/plugins/bootstrap-table/bootstrap-table-mobile.min.js"></script>
    <script src="<%=basePath %>source/js/plugins/bootstrap-table/locale/bootstrap-table-zh-CN.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            //showProcess(true, '温馨提示', '正在加载数据...');
            $("#pager").pager({
                pagenumber: '${resourceConfig.pageNo}', /* 表示初始页数 */
                pagecount: '${resourceConfig.pageCount}', /* 表示总页数 */
                totalCount: '${resourceConfig.totalCount}',
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
                pagecount: '${resourceConfig.pageCount}', /* 表示最大页数pagecount */
                buttonClickCallback: PageClick                 /* 表示点击页数时的调用的方法就可实现javascript分页功能 */
            });

            $("#pageNumber").val(pageclickednumber);
            /* 给pageNumber从新赋值 */
            /* 执行Action */
            $("#hid_search").val(encodeURI($("#searchName").val()));
            ResourceForm.submit();
        }
        function search() {
            $("#pageNumber").val("1");
            $("#hid_search").val(encodeURI($("#searchName").val()));
            ResourceForm.submit();
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
        function checkResource(uid,status){
            $.ajax({
                url: "<%=basePath%>system/resource/jsonCheckResource.do?id=" + uid+"&status="+status,
                type: "post",
                dataType: "json",
                success: function (data) {
                    if (data.code == returnResult.result_success) {
                        BootstrapDialog.show({title:"操作提示", message: data.message,buttons: [{label: '确定',action: function(e) {window.location.href='<%=basePath%>system/resource/resourceList.do?pageNo='+$("#pageNumber").val();}}] });
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
                <a style="cursor: text;">资源管理</a>
            </li>
            <li>
                <strong style="cursor: text;">资源列表</strong>
            </li>
            <li style="float:right;">
                <a href="javascript:void(0);" onclick="searchToggle();"> <button type="button" class="btn btn-large btn-danger">搜索</button></a>
                <a href="javascript:void(0);" onclick="window.location.href='<%=basePath%>system/resource/resourceInfo.do?id=0'" style="margin-left: 20px;"> <button type="button" class="btn btn-large btn-success">新建</button></a>
            </li>
        </ol>
    </div>
</div>

<div id="div-togle-search">
    <form method="post" id="ResourceForm" action="<%=basePath%>system/resource/resourceList.do">
        <table cellspacing="3" cellpadding="4">
            <tr>
                <td>
                </td>
                <td>
                    <input id="searchName" type="text" class="form-control" placeholder="请输入查询内容..."   onkeydown="keybDown(event)"  value="${resourceConfig.searchName}" />
                    <input type="hidden" name="searchName" id="hid_search" />
                </td>
                <td><a href="javascript:void(0);"> <button type="button" class="btn btn-large btn-success"  onclick="search();">查询</button></a></td>
            </tr>
        </table>
        <input type="hidden" id="pageNumber" name="pageNo" value="${resourceConfig.pageNo}"/>
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
                        <th>资源名称</th>
                        <th>资源地址</th>
                        <th>资源关键字</th>
                        <th>资源类型</th>
                        <th>备注说明</th>
                        <th>操作</th>
                    </tr>

                    </thead>
                    <tbody>
                    <c:forEach var="item" items="${resourceList}">
                        <tr id="tdtable">
                            <td>
                                <c:if test="${item.status == 0}">
                                    已作废
                                </c:if>
                                <c:if test="${item.status == 1}">
                                    使用中
                                </c:if>
                                <c:if test="${item.status == 2}">
                                    已删除
                                </c:if>
                            </td>
                            <td>${item.name}</td>
                                <%--<td></td>--%>
                            <td>${item.src}</td>
                            <td>${item.key}</td>
                            <td>
                                <c:if test="${item.type == 0}">
                                    方法
                                </c:if>
                                <c:if test="${item.type == 1}">
                                    页面
                                </c:if>
                                <c:if test="${item.type == 2}">
                                    按键
                                </c:if>
                            </td>
                            <td>${item.description}</td>
                            <td>
                                <c:if test="${item.status == 0}">
                                    <a href="javascript:void(0);" onclick="javascript:$('#div_content').html('确定启用资源 ${item.name} ？');$('#btn_confirm').attr('onclick', 'checkResource(${item.id},1);');" data-toggle="modal" data-target="#confirmModal"> <button type="button" class="btn btn-success btn-xs">启用</button></a>
                                </c:if>
                                <c:if test="${item.status == 1}">
                                    <a href="javascript:void(0);" onclick="javascript:$('#div_content').html('确定禁用资源 ${item.name} ？');$('#btn_confirm').attr('onclick', 'checkResource(${item.id},0);');" data-toggle="modal" data-target="#confirmModal"> <button type="button" class="btn btn-danger btn-xs">禁用</button></a>
                                </c:if>
                                <a href="<%=basePath%>system/resource/resourceInfo.do?id=${item.id}"><button type="button" class="btn btn-info btn-xs"> 编辑</button></a>
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
