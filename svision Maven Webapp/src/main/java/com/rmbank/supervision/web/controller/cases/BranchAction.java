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
import com.rmbank.supervision.service.UserService;
import com.rmbank.supervision.web.controller.SystemAction;
/**
 * 分行立项的Action
 * @author DELL
 *
 */
@Scope("prototype")
@Controller
@RequestMapping("/manage/branch")
public class BranchAction extends SystemAction {
	
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
	 * 分行立项列表
	 * @param request
	 * @param response
	 * @return
	 * @throws UnsupportedEncodingException 
	 */
	@RequestMapping("/branchList.do")
	@RequiresPermissions("manage/branch/branchList.do")
	public String branchList(Item item,
			@RequestParam(value="type", required=false) Integer type, 
			HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException{
		if (item.getSearchName() != null && item.getSearchName() != "") {
			String searchName = new String(item.getSearchName().getBytes(
					"iso8859-1"), "utf-8");
			item.setSearchName(searchName);
		}		
		if (item.getPageNo() == null){
			item.setPageNo(1);
		}
		//默认加载分行立项分行完成
		if(type==null || type==0){
			type=1;
		}
		item.setPageSize(Constants.DEFAULT_PAGE_SIZE);
		int totalCount = 0;
		totalCount=itemService.getItemCount(item);
		item.setTotalCount(totalCount);
		//获取项目分类的集合,用于搜索条件		
		List<Meta> meatListByKey = configService.getMeatListByKey(Constants.META_PROJECT_KEY);
		request.setAttribute("meatListByKey", meatListByKey);
		
		//当前登录用户所属的机构
		User loginUser = this.getLoginUser();
		List<Organ> userOrgByUserId = userService.getUserOrgByUserId(loginUser.getId());
		Integer logUserOrg = userOrgByUserId.get(0).getId(); //当前登录用户所属的机构ID
		Organ organ = userOrgByUserId.get(0);
		//获取项目列表,根据不同的机构类型加载不同的项目
		List<Item> itemList =null;
		if(organ.getOrgtype()==Constants.ORG_TYPE_1 || Constants.USER_SUPER_ADMIN_ACCOUNT.equals(loginUser.getAccount())){
			//成都分行监察室加载所有的项目
			itemList=itemService.getItemList(item);
		}else{
			//其他类型机构加载自己的立项和自己需要完成的立项
			item.setSupervisionOrgId(logUserOrg);
			item.setPreparerOrgId(logUserOrg);
			itemList=itemService.getItemListByLgOrg(item);
		}
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		for (Item it : itemList) {
			Date preparerTime = it.getPreparerTime();
			String format = formatter.format(preparerTime);
			it.setShowDate(format);
		}
		request.setAttribute("logUserOrg", logUserOrg);
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
		
		//封装到前台遍历机构集合
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
					if(rc1.getPid() == rc.getId() || path.equals(substring)){ 
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
