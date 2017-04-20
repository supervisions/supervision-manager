<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
	function gotoChildMenu(url,selectedMainMemu,selectedChildMenu) {
		$.ajax({
			type : "post",
			url : "<%=basePath %>jsonLoadSession.do?selectedChildMenu="+selectedChildMenu+"&selectedMainMemu="+selectedMainMemu,
			async : false
		});
		var urlx = url;
		//alert(urlx.subString(urlx.length-3,3))
		if(url.lastIndexOf(".do")==url.length-3){
			urlx = urlx+"?s="+Math.random();
		}else{
			urlx = urlx+"&s="+Math.random();
		}

		window.location.href = urlx;

	}
</script>
<nav class="navbar-default navbar-static-side" role="navigation">
	<div class="nav-close"><i class="fa fa-times-circle"></i>
	</div>
	<div class="sidebar-collapse">
		<ul class="nav" id="side-menu">
			<li class="nav-header">
				<div class="dropdown profile-element">
					<a data-toggle="dropdown" class="dropdown-toggle" href="#">
                                <span class="clear">
                                    <span class="block m-t-xs" style="margin-top:20px;margin-bottom:20px;">
                                       <img src="<%=basePath %>source/img/logo.png">
                                    </span>
                                </span>
					</a>
				</div>
				<div class="logo-element"><img src="<%=basePath %>source/img/logo1.png">
				</div>
			</li>
			<c:forEach var="item" items="${sessionScope.userResources}" varStatus="status">
				<c:if test="${status.index == 0}">
					<li <c:if test="${item.id == sessionScope.userInfo.selectedMainMemu}">class="active" </c:if>>
						<a href="javascript:void(0);"  onclick="gotoChildMenu('<%=basePath%>${item.url}',${item.id},${item.id})">
							<i class="fa fa-home"></i>
							<span class="nav-label">${item.name}</span>
						</a>
					</li>
					<li class="line dk"></li>
				</c:if>
				<c:if test="${status.index > 0}">
					<li <c:if test="${item.id == sessionScope.userInfo.selectedMainMemu}">class="active" </c:if>>
						<a href="javascript:void(0);" >
							<i class="fa fa-cog"></i>
							<span class="nav-label">${item.name}</span>
							<span class="fa arrow"></span>
						</a>
						<c:if test="${item.childMenulist != null}">
							<ul class="nav nav-second-level">
								<c:forEach var="subItem" items="${item.childMenulist}">
									<li>
										<a class="J_menuItem <c:if test="${subItem.id == sessionScope.userInfo.selectedChildMenu}">subItem-select</c:if>" href="javascript:void(0);"  onclick="gotoChildMenu('<%=basePath%>${subItem.url}',${item.id},${subItem.id})">${subItem.name}</a>
									</li>
								</c:forEach>
							</ul>
						</c:if>
					</li>
					<li class="line dk"></li>
				</c:if>
			</c:forEach>

		</ul>
	</div>
</nav>