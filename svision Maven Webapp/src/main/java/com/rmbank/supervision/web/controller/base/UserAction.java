package com.rmbank.supervision.web.controller.base;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.rmbank.supervision.web.controller.SystemAction;


@Scope("prototype")
@Controller
@RequestMapping("/system/user")
public class UserAction extends SystemAction  {
	

		/**
	     * 用户管理
	     *
	     * @param request
	     * @param response
	     * @return
	     */
	    @RequestMapping(value = "/userList.do")
	    @RequiresPermissions("system/user/userList.do")
	    public String userList( 
	            HttpServletRequest request, HttpServletResponse response) { 
	        return "web/vision/efficiencyList";
	    }
		
}
