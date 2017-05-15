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

import com.rmbank.supervision.common.utils.Constants;
import com.rmbank.supervision.model.Item;
import com.rmbank.supervision.service.ItemService;
/**
 * 执法监察控制器
 * @author DELL
 *
 */
@Scope("prototype")
@Controller
@RequestMapping("/vision/enforce")
public class EnforcementVisionAction {

	@Resource
	private ItemService itemService;
	
	/**
	 * 执法监察模块页面跳转
	 * @param request
	 * @param response
	 * @return
	 * @throws UnsupportedEncodingException 
	 */
	@RequestMapping(value = "/enforceList.do")
    @RequiresPermissions("vision/enforce/enforceList.do")
	public String enforceList(Item item,
			HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException{
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

		request.setAttribute("itemList", itemList);
		return "web/vision/enforceList";
	}
}
