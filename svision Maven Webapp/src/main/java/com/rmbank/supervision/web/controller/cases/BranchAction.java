package com.rmbank.supervision.web.controller.cases;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.rmbank.supervision.common.utils.Constants;
import com.rmbank.supervision.model.Meta;
import com.rmbank.supervision.service.ConfigService;
/**
 * 分行立项的Action
 * @author DELL
 *
 */
@Scope("prototype")
@Controller
@RequestMapping("/manage/branch")
public class BranchAction {
	
	/**
	 * 资源注入
	 */
	@Resource
	private ConfigService configService;
	
	
	
	/**
	 * 分行立项列表
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/branchList.do")
	@RequiresPermissions("manage/branch/branchList.do")
	public String branchList(HttpServletRequest request, HttpServletResponse response){
		
		//获取项目分类的集合		
		List<Meta> meatListByKey = configService.getMeatListByKey(Constants.META_PROJECT_KEY);
		request.setAttribute("meatListByKey", meatListByKey);
		
		return "web/manage/branch/branchList";
	}
	
	/**
	 * 跳转到新增项目
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/branchInfo.do")
	@RequiresPermissions("manage/branch/branchInfo.do")
	public String exit(HttpServletRequest request, HttpServletResponse response){
		
		//获取项目分类的集合		
		List<Meta> meatListByKey = configService.getMeatListByKey(Constants.META_PROJECT_KEY);
		request.setAttribute("meatListByKey", meatListByKey);
		
		return "web/manage/branch/branchInfo";
	}

}
