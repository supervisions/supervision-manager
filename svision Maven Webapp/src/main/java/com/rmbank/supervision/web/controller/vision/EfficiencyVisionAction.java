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
import org.springframework.web.bind.annotation.RequestParam;

import com.rmbank.supervision.common.utils.Constants;
import com.rmbank.supervision.model.Item;
import com.rmbank.supervision.model.Organ;
import com.rmbank.supervision.service.ItemService;

/**
 * 效能监察控制器
 * @author DELL
 *
 */
@Scope("prototype")
@Controller
@RequestMapping("/vision/efficiency")
public class EfficiencyVisionAction {
	
	@Resource
	private ItemService itemService;
	
	
		
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
    	return "web/vision/efficiencyList";
    }
    
    @RequestMapping(value = "/efficiencyInfo.do")
	@RequiresPermissions("vision/efficiency/efficiencyInfo.do")
	public String efficiencyInfo(
			@RequestParam(value = "id", required = false) Integer id,
			HttpServletRequest req, HttpServletResponse res) {

		// 根据参数id判断是新增还是编辑，新增为0，不用传值；编辑为选中的参数id值，取对象，传值
		/*if (id != null && id != 0) {
			Organ organ = new Organ();
			try {
				organ = organService.selectByPrimaryKey(id);
			} catch (Exception ex) {
				ex.printStackTrace();
			}
			req.setAttribute("Organ", organ);
		}*/
		return "web/vision/efficiencyInfo";
	}
}
