<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>
<html>
<head>
    <meta charset="utf-8">
    <title>系统用户管理</title>
    <meta name="viewport"
          content="width=device-width, initial-scale=1, minimum-scale=1  ,maximum-scale=1, user-scalable=no"/>
    <script src="${pageContext.request.contextPath}/source/js/pager/jquery.pager.js"></script>
    <link href="${pageContext.request.contextPath}/source/js/pager/Pager.css" rel="stylesheet"/>
    <link rel="shortcut icon" href="<%=basePath%>source/images/favicon.ico" type="image/x-icon" />
    <script type="text/javascript">
        var topClick = false;
        $(document).ready(function () {

            //showProcess(true, '温馨提示', '正在加载数据...');
            $("#pager").pager({
                pagenumber: '${user.pageNo}', /* 表示初始页数 */
                pagecount: '${user.pageCount}', /* 表示总页数 */
                totalCount: '${user.totalCount}',
                buttonClickCallback: PageClick                  /* 表示点击分页数按钮调用的方法 */
            });
//	$("#userList tr").each(function(i){
//		if(i>0){
//			$(this).bind("click",function(){
//				if(topClick){
//					topClick = false;
//					return;
//				}
//				var userId = $(this).find("td").first().text();
//				 window.location.href="userInfo.do?userId="+userId;
//			});
//		}
//	});
            $("#treeList").tree({
                url: 'jsonLoadOrganParent.do?rootId=' + 0,
                onClick: function (node) {
                    var orgId = node.id;
                    getUserListByOrganId(orgId);
                },
                onLoadSuccess: function () {
                    //showProcess(false);
                    /*  var cyId = $.trim($("#hid_companyId").val());
                     if(cyId.length>0){
                     var node = $("#treeList").tree("find",cyId);
                     $('#treeList').tree("select", node.target);

                     }  */
                }
            });
        });
        function getUserListByOrganId(organId) {
            $.ajax({
                url: "jsonLoadUserListByOrganId.do?organId=" + organId,
                type: "post",
                dataType: "json",
                success: function (data) {
                    if (data.code == 0) {
                        $("#pageNumber").val(1);
                        $("#pager").pager({
                            pagenumber: data.obj.pageNo, /* 表示初始页数 */
                            pagecount: data.obj.pageCount, /* 表示总页数 */
                            totalCount: data.obj.totalCount,
                            buttonClickCallback: PageClick                     /* 表示点击分页数按钮调用的方法 */
                        });
                        $("#userList").html("");
                        fillUserList(data.list);
                    } else {
                        $.messager.alert('错误信息', data.message, 'error');
                    }
                }
            });
        }
        function fillUserList(lst) {
            var html = "<tbody>";
            html += "<tr style='background-color:#D6D3D3;font-weight: bold;'><th width='4%' style='display:none'>&nbsp;</th><th><span style='margin-left:40px'>用户账号</span></th><th>联系电话</th><th>电子邮箱</th><th>组织机构</th><th>姓名</th><th>角色</th><th>水印显示</th><th>操作</th></tr>";
            for (var i = 0; i < lst.length; i++) {
                html += "<tr>";
                html += "<td style='display:none'>" + lst[i].id + "</td>";
                html += "<td  onclick=window.location.href='userInfo.do?userId='" + lst[i].id + " align='left' ><span style='margin-left:40px'>" + lst[i].account + "</span></td>";
                html += "<td  onclick=window.location.href='userInfo.do?userId='" + lst[i].id + " align='left' >" + lst[i].mobile + "</td>";
                html += "<td  onclick=window.location.href='userInfo.do?userId='" + lst[i].id + " align='left' >" + lst[i].email + "</td>";
                html += "<td  onclick=window.location.href='userInfo.do?userId='" + lst[i].id + " align='left' >" + lst[i].organName + "</td>";
                html += "<td  onclick=window.location.href='userInfo.do?userId='" + lst[i].id + " align='left' >" + lst[i].name + "</td>";
                html += "<td  onclick=window.location.href='userInfo.do?userId='" + lst[i].id + ">" + lst[i].roleName + "</td>";

                if (lst[i].showmark == 1) {
                    html += "<td  onclick=window.location.href='userInfo.do?userId='" + lst[i].id + ">显示</td>";
                } else {
                    html += "<td  onclick=window.location.href='userInfo.do?userId='" + lst[i].id + ">不显示</td>";
                }
                html += "<td>";
                if (lst[i].flag == 1) {
                    html += "<a href='javascript:void(0);' onclick=OperatUser(" + lst[i].id + ",0,\'" + lst[i].name + "\') style='padding-left:5px;margin-top:25px' >禁用</a>";
                } else {
                    html += "<a href='javascript:void(0);' onclick=OperatUser(" + lst[i].id + ",1,\'" + lst[i].name + "\') style='padding-left:5px;margin-top:25px' >启用</a>";
                }
                html += "<a href='javascript:void(0);' onclick=resetPwd(\'" + lst[i].account + "\') style='padding-left:5px;margin-top:25px' >重置密码</a></td>";
                html += "</tr>";
            }
            html += "</tbody>";
            $("#userList").html(html);
        }
        PageClick = function (pageclickednumber) {
            $("#pager").pager({
                pagenumber: pageclickednumber, /* 表示启示页 */
                pagecount: '${user.pageCount}', /* 表示最大页数pagecount */
                buttonClickCallback: PageClick                 /* 表示点击页数时的调用的方法就可实现javascript分页功能 */
            });

            $("#pageNumber").val(pageclickednumber);
            /* 给pageNumber从新赋值 */
            /* 执行Action */
            pagesearch();
        }
        /*按下回车进行搜索*/
        function keyDown(e) {
            var ev= window.event||e;
            if (ev.keyCode == 13){
                search();
            }
        }
        function search() {
            $("#pageNumber").val("1");
            $("#hid_search").val(encodeURI($("#searchName").val()));
            pagesearch();
        }

        function pagesearch() {
            if ($('#UserForm').form('validate')) {
                UserForm.submit();
            }
        }
        function OperatUser(id, status, name) {
            topClick = true;
            showProcess(true, '温馨提示', '正在操作，请等待...');
            $.ajax({
                url: "jsonUpdateUserFlag.do?id=" + id + "&flag=" + status + "&name=" + name,
                type: "post",
                dataType: "json",
                success: function (data) {
                    showProcess(false);
                    if (data.code == 0) {
                        $.messager.alert('操作信息', data.message, 'info', function () {
                            window.location.href = "userList.do";
                        });
                    } else {
                        $.messager.alert('操作信息', data.message, 'error', function () {
                        });
                    }
                }
            });
        }
        function resetPwd(account) {
            showProcess(true, '温馨提示', '正在重置密码，请等待...');
            $.ajax({
                url: "jsonUpdateUserDefaultPwd.do?account=" + account,
                type: "post",
                dataType: "json",
                success: function (data) {
                    showProcess(false);
                    if (data.code == 0) {
                        $.messager.alert('操作信息', data.message, 'info', function () {
                            window.location.href = "userList.do";
                        });
                    } else {
                        $.messager.alert('操作信息', data.message, 'error', function () {
                        });
                    }
                }
            });
        }

    </script>
</head>

<body>

<div class="con-right" id="conRight">
    <div class="fl yw-lump">
        <div class="yw-lump-title">
            <i class="yw-icon icon-partner"></i><span>用户列表</span>
        </div>
    </div>

    <div class="fl yw-lump mt10">
        <form id="UserForm" name="UserForm" action="userList.do" method="get">
            <div class="pd10-28">
                <div class="fl">
                    <button class="yw-btn bg-blue cur">全部用户</button>
                </div>
                <!--  <div class="fl">
                     <button class="yw-btn bg-blue cur">硬件列表</button>
                     <button class="yw-btn bg-gray ml20 cur">满意度调查</button>
                 </div> -->
                <div class="fr">
                    <input type="text" id="searchName" validType="SpecialWord" style="width:150px;"
                           class="easyui-validatebox" placeholder="搜索关键字：账号或姓名" onkeydown="keyDown(event)" value="${user.searchName}"/>
                    <input type="hidden" name="searchName" id="hid_search" />
                    <input type="hidden" name="status" value="1" />
                    <span class="yw-btn bg-orange ml30 cur" onclick="search();">搜索</span>
                    <span class="yw-btn bg-green ml20 cur"
                          onclick="window.location.href='userInfo.do?userId=0'">新建</span>
                </div>
                <div class="cl"></div>
            </div>

            <input type="hidden" id="pageNumber" name="pageNo" value="${user.pageNo}"/>
        </form>
    </div>

    <div class="fl">
        <div class="fl yw-lump mlwid250 mt10">
            <div class="yw-cm-title">
                <span class="ml26">机构列表</span>
            </div>
            <div class="yw-organ-tree-list" style="height: 639px;">
                <ul id="treeList"></ul>
            </div>
        </div>
        <div class="yw-lump wid-atuo ml260s mt10">
            <div class="yw-cm-title">
                <span class="ml26">全部用户</span>
            </div>
            <table class="yw-cm-table yw-leftSide yw-bg-hover" id="userList">
                <tr style="background-color:#D6D3D3;font-weight: bold;">
                    <th width="4%" style="display:none"></th>
                    <th width="15"></th>
                    <th>用户名</th>
                    <th>用户账号</th>                    
                    <th>电子邮箱</th>
                    <th>组织机构</th>
                    <th>姓名</th>
                    <th>角色</th>
                    <th>显示水印</th>
                    <%--<th>多点登录</th>--%>
                    <th align="center">操作</th>
                </tr>
                <c:forEach var="item" items="${userList}">
                    <tr>
                        <td align="center" style="display:none">${item.id}</td>
                        <td></td>
                        <td onclick="window.location.href='userInfo.do?userId=${item.id}'"
                            align="left">${item.account}</td>
                        <td onclick="window.location.href='userInfo.do?userId=${item.id}'"
                            align="left">${item.mobile}</td>
                        <td onclick="window.location.href='userInfo.do?userId=${item.id}'"
                            align="left">${item.email}</td>
                        <td onclick="window.location.href='userInfo.do?userId=${item.id}'"
                            align="left">${item.organName}</td>
                        <td onclick="window.location.href='userInfo.do?userId=${item.id}'"
                            align="left">${item.name}</td>
                        <td onclick="window.location.href='userInfo.do?userId=${item.id}'"
                            align="left">${item.roleName}</td>
                        <%--<td onclick="window.location.href='userInfo.do?userId=${item.id}'" align="left">--%>
                            <%--<c:if test="${item.ismultilogin == 1}">--%>
                                <%--允许--%>
                            <%--</c:if>--%>
                            <%--<c:if test="${item.ismultilogin == 0}">--%>
                                <%--不允许--%>
                            <%--</c:if>--%>
                        <%--</td>--%>
                        <td onclick="window.location.href='userInfo.do?userId=${item.id}'" align="left">
                            <c:if test="${item.showmark == 1}">
                            显示
                            </c:if>
                            <c:if test="${item.showmark == 0}">
                            不显示
                            </c:if>
                        </td>
                        <td>
                            <c:if test="${item.flag == 1}">
                                <a href="javascript:void(0);" onclick="OperatUser('${item.id}',0,'${item.name}')"
                                   style="padding-left:5px;float:left;">禁用</a>
                            </c:if>
                            <c:if test="${item.flag == 0}">
                                <a href="javascript:void(0);" onclick="OperatUser('${item.id}',1,'${item.name}')"
                                   style="padding-left:5px;float:left;">启用</a>
                            </c:if>
                            <a href="javascript:void(0);" onclick="resetPwd('${item.account}')"
                               style="padding-left:5px;float:left;">重置密码</a>
                        </td>
                    </tr>
                </c:forEach>
            </table>
            <div class="page" id="pager">
            </div>
        </div>
    </div>
</div>
</body>
</html>
