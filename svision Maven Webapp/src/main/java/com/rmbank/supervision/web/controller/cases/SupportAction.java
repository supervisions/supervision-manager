package com.rmbank.supervision.web.controller.cases;

import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
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
import com.rmbank.supervision.model.Meta;
import com.rmbank.supervision.model.Organ;
import com.rmbank.supervision.model.OrganVM;
import com.rmbank.supervision.service.ConfigService;
import com.rmbank.supervision.service.ItemService;
import com.rmbank.supervision.service.OrganService;
import com.rmbank.supervision.web.controller.SystemAction;

/**
 * 中支立项Action
 * @author DELL
 *
 */
@Scope("prototype")
@Controller
@RequestMapping("/manage/support")
public class SupportAction extends SystemAction {

	/**
	 * 资源注入
	 */
	@Resource
	private ConfigService configService;
	@Resource
	private OrganService organService;
	@Resource
	private ItemService itemService;
	
	
	
	
	/**
	 * 中支立项列表
	 * @param request
	 * @param response
	 * @return
	 * @throws UnsupportedEncodingException 
	 */
	@RequestMapping("/supportList.do")
	@RequiresPermissions("manage/support/supportList.do")
	public String branchList(Item item,
			HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException{
		if (item.getSearchName() != null && item.getSearchName() != "") {
			String searchName = new String(item.getSearchName().getBytes(
					"iso8859-1"), "utf-8");
			item.setSearchName(searchName);
		}
		
		if (item.getPageNo() == null){
			item.setPageNo(1);
		}		
		item.setPageSize(Constants.DEFAULT_PAGE_SIZE);
		int totalCount = 0;
		totalCount=itemService.getItemCount(item);
		item.setTotalCount(totalCount);
		//获取项目分类的集合		
		List<Meta> meatListByKey = configService.getMeatListByKey(Constants.META_PROJECT_KEY);
		request.setAttribute("meatListByKey", meatListByKey);
		
		//获取项目列表
		List<Item> itemList=itemService.getItemList(item);
		
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		for (Item it : itemList) {
			Date preparerTime = it.getPreparerTime();
			String format = formatter.format(preparerTime);
			it.setShowDate(format);
			
		}
		request.setAttribute("itemList", itemList);
		request.setAttribute("Item", item);
		return "web/manage/support/supportList";
	}
	
	/**
	 * 跳转到新增项目
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/supportInfo.do")
	@RequiresPermissions("manage/support/supportInfo.do")
	public String exit(HttpServletRequest request, HttpServletResponse response){
		//获取项目分类的集合		
				List<Meta> meatListByKey = configService.getMeatListByKey(Constants.META_PROJECT_KEY);
				request.setAttribute("meatListByKey", meatListByKey);
				
				//获取机构
				Organ organ=new Organ();
				List<Organ> organList = organService.getOrganList(organ);
				//request.setAttribute("OrgList", organList);
				
				List<OrganVM> list=new ArrayList<OrganVM>();
				OrganVM frvm = null;
				for(Organ rc : organList){
					if(rc.getPid()==0){
						frvm = new OrganVM();
						List<Organ> itemList = new ArrayList<Organ>();//用于当做OrganVM的itemList
						frvm.setId(rc.getId());
						frvm.setName(rc.getName());
						for(Organ rc1 : organList){
							if(rc1.getPid() == rc.getId()){ 
								itemList.add(rc1);
							}
						}
						frvm.setItemList(itemList);
						list.add(frvm);
					}
				}
				request.setAttribute("OrgList", list);
		return "web/manage/support/supportInfo";
	}
}
