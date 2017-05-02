package com.rmbank.supervision.web.controller.cases;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;



/**
 * 方案管理的Action
 * @author DELL
 *
 */
@Scope("prototype")
@Controller
@RequestMapping("/manage/casemanage")
public class CasemanageAction {

	/**
	 * 方案管理列表
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/casemanageList.do")
	@RequiresPermissions("manage/casemanage/casemanageList.do")
	public String branchList(HttpServletRequest request, HttpServletResponse response){
		
		
		
		return "web/manage/casemanage/casemanageList";
	}
	
	/**
	 * 跳转到新增方案
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/casemanageInfo.do")
	@RequiresPermissions("manage/casemanage/casemanageInfo.do")
	public String exit(HttpServletRequest request, HttpServletResponse response){
		
		
		return "web/manage/casemanage/casemanageInfo";
	}

}
