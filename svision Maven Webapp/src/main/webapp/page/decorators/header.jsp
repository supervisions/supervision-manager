<%@ page language="java" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    function gotoMainMenu(url,selectedMainMemu) {
        $.ajax({
            type : "post",
            url : "${pageContext.request.contextPath}/jsonLoadSession.do?selectedMainMemu="+selectedMainMemu,
            async : false
        });

        window.location.href = url;
    }
    function showdialog(){
        var wz = getDialogPosition($('#chgPwdWindow').get(0),100);
        $('#chgPwdWindow').window({
            onBeforeClose: function () {
            },
            onClose:function(){
                $('#chgPwdWindow .easyui-validatebox').val('');
                $("#hid_div_pwd").attr("style","display:none");
            }
        });
        $("#hid_div_pwd").removeAttr("style");
        $('#chgPwdWindow').window('open');
    }
    function saveNewPwd(obj){
        //判断两次输入密码是否相同
        var psw1=document.saveUserPwdForm.password.value;
        var psw2=document.saveUserPwdForm.checkpassword.value;
        if(psw2 != psw1){
            $.messager.alert('保存信息','两次输入的密码不一致');
            return false;
        }
        else{
            if ($('#saveUserPwdForm').form('validate')) {
                showProcess(true, '温馨提示', '正在提交数据...');
                $(obj).attr("onclick", "");
                $('#saveUserPwdForm').form('submit',{
                    success:function(data){
                        showProcess(false);
                        data = $.parseJSON(data);
                        if(data.code==0){
                            $('#chgPwdWindow').window('close');
                            $.messager.alert('保存信息',data.message,'info');
                        }else{
                            $.messager.alert('错误信息',data.message,'error');
                            $(obj).attr("onclick", "saveNewPwd(this);");
                        }
                    }
                });
            }
        }

    }

</script>
<div class="fl head-logo">
    <%--<div class="fl head-logo">--%>
        <img src="${pageContext.request.contextPath}/source/images/lo_title.jpg"  />  
</div>
<div class="fr head-menu">
    <ul class="fl">
        <c:forEach var="item" items="${sessionScope.userResources}">
            <li
                    <c:if test="${item.id == sessionScope.userInfo.selectedMainMemu}">
                        class="head-menu-now"
                    </c:if> onclick="gotoMainMenu('${pageContext.request.contextPath}/${item.url}','${item.id}')">
                    ${item.name}
            </li>
        </c:forEach>
    </ul>
    <div class="fl head-menu-right">
        <!-- <a href="#"><i class="fl yw-icon icon-dot"></i><span>你有新消息</span></a> -->
        <a href="javascript:void(0);" onclick="showdialog();"><i class="fl yw-icon icon-dot"></i><span  style="color:white;font-size:16px;">修改密码</span></a>
        <a href="${pageContext.request.contextPath}/logout.do"><i class="fl yw-icon icon-fork"></i><span  style="color:white;font-size:16px;">退出</span></a>
        <%--<a href="${pageContext.request.contextPath}/base/logout.do"><i class="fl yw-icon icon-fork"></i><span  style="color:white;font-size:16px;">退出</span></a>--%>
    </div>

</div>
<div id="hid_div_pwd" style="display:none">
<div id="chgPwdWindow" class="easyui-window" title="修改密码" style="width:560px;height:320px;overflow:hidden;padding:10px;text-align:center;" iconCls="icon-info" closed="true" modal="true"   resizable="false" collapsible="false" minimizable="false" maximizable="false">
    <form id="saveUserPwdForm" name ="saveUserPwdForm" action="${pageContext.request.contextPath}/base/jsonUpdatePsd.do"  method="post">
        <p style="display:none">
            <span>id：</span>
            <input name="id" type="hidden" value="${sessionScope.userInfo.id}" class="easyui-validatebox"/>
            <input name="account" type="hidden" value="${sessionScope.userInfo.account}" class="easyui-validatebox"/>
        </p>
        <p class="yw-window-p">
            <span>当前用户：</span><span style="width:254px;height:28px;">${sessionScope.userInfo.name}</span>

        </p>
        <p class="yw-window-p">
            <span>初始密码：</span><input name="oldPassword" type="password"   value="" class="easyui-validatebox" required="true"  placeholder="请输入原密码"   validType="Length[4,22]"style="width:254px;height:28px;"/>
            <span style="color:red">*</span>
        </p>
        <p class="yw-window-p">
            <span>&nbsp;&nbsp;&nbsp;新密码：</span><input  name=password type="password" value="" onblur="valueTrim(this);"   placeholder="请输入新密码"    class="easyui-validatebox" required="true"  validType="Length[4,22]" style="width:254px;height:28px;"/>
            <span style="color:red">*</span>
        </p>
        <p class="yw-window-p">
            <span>确认密码：</span><input   name=checkpassword type="password" value="" onblur="valueTrim(this);"   class="easyui-validatebox" required="true"   placeholder="请确认新密码"   validType="Length[4,22]" style="width:254px;height:28px;" />
            <span style="color:red">*</span>
        </p>
        <div class="yw-window-footer txt-right">
            <span id="btnCancel" class="yw-window-btn bg-lightgray mt12"  onclick="$('#saveUserPwdForm .easyui-validatebox').val('');$('#chgPwdWindow').window('close'); $('#hid_div_pwd').attr('style','display:none');">取消</span>
            <span class="yw-window-btn bg-blue mt12" onclick="saveNewPwd(this);">确定</span>
        </div>
    </form>
</div>
</div>
