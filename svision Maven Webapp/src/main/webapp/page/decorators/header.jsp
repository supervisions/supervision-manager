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

<script type="text/javascript">
    $(document).ready(function () {
        $("#pwdForm").validate({
            rules: {
                password: {
                    required: true,
                    minlength: 4,
                    maxlength:22
                },
                newPassword: {
                    required: true,
                    minlength: 4,
                    maxlength:22
                },
                rePassword: {
                    required: true,
                    minlength: 4,
                    maxlength:22
                }
            },
            messages: {
                password: {
                    required: "请输入您的原密码",
                    minlength: "原密码长度为至少4个字符",
                    maxlength: "原密码长度为最长22个字符"
                },
                newPassword: {
                    required: "请输入新密码",
                    minlength: "新密码长度为至少4个字符",
                    maxlength: "新密码长度为最长22个字符"
                },
                rePassword:{
                    required: "请输入确认密码",
                    minlength: "确认长度为至少4个字符",
                    maxlength: "确认长度为最长22个字符"
                }
            }
        });
    });
    function saveNewPwd(){
        //判断两次输入密码是否相同
        var psw1=$("#newPassword").val();
        var psw2=$("#rePassword").val();
        if(psw2 != psw1){
            var confirmdia = BootstrapDialog.show({ title: "操作提示",closable: false, message:"两次输入的密码不一致" ,
                buttons: [{
                    label: '确定', action: function () {
                        confirmdia.close();
                    }
                }] });
            return false;
        }
        var userObj ={};
        userObj.id = document.pwdForm.id.value;
        userObj.password = document.pwdForm.password.value;
        userObj.newPassword = document.pwdForm.newPassword.value;
        userObj.rePassword = document.pwdForm.rePassword.value;
        $.ajax({
            url : "<%=basePath %>system/user/jsonUpdatePsd.do?s="+Math.random(),
            type : "post",
            dataType:"json",
            data:userObj,
            success : function(data) {
                if(data.code == returnResult.result_success){
                    $("#btn_cp_cancel").click();
                    var retDIa = BootstrapDialog.show({ title: "操作提示",closable: false, message:data.message ,
                        buttons: [{
                            label: '确定', action: function () {
                                retDIa.close();
                                document.pwdForm.password.value = "";
                                document.pwdForm.newPassword.value = "";
                                document.pwdForm.rePassword.value = "";
                            }
                        }] });
                }else{
                    var retDIa =  BootstrapDialog.show({title:"操作提示", message: data.message ,
                        buttons: [{
                            label: '确定', action: function () {
                                retDIa.close();
                            }
                        }] });
                }
            }
        });
    }

</script>

<div class="row border-bottom">
    <nav class="navbar navbar-static-top" role="navigation" style="margin-bottom: 0">
        <div class="navbar-header">
            <a class="navbar-minimalize minimalize-styl-2 btn btn-primary " href="#"><i class="fa fa-bars"></i> </a>
            <%--<form role="search" class="navbar-form-custom" method="post" action="search_results.html">--%>
                <%--<div class="form-group">--%>
                    <%--<input type="text" placeholder="请输入您需要查找的内容 …" class="form-control" name="top-search" id="top-search">--%>
                <%--</div>--%>
            <%--</form>--%>
        </div>
        <ul class="nav navbar-top-links navbar-right">
            <li>
                <span class="m-r-sm text-muted welcome-message"><a href="<%=basePath%>server/introduction.do" title="返回首页"><i class="fa fa-home"></i></a>欢迎使用云端超级应用平台</span>
            </li>
            <%--<li class="dropdown">
                <a class="dropdown-toggle count-info" data-toggle="dropdown" href="index.html#">
                    <i class="fa fa-envelope"></i> <span class="label label-warning">16</span>
                </a>
                <ul class="dropdown-menu dropdown-messages">
                    <li>
                        <div class="dropdown-messages-box">
                            <a href="profile.html" class="pull-left">
                                <img alt="image" class="img-circle" src="<%=basePath %>source/img/a7.jpg">
                            </a>
                            <div class="media-body">
                                <small class="pull-right">46小时前</small>
                                <strong>小四</strong> 项目已处理完结
                                <br>
                                <small class="text-muted">3天前 2014.11.8</small>
                            </div>
                        </div>
                    </li>
                    <li class="divider"></li>
                    <li>
                        <div class="dropdown-messages-box">
                            <a href="profile.html" class="pull-left">
                                <img alt="image" class="img-circle" src="<%=basePath %>source/img/a4.jpg">
                            </a>
                            <div class="media-body ">
                                <small class="pull-right text-navy">25小时前</small>
                                <strong>国民岳父</strong> 这是一条测试信息
                                <br>
                                <small class="text-muted">昨天</small>
                            </div>
                        </div>
                    </li>
                    <li class="divider"></li>
                    <li>
                        <div class="text-center link-block">
                            <a href="mailbox.html">
                                <i class="fa fa-envelope"></i> <strong> 查看所有消息</strong>
                            </a>
                        </div>
                    </li>
                </ul>
            </li>
            <li class="dropdown">
                <a class="dropdown-toggle count-info" data-toggle="dropdown" href="index.html#">
                    <i class="fa fa-bell"></i> <span class="label label-primary">8</span>
                </a>
                <ul class="dropdown-menu dropdown-alerts">
                    <li>
                        <a href="mailbox.html">
                            <div>
                                <i class="fa fa-envelope fa-fw"></i> 您有16条未读消息
                                <span class="pull-right text-muted small">4分钟前</span>
                            </div>
                        </a>
                    </li>
                    <li class="divider"></li>
                    <li>
                        <a href="profile.html">
                            <div>
                                <i class="fa fa-qq fa-fw"></i> 3条新回复
                                <span class="pull-right text-muted small">12分钟钱</span>
                            </div>
                        </a>
                    </li>
                    <li class="divider"></li>
                    <li>
                        <div class="text-center link-block">
                            <a href="notifications.html">
                                <strong>查看所有 </strong>
                                <i class="fa fa-angle-right"></i>
                            </a>
                        </div>
                    </li>
                </ul>
            </li>--%>
            <li>
                <a href="javascript:void(0);" onclick="javascript:void(0);"  data-toggle="modal" data-target="#pwdModal" >
                    <i class="fa fa-key"  ></i> 修改密码
                </a>
            </li>
            <li>
                <a href="javascript:void(0);" onclick="javascript:void(0);"  data-toggle="modal" data-target="#myModal" >
                    <i class="fa fa-sign-out"  ></i> 退出
                </a>
            </li>
        </ul>
    </nav>
</div>
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                    &times;
                </button>
                <h4 class="modal-title" id="myModalLabel">
                    确认退出
                </h4>
            </div>
            <div class="modal-body">
                确认退出当前登录？
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消
                </button>
                <button type="button" class="btn btn-primary" onclick="logout()">
                    确定
                </button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal -->
</div>

<div class="modal fade" id="pwdModal" tabindex="-1" role="dialog" aria-labelledby="pwdModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                    &times;
                </button>
                <h4 class="modal-title" id="pwdModalLabel">
                    修改密码
                </h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal m-t" id="pwdForm"  name="pwdForm" action="<%=basePath%>system/user/jsonUpdatePsd.do" method="post" style="max-height: 600px;overflow-x: hidden;">
                    <div class="form-group">
                        <label class="control-label form-label-item">当前用户：</label>
                        <div class="col-sm-4">
                            <input type="hidden" name="id" value="${sessionScope.userInfo.id}"/>
                            <label class="form-control" style="border: 0px;">${sessionScope.userInfo.name}</label>
                        </div>
                    </div>
                    <div class="hr-line-dashed"></div>
                    <div class="form-group">
                        <label class="control-label form-label-item">&nbsp;&nbsp;&nbsp;原密码：</label>
                        <div class="col-sm-8">
                            <input name="password" class="form-control" placeholder="请输入原密码"  type="text" autocomplete="off"  onfocus="this.type='password'" aria-required="true" aria-invalid="true" class="error"/>
                        </div>
                    </div>
                    <div class="hr-line-dashed"></div>
                    <div class="form-group">
                        <label class="control-label form-label-item">&nbsp;&nbsp;&nbsp;新密码：</label>
                        <div class="col-sm-8">
                            <input name="newPassword" class="form-control" placeholder="请输入新密码"  type="text" autocomplete="off"  onfocus="this.type='password'" aria-required="true" aria-invalid="true" class="error"/>
                        </div>
                    </div>
                    <div class="hr-line-dashed"></div>
                    <div class="form-group">
                        <label class="control-label form-label-item">确认密码：</label>
                        <div class="col-sm-8">
                            <input name="rePassword" class="form-control" placeholder="请输入确认密码"  type="text" autocomplete="off"  onfocus="this.type='password'" aria-required="true" aria-invalid="true" class="error"/>
                        </div>
                    </div>
                    <div class="hr-line-dashed"></div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal" id="btn_cp_cancel">取消
                </button>
                <button type="button" class="btn btn-primary"  onclick="saveNewPwd();" >
                    确定
                </button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal -->
</div>