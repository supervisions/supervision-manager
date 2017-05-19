package com.rmbank.supervision.web.controller.cases;

import java.io.UnsupportedEncodingException;
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
	@Resource
	private UserService userService;
	
	
	
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

		//当前登录用户所属的机构
		User loginUser = this.getLoginUser();
		List<Organ> userOrgByUserId = userService.getUserOrgByUserId(loginUser.getId());
		Integer logUserOrg = userOrgByUserId.get(0).getId(); //当前登录用户所属的机构ID
		Organ organ = userOrgByUserId.get(0);
		//获取项目列表,根据不同的机构类型加载不同的项目
		List<Item> itemList =null;
		if(Constants.USER_SUPER_ADMIN_ACCOUNT.equals(loginUser.getAccount())){
			//成都分行监察室加载所有的项目
			//itemList=itemService.getItemList(item);
			item.setOrgTypeA(Constants.ORG_TYPE_3);
			item.setOrgTypeB(Constants.ORG_TYPE_4);
			itemList=itemService.getItemListByOrgType(item);
		}else{
			//中支机构只加载中支立的项目
			item.setOrgTypeA(Constants.ORG_TYPE_3);
			item.setOrgTypeB(Constants.ORG_TYPE_4);
			item.setSupervisionOrgId(logUserOrg);
			item.setPreparerOrgId(logUserOrg);
			itemList=itemService.getItemListByOrgTypeAndLogOrg(item);
		}
		
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
				
		List<OrganVM> list=new ArrayList<OrganVM>();
		OrganVM frvm = null;
		for(Organ rc : organList){
			if(rc.getPid()==0){
				frvm = new OrganVM();
				List<Organ> itemList = new ArrayList<Organ>();//用于当做OrganVM的itemList
				frvm.setId(rc.getId());
				frvm.setName(rc.getName());
				String path = frvm.getId()+".";
				for(Organ rc1 : organList){
					int pl=frvm.getId().toString().length();
					String path2 = rc1.getPath();
					String substring =null;					
					if(path2.length()>pl){
						substring= path2.substring(0, pl+1);						
					}		
					if(rc1.getPid() == rc.getId() && rc1.getOrgtype()!=46 && rc1.getOrgtype()!=47){ 
						itemList.add(rc1);
					}else if(rc1.getOrgtype()!=46 && rc1.getOrgtype()!=47 && path.equals(substring)){
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
	/** 
	 * 新增,编辑项目
	 * @throws ParseException 
	 */
    @ResponseBody
    @RequestMapping(value = "/jsonSaveOrUpdateItem.do", method=RequestMethod.POST)
    @RequiresPermissions("manage/support/jsonSaveOrUpdateItem.do")
    public JsonResult<Item> jsonSaveOrUpdateItem(Item item,
    		@RequestParam(value = "pTime", required = false) String pTime,//用于接收前台传过来的String类型的时间
    		@RequestParam(value = "content", required = false) String content,
    		@RequestParam(value = "OrgId", required = false) Integer[] OrgIds,    		
    		HttpServletRequest request, HttpServletResponse response) throws ParseException{
    	//将前台传过来的String类型的时间转换为Date类型
    	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    	Date date = sdf.parse(pTime);    	
    	item.setPreparerTime(date); //制单时间
    	item.setItemType(Constants.STATIC_ITEM_TYPE_MANAGE); //项目类型
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
} 
