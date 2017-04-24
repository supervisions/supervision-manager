package com.rmbank.supervision.web.controller.base;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.rmbank.supervision.model.Organ;
import com.rmbank.supervision.web.controller.SystemAction;


@Scope("prototype")
@Controller
@RequestMapping("/system/organ")
public class OrganAction extends SystemAction  {
	 @RequestMapping(value = "/organList.do")
	 @RequiresPermissions("system/organ/organList.do")
	 public String organList(Organ organ , 
			 HttpServletRequest request, HttpServletResponse response){ 
		 
		 return "web/base/organ/organList";
	 }

}
