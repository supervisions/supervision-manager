package com.rmbank.supervision.web.controller.vision;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
/**
 * 执法监察控制器
 * @author DELL
 *
 */
@Scope("prototype")
@Controller
@RequestMapping("/vision/enforce")
public class EnforcementVisionAction {

	/**
	 * 执法监察模块页面跳转
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "/enforceList.do")
    @RequiresPermissions("vision/enforce/enforceList.do")
	public String enforceList(HttpServletRequest request, HttpServletResponse response){
		
		return "web/vision/enforceList";
	}
}
