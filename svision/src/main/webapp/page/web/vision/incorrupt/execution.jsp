<%@ page language="java" import="java.util.*" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
   <base href="<%=basePath%>">
  
   <title>廉政监察</title>
   
<meta name="viewport"
content="width=device-width, initial-scale=1, minimum-scale=1  ,maximum-scale=1, user-scalable=no" /> 
<!--
<link rel="stylesheet" type="text/css" href="styles.css">
-->

    <%--//////////--%>
    <%--<link type="text/css" rel="stylesheet" href="<%=basePath%>source/js/plupload/css/bootstrap.css" media="screen" />--%> 
	<script src="${pageContext.request.contextPath}/source/js/common/common.js"></script>
    <link type="text/css" rel="stylesheet" href="<%=basePath%>source/js/plupload/css/my.css" media="screen" />
    <link type="text/css" rel="stylesheet" href="<%=basePath%>source/js/plupload/css/prettify.css" media="screen" />
    <link type="text/css" rel="stylesheet" href="<%=basePath%>source/js/plupload/css/shCore.css" media="screen" />
    <link type="text/css" rel="stylesheet" href="<%=basePath%>source/js/plupload/css/shCoreEclipse.css" media="screen" />
    <link type="text/css" rel="stylesheet" href="<%=basePath%>source/js/plupload/css/jquery-ui.min.css" media="screen" />
    <link type="text/css" rel="stylesheet" href="<%=basePath%>source/js/plupload/css/jquery.ui.plupload.css" media="screen" />

    <script type="text/javascript" src="<%=basePath%>source/js/plupload/shCore.js" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=basePath%>source/js/plupload/shBrushjScript.js" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=basePath%>source/js/plupload/jquery-ui.min.js" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=basePath%>source/js/plupload/plupload.full.min.js" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=basePath%>source/js/plupload/jquery.ui.plupload.min.js" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=basePath%>source/js/plupload/zh_CN.js" charset="UTF-8"></script>
    
    <!-- 以下两个引的文件用于layer -->
	<link type="text/css" rel="stylesheet" href="<%=basePath%>source/js/layer/skin/layer.css"/>	
	<script src="<%=basePath%>source/js/layer/layer.js"></script>
    
    
    
    <!--[if lte IE 7]>
    <link rel="stylesheet" type="text/css" href="<%=basePath%>source/js/plupload/css/my_ie_lte7.css" />
    <![endif]-->
    <link href="<%=basePath%>source/js/plupload/css/Breeserif.css" rel="stylesheet" type="text/css">
    <!--[if IE]>
    <link href="<%=basePath%>source/js/plupload/css/opensans.css" rel="stylesheet" type="text/css">
    <link href="<%=basePath%>source/js/plupload/css/opensans-300.css" rel="stylesheet" type="text/css">
    <link href="<%=basePath%>source/js/plupload/css/opensans-400.css" rel="stylesheet" type="text/css">
    <link href="<%=basePath%>source/js/plupload/css/opensans-600.css" rel="stylesheet" type="text/css">
    <link href="<%=basePath%>source/js/plupload/css/opensans-700.css" rel="stylesheet" type="text/css">
    <link href="<%=basePath%>source/js/plupload/css/opensans-300s.css" rel="stylesheet" type="text/css">
    <link href="<%=basePath%>source/js/plupload/css/opensans-400s.css" rel="stylesheet" type="text/css">
    <link href="<%=basePath%>source/js/plupload/css/opensans-600s.css" rel="stylesheet" type="text/css">
    <link href="<%=basePath%>source/js/plupload/css/Breeserif-400.css" rel="stylesheet" type="text/css">
    <![endif]-->
    <!--[if IE 7]>
    <link rel="stylesheet" href="<%=basePath%>source/js/plupload/css/font-awesome-ie7.min.css">
    <![endif]-->
    <!--[if lt IE 9]>
    <script src="<%=basePath%>source/js/plupload/html5shiv.js"></script>
    <![endif]-->
    <%--///////////////////--%>

<script type="text/javascript">
	$(document).ready(function(){	  
	 	 	var len=32;//32长度
            var radix=16;//16进制
            var chars='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'.split('');
            var uuid=[],i;
            radix=radix||chars.length;
            if(len){
                for(i=0;i<len;i++){
                    uuid[i]=chars[0|Math.random()*radix];
                }
            }else{
                var r;
                uuid[8]=uuid[13]=uuid[18]=uuid[23]='-';
                uuid[14]='4';
                for(i=0;i<36;i++){
                    if(!uuid[i]){
                        r=0|Math.random()*16;
                        uuid[i]=chars[(i==19)?(r&0x3)|0x8:r];
                    }
                }
            }
            var v_uuid = uuid.join('');
            $("#hid_uuid").val(v_uuid);
            
            $("#uploader").plupload({
                // General settings
                runtimes : 'html5,flash,silverlight,html4',
                url : "<%=basePath%>system/upload/jsonUploadFile.do?uuid="+v_uuid,
                // Maximum file size
                max_file_size : '2999mb',
                // Rename files by clicking on their titles
                rename: true,
                // Sort files
                sortable: true,
                // Enable ability to drag'n'drop files onto the widget (currently only HTML5 supports that)
                dragdrop: true,
                // Views to activate
                max_retries: 0,
                views: {
                    list: true,
                    thumbs: false, // Show thumbs
                    active: 'list'
                },
                // Flash settings
                flash_swf_url : '/plupload/js/Moxie.swf',
                // Silverlight settings
                silverlight_xap_url : '/plupload/js/Moxie.xap'
            });
            var uploader = $('#uploader').plupload('getUploader');
            //绑定进度条
            uploader.bind('UploadProgress',function(uploader,file){
                //每个事件监听函数都会传入一些很有用的参数，
                //我们可以利用这些参数提供的信息来做比如更新UI，提示上传进度等操作
                var percentMsg = "正在上传文件，可能会花费一点时间，已上传:" + uploader.total.percent + "%";
                
            });
            //绑定文件添加
            uploader.bind('FilesAdded',function(uploader,files){
                if(null != files && files.length>0){
                    var cur_files = uploader.files;
                    var tmp_files = cur_files;
                    if(null != cur_files && cur_files.length>0){
                        for(var i=0;i<cur_files.length;i++){
                            var count = 0;
                            for(var j=0;j<tmp_files.length;j++){
                                if(cur_files[i].name == tmp_files[j].name){
                                    count++;
                                }
                            }
                            if(count > 1){
                                uploader.removeFile(cur_files[i]);
                                i--;
                            }
                        }
                    }
                }
            });
            //绑定文件是否全部上传完成
            uploader.bind('UploadComplete',function(uploader,files){
                if(null != files && files.length>0){ 
                	layer.confirm('录入执行情况成功！', {
								btn: ['确认'] //按钮
							}, function(){//点击确认按钮调用
								layer.close(layer.confirm());//关闭当前弹出层
								window.location.href = '<%=basePath%>vision/incorrupt/incorruptList.do';
							});	
                }
            });
            $("#uploader_browse").removeAttr("style");
            $("#uploader_browse").attr("style","z-index: 1;font-size: 12px;font-weight: normal;");
	 });
	 
	//新增/编辑项目
	function saveOpinion(obj){
		layer.confirm('确认信息已经填写完整，并且保存？', {
			btn: ['确认','取消'] //按钮
		}, function(){//点击确认按钮调用
			layer.close(layer.confirm());//关闭当前弹出层
			$.ajax({
		        cache: true, //是否缓存当前页面
		        type: "POST", //请求类型
		        url: "<%=basePath%>vision/incorrupt/jsonSaveExecution.do",
		        data:$('#itemInfoForm').serialize(),//发送到服务器的数据，序列化后的值
		        async: true, //发送异步请求	  
		        dataType:"json", //响应数据类型      
		        success: function(data) {
		        	if(data.code==0){ 
		        		var uploader = $('#uploader').plupload('getUploader');
			        	if(uploader.files.length>0){
			        		$("#uploader_start").click(); //上传文件
			        	}else{
			        		layer.confirm('录入执行情况成功！', {
								btn: ['确认'] //按钮
							}, function(){//点击确认按钮调用
								layer.close(layer.confirm());//关闭当前弹出层
								window.location.href = '<%=basePath%>vision/incorrupt/incorruptList.do';
							});		        		
			        	}
		        	}else{
		        		layer.alert(data.message);	        	
		        	}	
		        }
	   		});
		}, function(){
			
		});		
        
	}
	function downLoadFile(path,name){
		var filePath = encodeURI(encodeURI(path));
		var fileName = encodeURI(encodeURI(name));
		window.open("<%=basePath %>system/upload/downLoadFile.do?filePath="+filePath+"&fileName="+fileName);
	}
	function returnPage(){
		layer.confirm('当前项目资料尚未提交，是否离开当前页面？', {
			btn: ['确认','取消'] //按钮
		}, function(){//点击确认按钮调用
			layer.close(layer.confirm());//关闭当前弹出层
			window.location.href='<%=basePath%>vision/incorrupt/incorruptList.do';
		}, function(){
			
		});
	}
</script>
 </head> 
 <body>
<div class="con-right" id="conRight">
	<div class="fl yw-lump">
		<div class="yw-lump-title"> 												
				<i id="i_back" class="yw-icon icon-back" onclick="window.location.href='<%=basePath%>vision/incorrupt/incorruptList.do'"></i><span>项目列表</span>
		</div>
	</div>
	<div class="fl yw-lump mt10">
		<div class="yw-bi-rows">
			<div class="yw-bi-tabs mt5" id="ywTabs">
			<span class="yw-bi-now">基本信息</span>
				
			</div>
			<div class="fr">
				<!-- <span class="yw-btn bg-green mr26 hide" id="editBtn"  onclick="editTask();">编辑</span> -->
				
				
			</div>
		</div>
		<div style="width:100%;max-height:700px; overflow-x:hidden; ">
			<form id="itemInfoForm" name="itemInfoForm"
				action=""
				method="post">
				<div id="tab1" class="yw-tab">
					<table class="font16 taskTable" >						
						<tr>
							<td width="15%" align="right">项目名称：</td>
							<td colspan="3">
								 <label>${Item.name } </label> 
								<input type="hidden" value="0" name="id" />
                            	<%-- <input type="hidden" id="hid_uuid" name="uuid" />
                            	<input type="hidden" name="itemId" value="${Item.id }" />  
                            	<input type="hidden" name="contentTypeId" value="${ContentTypeId }" /> --%>
							</td> 
						</tr>
						<tr>
							<td align="right">项目分类：</td>
							<td colspan="3">
							 <label>${Item.sType } </label>   
							</td>								
						</tr>
						<%-- <tr>
							<td align="right">项目类别：</td>
							<td colspan="3">
							 <label>${Item.itemCategory } </label>   
							</td>								
						</tr> --%>
						<tr>
							<td align="right">立项时间：</td>
							<td colspan="3">
							 <label>${Item.preparerTimes } </label>   
							</td>								
						</tr>
						<tr>
							<td align="right" style="height:40px;">监察内容：</td>
							<td colspan="3">
							 <label>${ItemProcess.content } </label>  
							</td>		
						</tr> 
						<tr>
							<td align="right"style="height:80px;">附件列表：</td>
							<td colspan="3"> 
								<table style="width:100%;height:100%;min-height:80px;">
									<c:forEach var="fileItem" items="${ItemProcess.fileList }">
										<tr style="height:25px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
									</c:forEach> 
									
								</table>
							</td>		
						</tr>
						<tr>
							<td align="right" style="height:40px;">方案内容：</td>
							<td colspan="3">
								<label>${ItemProcess2.content } </label> 									
							</td>		
						</tr> 
						<tr>
							<td align="right" >方案附件：</td>
							<td colspan="3"> 
								<table style="width:100%;height:100%;min-height:80px;">
									<c:forEach var="fileItem" items="${ItemProcess2.fileList }">
										<tr style="height:25px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
									</c:forEach> 
									
								</table>
							</td>		
						</tr>
						<tr>
							<td align="right" style="height:40px;">监察意见：</td>
							<td colspan="3">
								<label>${ItemProcess3.content } </label>								
							</td>		
						</tr>
						<tr>
							<td align="right" >相关附件：</td>
							<td colspan="3"> 
								<table style="width:100%;height:100%;min-height:80px;">
									<c:forEach var="fileItem" items="${ItemProcess3.fileList }">
										<tr style="height:25px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
									</c:forEach> 
									
								</table>
							</td>		
						</tr>	
						<tr>
							<td align="right">是否合规：</td>
							<td colspan="3">
								<label>合规 </label> 									
							</td>		
						</tr>		
						<tr>
							<td align="right" style="height:40px;">会议决策：</td>
							<td colspan="3">
								<label>${ItemProcess6.content } </label>								 
							</td>		
						</tr>
						<tr>
							<td align="right" >相关附件：</td>
							<td colspan="3"> 
								<table style="width:100%;height:100%;min-height:80px;">
									<c:forEach var="fileItem" items="${ItemProcess6.fileList }">
										<tr style="height:25px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
									</c:forEach> 
									
								</table>
							</td>		
						</tr>
						<tr>
							<td align="right" style="height:40px;">监察意见：</td>
							<td colspan="3">
								<label>${ItemProcess4.content } </label> 								
							</td>		
						</tr>
						<tr>
							<td align="right" >相关附件：</td>
							<td colspan="3"> 
								<table style="width:100%;height:100%;min-height:80px;">
									<c:forEach var="fileItem" items="${ItemProcess4.fileList }">
										<tr style="height:25px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
									</c:forEach> 
									
								</table>
							</td>		
						</tr>
						<tr>
							<td align="right">是否有异议：</td>
							<td colspan="3">
								<label>无异议</label>									
							</td>		
						</tr>
						<c:if test="${ItemProcess11 != null && ItemProcess10==null}">
							<tr>
								<td align="right" style="height:40px;">监察执行情况意见：</td>
								<td colspan="3">
									<label>${ItemProcess11.content } </label> 									
								</td>		
							</tr>
							<tr>
								<td align="right" >相关附件：</td>
								<td colspan="3"> 
									<table style="width:100%;height:100%;min-height:80px;">
										<c:forEach var="fileItem" items="${ItemProcess11.fileList }">
											<tr style="height:25px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
										</c:forEach> 
										
									</table>
								</td>		
							</tr>
							<tr>
								<td align="right">执行情况是否合规：</td>
								<td colspan="3">
									<label>不合规</label> 									
								</td>		
							</tr>
							<tr>
								<td align="right">是否问责：</td>
								<td colspan="3">
									<label>不问责</label> 									
								</td>		
							</tr> 						
						    <%-- <tr>
								<td align="right" >相关附件：</td>
								<td colspan="3"> 
									<table style="width:100%;height:100%;min-height:80px;">
										<c:forEach var="fileItem" items="${ItemProcess11.fileList }">
											<tr style="height:25px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
										</c:forEach> 
										
									</table>
								</td>		
							</tr> --%>
						</c:if>
						<!-- 需要问责，问责前一节点的监察意见 -->
						<c:if test="${ItemProcess10 != null}">
							<tr>
								<td align="right" style="height:40px;">对执行情况的意见：</td>
								<td colspan="3">
									<label>${ItemProcess10.content } </label> 									
								</td>		
							</tr>
							<tr>
								<td align="right" >相关附件：</td>
								<td colspan="3"> 
									<table style="width:100%;height:100%;min-height:80px;">
										<c:forEach var="fileItem" items="${ItemProcess10.fileList }">
											<tr style="height:25px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
										</c:forEach> 
										
									</table>
								</td>		
							</tr>
							<tr>
								<td align="right" style="height:40px;">执行情况是否合规</td>
								<td colspan="3">
									<label>不合规</label> 									
								</td>		
							</tr>
							<tr>
								<td align="right" style="height:40px;">是否问责：</td>
								<td colspan="3">
									<label>问责</label> 									
								</td>		
							</tr>
						</c:if>
						<!-- 问责相关资料 -->
						<c:if test="${ItemProcess12 != null }">
							<tr>
								<td align="right" style="height:40px;">问责资料：</td>
								<td colspan="3">
									<label>${ItemProcess12.content } </label> 									
								</td>		
							</tr>
							<tr>
								<td align="right" >相关附件：</td>
								<td colspan="3"> 
									<table style="width:100%;height:100%;min-height:80px;">
										<c:forEach var="fileItem" items="${ItemProcess12.fileList }">
											<tr style="height:20px"><td style="border:0px;"><a title="点击下载" onclick="downLoadFile('${fileItem.filePath}','${fileItem.fileName}');" style="color:blue;cursor: pointer;">${fileItem.fileName}</a></td></tr>
										</c:forEach> 
										
									</table>
								</td>		
							</tr> 										
						</c:if>				
						<tr>
							<td align="right" width="15%" align="right" height="40px;">执行情况：</td>
							<td colspan="3" > 
								<textarea rows="3" cols="5" style="width:60%;" name="content"></textarea>								
								<input type="hidden" name ="itemId" value="${Item.id }">
								<input type="hidden" id="hid_uuid" name="uuid" />
							</td> 
						</tr>	
						<tr>
							<td align="right" height="129px;">上传附件：</td>
							<td colspan="3">
									<input type="hidden" id="hid_isFileUpload" value="1" /> 
								 <div id="themeswitcher" class="pull-right"></div>
					                <script>
					                    $(function() {
					                        $.fn.themeswitcher && $('#themeswitcher').themeswitcher({cookieName:''});
					                    });
					                </script>
					                <div id="uploader">
					                </div>
							 </td>	
						</tr>						
						<tr>
							<td></td>
							<td>
								<span class="yw-btn bg-red" style="margin-left: 10px;" id="saveBtn" onclick="saveOpinion(this);">提交</span>
								<span class="yw-btn bg-green" style="margin-left: 50px;margin-right: 10px;" onclick="returnPage();">返回</span>
							</td>
							
						</tr>
					</table>
				</div>
			</form>
		</div> </div>
	
	<div class="cl"></div>
</div>
<div class="cl"></div>
</div> 
</body>
</html>  
