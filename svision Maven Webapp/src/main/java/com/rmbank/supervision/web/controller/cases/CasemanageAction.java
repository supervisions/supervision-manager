package com.rmbank.supervision.web.controller.cases;


import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.rmbank.supervision.common.JsonResult;
import com.rmbank.supervision.common.utils.Constants;
import com.rmbank.supervision.model.FunctionMenu;
import com.rmbank.supervision.model.GradeScheme;
import com.rmbank.supervision.model.Role;
import com.rmbank.supervision.model.User;
import com.rmbank.supervision.service.GradeSchemeService;



/**
 * 方案管理的Action
 * @author DELL
 *
 */
@Scope("prototype")
@Controller
@RequestMapping("/manage/casemanage")
public class CasemanageAction {

	@Resource
	private GradeSchemeService gradeSchemeService;
	
	
	/**
	 * 方案管理列表
	 * @param request
	 * @param response
	 * @return
	 * @throws UnsupportedEncodingException 
	 */
	@RequestMapping("/casemanageList.do")
	@RequiresPermissions("manage/casemanage/casemanageList.do")
	public String branchList(GradeScheme gradeScheme,
			HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException{
		
		if(gradeScheme.getSearchName() != null && gradeScheme.getSearchName() != ""){
			String searchName = new String(gradeScheme.getSearchName().getBytes(
					"iso8859-1"), "utf-8");
			gradeScheme.setSearchName(searchName);
		}
		//设置页面初始值及页面大小
		if (gradeScheme.getPageNo() == null)
			gradeScheme.setPageNo(1);
		gradeScheme.setPageSize(Constants.DEFAULT_PAGE_SIZE);  
		int totalCount =  0;
		//分页集合
		List<GradeScheme> gradeSchemeList = new ArrayList<GradeScheme>();
		try{
			//取满足要求的参数数据
			gradeSchemeList =  gradeSchemeService.getGradeSchemeList(gradeScheme);
			
			//取满足要求的记录总数
			totalCount = gradeSchemeService.getGradeSchemeCount(gradeScheme);
		}catch(Exception ex){ 
			ex.printStackTrace();
		}			
		gradeScheme.setTotalCount(totalCount); 	
		//通过request对象传值到前台
		request.setAttribute("GradeScheme", gradeScheme);    	
    	request.setAttribute("GradeSchemeList", gradeSchemeList);
		
		
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
	public String exitGradeScheme(@RequestParam(value = "id", required = false) Integer id,
			HttpServletRequest request, HttpServletResponse response){
		//根据参数id判断是新增还是编辑，新增为0，不用传值；编辑为选中的参数id值，取对象，传值
		if(id != null && id != 0){
			GradeScheme gradeScheme = new GradeScheme();
			try{
				gradeScheme = gradeSchemeService.selectByPrimaryKey(id);
			}catch(Exception ex){
				ex.printStackTrace();
			}
			request.setAttribute("GradeScheme", gradeScheme);
		}
		
		return "web/manage/casemanage/casemanageInfo";
	}
	
	/**
	 * 新增/编辑方案
	 * @param scheme
	 * @param request
	 * @param response
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="/jsonSaveOrUpdateGradeScheme.do", method = RequestMethod.POST)
	@RequiresPermissions("manage/casemanage/jsonSaveOrUpdateGradeScheme.do")
	public JsonResult<GradeScheme> jsonSaveOrUpdateRole(GradeScheme scheme,
			HttpServletRequest request, HttpServletResponse response) {

		// 新建一个json对象 并赋初值
		JsonResult<GradeScheme> js = new JsonResult<GradeScheme>();
		js.setCode(new Integer(1));
		js.setMessage("保存失败!");
		boolean state = false;
		try {
			// 如为新增，则给id置0
			if (scheme.getId() == null || scheme.getId() == 0) {
				scheme.setId(0);
			}

			GradeScheme sch = new GradeScheme();
			sch.setId(scheme.getId());
			sch.setName(scheme.getName());
			// 如为编辑，则给新建role对象赋传来的id值
			if (scheme.getId() > 0) {
				sch.setId(scheme.getId());
				state= gradeSchemeService.saveOrUpdateScheme(scheme);
				if (state) {
					js.setCode(new Integer(0));
					js.setMessage("保存成功!");
					return js;
				} else {
					return js;
				}
			}
			// 根据设备编号和id去数据库匹配，如编辑，则可以直接保存；如新增，则需匹配设备编号是否重复
			List<GradeScheme> lc = gradeSchemeService.getExistGradeScheme(sch);
			if (lc.size() == 0) {
				state = gradeSchemeService.saveOrUpdateScheme(scheme);
				if (state) {
					js.setCode(new Integer(0));
					js.setMessage("保存成功!");
					return js;
				} else {
					return js;
				}
			} else {
				js.setMessage("该方案已存在!");
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return js;
	}
	 /**
     * 删除方案
     */
    @ResponseBody
	@RequestMapping(value = "/jsondeleteGradeSchemeById.do", method = RequestMethod.POST)
	@RequiresPermissions("manage/casemanage/jsondeleteGradeSchemeById.do")
	public JsonResult<GradeScheme> jsondeleteGradeSchemeById(
			@RequestParam(value = "id", required = false) Integer id,
			HttpServletRequest request, HttpServletResponse response) {
		
		// 新建一个json对象 并赋初值
		JsonResult<GradeScheme> js = new JsonResult<GradeScheme>();
		js.setCode(new Integer(1));
		js.setMessage("删除失败!");
		try {					
			int state= gradeSchemeService.deleteByPrimaryKey(id);
			if(state==1){
				js.setCode(new Integer(0));
				js.setMessage("删除成功!");
				return js;
			}else {
				return js;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}			
		return js;
	}
    /**
     * 修改方案状态
     */
    @ResponseBody
	@RequestMapping(value = "/jsonupdateGradeSchemeById.do", method = RequestMethod.POST)
	@RequiresPermissions("manage/casemanage/jsonupdateGradeSchemeById.do")
	public JsonResult<GradeScheme> jsonupdateGradeSchemeById(GradeScheme gradeScheme,			
			HttpServletRequest request, HttpServletResponse response) {
		
		// 新建一个json对象 并赋初值
		JsonResult<GradeScheme> js = new JsonResult<GradeScheme>();
		js.setCode(new Integer(1));
		js.setMessage("修改方案状态失败!");
		
		if(gradeScheme.getUsed()==1){
			gradeScheme.setUsed(0);
		}else if(gradeScheme.getUsed()==0){
			gradeScheme.setUsed(1);
		}
		try {					
			int state= gradeSchemeService.updateByPrimaryKeySelective(gradeScheme);
			if(state==1){
				js.setCode(new Integer(0));
				js.setMessage("修改方案状态成功!");
				return js;
			}else {
				return js;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}			
		return js;
	}
    
    
    

}
