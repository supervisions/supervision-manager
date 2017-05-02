package com.rmbank.supervision.web.controller.vision;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * 效能监察控制器
 * @author DELL
 *
 */
@Scope("prototype")
@Controller
@RequestMapping("/vision/efficiency")
public class EfficiencyVisionAction {
	
		
		/**
	     * 效能监察模块页面跳转
	     *
	     * @param request
	     * @param response
	     * @return
	     */
	    @RequestMapping(value = "/efficiencyList.do")
	    @RequiresPermissions("vision/efficiency/efficiencyList.do")
	    public String userList( 
	            HttpServletRequest request, HttpServletResponse response) { 
	        return "web/vision/efficiencyList";
	    }
}
