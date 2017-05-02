package com.rmbank.supervision.web.controller.cases;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * 方案明细的Action
 * @author DELL
 *
 */
@Scope("prototype")
@Controller
@RequestMapping("/manage/casedetail")
public class CasedetailAction {

	
	
	
	/**
	 * 方案管理列表
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/casedetailList.do")
	@RequiresPermissions("manage/casedetail/casedetailList.do")
	public String branchList(HttpServletRequest request, HttpServletResponse response){
		
		
		
		return "web/manage/casedetail/casedetailList";
	}
	
	/**
	 * 跳转到新增方案
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/casedetailInfo.do")
	@RequiresPermissions("manage/casedetail/casedetailInfo.do")
	public String exit(HttpServletRequest request, HttpServletResponse response){
		
		
		return "web/manage/casedetail/casedetailInfo";
	}
}
