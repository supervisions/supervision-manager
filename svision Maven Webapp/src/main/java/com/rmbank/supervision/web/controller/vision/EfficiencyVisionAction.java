package com.rmbank.supervision.web.controller.vision;

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
import com.rmbank.supervision.model.Item;
import com.rmbank.supervision.model.Organ;
import com.rmbank.supervision.model.User;
import com.rmbank.supervision.service.ItemService;
import com.rmbank.supervision.service.UserService;
import com.rmbank.supervision.web.controller.SystemAction;

/**
 * 效能监察控制器
 * @author DELL
 *
 */
@Scope("prototype")
@Controller
@RequestMapping("/vision/efficiency")
public class EfficiencyVisionAction extends SystemAction {
	
	@Resource
	private ItemService itemService;
	@Resource
	private UserService userService;
	
		
	/**
     * 效能监察模块页面跳转
     *
     * @param request
     * @param response
     * @return
	 * @throws UnsupportedEncodingException 
     */
    @RequestMapping(value = "/efficiencyList.do")
    @RequiresPermissions("vision/efficiency/efficiencyList.do")
    public String efficiencyList(Item item, 
            HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException { 
    	// 判断搜索名是否为空，不为空则转为utf-8编码
		if (item.getSearchName() != null && item.getSearchName() != "") {
			String searchName = URLDecoder.decode(item.getSearchName(),"utf-8");
			item.setSearchName(searchName);
		}
		// 设置页面初始值及页面大小
		if (item.getPageNo() == null)
			item.setPageNo(1);
		item.setPageSize(Constants.DEFAULT_PAGE_SIZE);
		int totalCount = 0;
		
		//获取当前登录用户
		User loginUser = this.getLoginUser();
		//获取当前用户对应的机构列表
		List<Organ> userOrgList=userService.getUserOrgByUserId(loginUser.getId());
		//获取当前用户对应的第一个机构
		Organ userOrg=userOrgList.get(0);
		
		// 分页集合
		List<Item> itemList = new ArrayList<Item>();
		try {			
			// 取满足要求的参数数据
			item.setSupervisionTypeId(2);
			itemList = itemService.getItemListByType(item);
			// 取满足要求的记录总数
			totalCount = itemService.getItemCount(item);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		// 通过request对象传值到前台
		item.setTotalCount(totalCount);
		request.setAttribute("Item", item);
		request.setAttribute("userOrg", userOrg);
		request.setAttribute("itemList", itemList);
    	return "web/vision/efficiencyList";
    }
    
    /**
     * 跳转到录入项目
     * @param id
     * @param req
     * @param res
     * @return
     */
    @RequestMapping(value = "/efficiencyInfo.do")
	@RequiresPermissions("vision/efficiency/efficiencyInfo.do")
	public String efficiencyInfo(
			@RequestParam(value = "id", required = false) Integer id,
			HttpServletRequest req, HttpServletResponse res) {
    	
		
		return "web/vision/efficiencyInfo";
	}
    
    
    /**
     * 修改立项状态
     */
    @ResponseBody
	@RequestMapping(value = "/jsonsetProjectById.do", method = RequestMethod.POST)
	@RequiresPermissions("vision/efficiency/jsonsetProjectById.do")
	public JsonResult<Item> jsonsetProjectById(
			@RequestParam(value = "id", required = false) Integer id,
			HttpServletRequest request, HttpServletResponse response) {
		
		// 新建一个json对象 并赋初值
		JsonResult<Item> js = new JsonResult<Item>();
		js.setCode(new Integer(1));
		js.setMessage("修改立项状态失败!");			
		
		try {		
			Item item =new Item();
			item.setId(id);
			
			item.setStatus(1);
			int state = itemService.updateByPrimaryKeySelective(item);
			if(state==1){
				js.setCode(new Integer(0));
				js.setMessage("修改立项状态成功!");
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
