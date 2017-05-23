package com.rmbank.supervision.web.controller.vision;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.text.ParseException;
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
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.rmbank.supervision.common.JsonResult;
import com.rmbank.supervision.common.utils.Constants;
import com.rmbank.supervision.model.Item;
import com.rmbank.supervision.model.Meta;
import com.rmbank.supervision.model.Organ;
import com.rmbank.supervision.model.OrganVM;
import com.rmbank.supervision.model.User;
import com.rmbank.supervision.service.ConfigService;
import com.rmbank.supervision.service.ItemService;
import com.rmbank.supervision.service.OrganService;
import com.rmbank.supervision.service.UserService;
import com.rmbank.supervision.web.controller.SystemAction;
/**
 * 廉政监察控制器
 * @author DELL
 *
 */
@Scope("prototype")
@Controller
@RequestMapping("/vision/incorrupt")
public class IncorruptVisionAction extends SystemAction {
	@Resource
	private ItemService itemService;
	@Resource
	private UserService userService;
	@Resource
	private OrganService organService;
	@Resource
	private ConfigService configService;
	
	
	/**
	 * 廉政监察列表
	 * @param request
	 * @param response
	 * @return
	 * @throws UnsupportedEncodingException 
	 */
	@RequestMapping(value = "/incorruptList.do")
    @RequiresPermissions("vision/incorrupt/incorruptList.do")
	public String incorruptList(Item item,
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
		//获取当前登录用户
		User loginUser = this.getLoginUser();
		//获取当前用户对应的机构列表
		List<Organ> userOrgList=userService.getUserOrgByUserId(loginUser.getId());
		//获取当前用户对应的第一个机构
		Organ userOrg=userOrgList.get(0);		
		// 分页集合
		List<Item> itemList = new ArrayList<Item>();
		try {
			//成都分行监察室和超级管理员加载所有的项目
			if(userOrg.getOrgtype()==Constants.ORG_TYPE_1 ||Constants.USER_SUPER_ADMIN_ACCOUNT.equals(loginUser.getAccount())){
				// 取满足要求的参数数据
				item.setSupervisionTypeId(3);
				item.setItemType(Constants.STATIC_ITEM_TYPE_SVISION);
				itemList = itemService.getItemListByType(item);
				// 取满足要求的记录总数
				totalCount = itemService.getItemCountBySSJC(item);
			}else {//获取当前用户需要完成的项目
				// 取满足要求的参数数据
				item.setSupervisionTypeId(3);
				item.setSupervisionOrgId(userOrg.getId());
				item.setItemType(Constants.STATIC_ITEM_TYPE_SVISION);
				itemList = itemService.getItemListByTypeAndLogOrg(item);
				// 取满足要求的记录总数
				totalCount = itemService.getItemCountByLogOrgSSJC(item);
			}			
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		// 通过request对象传值到前台
		item.setTotalCount(totalCount);
		request.setAttribute("Item", item);
		request.setAttribute("userOrg", userOrg);
		request.setAttribute("itemList", itemList);
		return "web/vision/incorrupt/incorruptList";
	}
	
	/**
     * 跳转到录入项目
     * @param id
     * @param req
     * @param res
     * @return
     */
    @RequestMapping(value = "/incorruptInfo.do")
	@RequiresPermissions("vision/incorrupt/incorruptInfo.do")
	public String efficiencyInfo(
			@RequestParam(value = "id", required = false) Integer id,
			HttpServletRequest request, HttpServletResponse response) {
    	
    	//获取机构
		Organ organ=new Organ();
		List<Organ> organList = organService.getOrganList(organ);		
    	List<OrganVM> list=new ArrayList<OrganVM>();
		OrganVM frvm = null;
		for(Organ rc : organList){
			if(rc.getPid()==0 && rc.getSupervision()==0){
				frvm = new OrganVM();
				List<Organ> itemList = new ArrayList<Organ>();//用于当做OrganVM的itemList
				frvm.setId(rc.getId());
				frvm.setName(rc.getName());
				for(Organ rc1 : organList){
					if(rc1.getPid() == rc.getId() && rc1.getSupervision()==0){ 
						itemList.add(rc1);
					}
				}
				frvm.setItemList(itemList);
				list.add(frvm);
			}
		}		
		//获取当前登录用户所属机构下的所有用户
		User lgUser = this.getLoginUser();
		List<User> byLgUser = userService.getUserListByLgUser(lgUser);
		//获取项目类别
		List<Meta> meatListByKey = configService.getMeatListByKey(Constants.META_ITEMCATEGORY_KEY);
		request.setAttribute("meatListByKey", meatListByKey);
		request.setAttribute("byLgUser", byLgUser);
		request.setAttribute("OrgList", list);	
		return "web/vision/incorrupt/incorruptInfo";
	}
	 /** 
   	 * 新增,编辑项目
   	 * @throws ParseException 
   	 */
   @ResponseBody
   @RequestMapping(value = "/jsonSaveOrUpdateItem.do", method=RequestMethod.POST)
   @RequiresPermissions("vision/incorrupt/jsonSaveOrUpdateItem.do")
   public JsonResult<Item> jsonSaveOrUpdateItem(Item item,
   		@RequestParam(value = "end_time", required = false) String end_time,//用于接收前台传过来的String类型的时间
   		@RequestParam(value = "content", required = false) String content,
   		@RequestParam(value = "OrgId", required = false) Integer[] OrgIds,    		
   		HttpServletRequest request, HttpServletResponse response) throws ParseException{
   	//将前台传过来的String类型的时间转换为Date类型
   	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   	Date date = sdf.parse(end_time);    	
   	item.setEndTime(date); //完成时间
   	item.setPreparerTime(new Date()); //立项时间
   	item.setItemType(Constants.STATIC_ITEM_TYPE_SVISION); //项目类型
   	item.setSupervisionTypeId(3);
   	item.setPid(0); //主任务节点的ID
   	item.setStageIndex(new Byte("0")); //工作阶段排序   	
   	//获取当前登录用户
   	User u = this.getLoginUser();
   	item.setPreparerId(u.getId()); //制单人的ID
   	item.setSupervisionUserId(0); //
   	//获取当前用户所属的机构id，当做制单部门的ID
   	List<Integer> userOrgIDs = userService.getUserOrgIdsByUserId(u.getId());
   	item.setPreparerOrgId(userOrgIDs.get(0)); //制单部门的ID
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
		//创建用于新增时根据项目名称去查询项目是否存在的对象
		Item im = new Item();
		im.setName(item.getName());
		//根据name去数据库匹配，如编辑，则可以直接保存；如新增，则需匹配该项目是否重复
		List<Item> lc = itemService.getExistItem(im);
		if (lc.size() == 0) {  
			State = itemService.saveOrUpdateItem(item,OrgIds,content);				
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
     * 删除项目
     * @param id
     * @param request
     * @param response
     * @return
     */
    @ResponseBody
	@RequestMapping(value = "/jsondeleteItemById.do", method = RequestMethod.POST)
	@RequiresPermissions("vision/incorrupt/jsondeleteItemById.do")
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
}
