package com.rmbank.supervision.web.controller.cases;

import java.io.UnsupportedEncodingException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import com.rmbank.supervision.model.FunctionResourceVM;
import com.rmbank.supervision.model.Item;
import com.rmbank.supervision.model.Meta;
import com.rmbank.supervision.model.Organ;
import com.rmbank.supervision.model.OrganVM;
import com.rmbank.supervision.model.ResourceConfig;
import com.rmbank.supervision.model.Role;
import com.rmbank.supervision.model.User;
import com.rmbank.supervision.service.ConfigService;
import com.rmbank.supervision.service.ItemService;
import com.rmbank.supervision.service.OrganService;
import com.rmbank.supervision.web.controller.SystemAction;
/**
 * 分行立项的Action
 * @author DELL
 *
 */
@Scope("prototype")
@Controller
@RequestMapping("/manage/branch")
public class BranchAction  extends SystemAction {
	
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
	 * 分行立项列表
	 * @param request
	 * @param response
	 * @return
	 * @throws UnsupportedEncodingException 
	 */
	@RequestMapping("/branchList.do")
	@RequiresPermissions("manage/branch/branchList.do")
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
	public String exitItem(HttpServletRequest request, HttpServletResponse response){
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
	
		return "web/manage/branch/branchInfo";
	}
	
	 /** 
	 * 新增,编辑项目
	 * @throws ParseException 
	 */
    @ResponseBody
    @RequestMapping(value = "/jsonSaveOrUpdateItem.do", method=RequestMethod.POST)
    @RequiresPermissions("manage/branch/jsonSaveOrUpdateItem.do")
    public JsonResult<Item> jsonSaveOrUpdateItem(Item item,
    		@RequestParam(value = "pTime", required = false) String pTime,
    		@RequestParam(value = "content", required = false) String content,
    		@RequestParam(value = "OrgId", required = false) Integer[] OrgIds,    		
    		HttpServletRequest request, HttpServletResponse response) throws ParseException{
    	
    	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    	Date date = sdf.parse(pTime);
    	item.setPreparerTime(date);
    	item.setPid(0);
    	item.setStageIndex(new Byte("0"));
    	item.setPreparerOrgId(0);
    	//获取当前登录用户
    	User u = this.getLoginUser();
    	item.setPreparerId(u.getId());
    	item.setSupervisionUserId(0);
    	//新建一个json对象 并赋初值
		JsonResult<Item> js = new JsonResult<Item>();
		js.setCode(new Integer(1));
		js.setMessage("保存项目信息失败!");
		
		boolean State =  false;
		try {
			//如为新增，则给id置0
			if (item.getId() == null || item.getId() == 0) {
				item.setId(0);					
			} 
			//如为编辑
			/*if (item.getId() > 0) {
				im.setId(item.getId());
				
				State = userService.saveOrUpdateUser(user,roleIds,orgIds,postId);
				if(State){
					js.setCode(new Integer(0));
					js.setMessage("保存用户信息成功!");
					return js;
				}else{
					return js;
				}
			}*/
			
			//创建用于新增时根据项目名称去查询项目是否存在的对象
			Item im = new Item();
			im.setName(item.getName());
			//根据name去数据库匹配，如编辑，则可以直接保存；如新增，则需匹配该项目是否重复
			List<Item> lc = itemService.getExistItem(im);
			if (lc.size() == 0) {  
				State = itemService.saveOrUpdateItem(item,OrgIds);
				//新增项目成功后返回的itemId 
				Integer itemId =item.getId();
				System.out.println(itemId);
				if(State){
					js.setCode(new Integer(0));
					js.setMessage("保存项目信息成功!");
					return js;
				}else{
					return js;
				}
			} else {
				js.setMessage("该项目已存在!");
				return js;
			} 
		}catch(Exception ex){
			ex.printStackTrace();
		}
		return js;
    }
    
    /**
     * 查看项目
     * @param request
     * @param response
     * @return
     */
    @RequestMapping("/showItem.do")
	@RequiresPermissions("manage/branch/showItem.do")
	public String showItem(
			@RequestParam(value="id", required=false) Integer id,
			HttpServletRequest request, HttpServletResponse response){
    	//根据项目id回显项目
    	Item showitem=null;
    	try {
    		showitem= itemService.selectByPrimaryKey(id);
		} catch (Exception e) {
			e.printStackTrace();
		}
    	
    	SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
    	showitem.setShowDate(formatter.format(showitem.getPreparerTime()));
    	request.setAttribute("Showitem", showitem);
    	return "web/manage/branch/showItem"; 
    }
    
    
    
    /**
     * 删除项目
     * @param id
     * @param request
     * @param response
     * @return
     */
    @ResponseBody
	@RequestMapping(value = "/jsondeleteItemById.do", method = RequestMethod.POST)
	@RequiresPermissions("manage/branch/jsondeleteItemById.do")
	public JsonResult<Item> jsondeleteItemById(
			@RequestParam(value = "id", required = false) Integer id,
			HttpServletRequest request, HttpServletResponse response) {
		
		// 新建一个json对象 并赋初值
		JsonResult<Item> js = new JsonResult<Item>();
		js.setCode(new Integer(1));
		js.setMessage("删除失败!");
		boolean state =false;
		try {				
			state= itemService.deleteItemById(id);
			if(state){
				js.setCode(new Integer(0));
				js.setMessage("删除成功!");
				return js;
			}else{
				return js;
			}			
		} catch (Exception e) {
			e.printStackTrace();
		}		
		return js;

	}
    /**
     * 跳转到操作页面
     * @param id
     * @param request
     * @param response
     * @return
     */
    @RequestMapping("/toOperate.do")
    @RequiresPermissions("manage/branch/toOperate.do")
    public String toOperate(
    		@RequestParam(value = "id", required = false) Integer id,
			HttpServletRequest request, HttpServletResponse response){
    		
    	return "web/manage/branch/operate";
    }
}
