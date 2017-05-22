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
import javax.servlet.http.HttpSession;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.rmbank.supervision.common.JsonResult;
import com.rmbank.supervision.common.utils.Constants;
import com.rmbank.supervision.model.GradeScheme;
import com.rmbank.supervision.model.Item;
import com.rmbank.supervision.model.ItemProcess;
import com.rmbank.supervision.model.ItemProcessFile;
import com.rmbank.supervision.model.Meta;
import com.rmbank.supervision.model.Organ;
import com.rmbank.supervision.model.OrganVM;
import com.rmbank.supervision.model.User;
import com.rmbank.supervision.service.ConfigService;
import com.rmbank.supervision.service.GradeSchemeService;
import com.rmbank.supervision.service.ItemProcessFileService;
import com.rmbank.supervision.service.ItemProcessService;
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
	private ItemProcessService itemProcessService;
	@Resource
	private ItemProcessFileService itemProcessFileService;
	@Resource
	private UserService userService;
	

	@Resource
	private GradeSchemeService gradeSchemeService;
	
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
		if(organ.getOrgtype()==Constants.ORG_TYPE_1 ||Constants.USER_SUPER_ADMIN_ACCOUNT.equals(loginUser.getAccount())){
			//成都分行监察室和超级管理员加载所有的中支立项项目
			//itemList=itemService.getItemList(item);
			item.setItemType(Constants.STATIC_ITEM_TYPE_MANAGE);
			item.setOrgTypeA(Constants.ORG_TYPE_3);
			item.setOrgTypeB(Constants.ORG_TYPE_4);
			itemList=itemService.getItemListByOrgType(item);
			totalCount=itemService.getItemCountZZLXALL(item);
		}else{
			//当前登录机构只加载当前登录中支立的项目和子机构完成的项目
			item.setItemType(Constants.STATIC_ITEM_TYPE_MANAGE);
			item.setOrgTypeA(Constants.ORG_TYPE_3);
			item.setOrgTypeB(Constants.ORG_TYPE_4);
			item.setSupervisionOrgId(logUserOrg);
			item.setPreparerOrgId(logUserOrg);
			itemList=itemService.getItemListByOrgTypeAndLogOrg(item);
			totalCount=itemService.getItemCountZZLX(item);
		}		
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		for (Item it : itemList) {
			Date preparerTime = it.getPreparerTime();
			String format = formatter.format(preparerTime);
			it.setShowDate(format); 
		}
		item.setTotalCount(totalCount);
		request.setAttribute("itemList", itemList);
		request.setAttribute("Item", item);
		request.setAttribute("UserOrgId", logUserOrg);
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
		
		//获取当前用户的机构
		User lgUser=this.getLoginUser();
		List<Integer> userOrgIds=userService.getUserOrgIdsByUserId(lgUser.getId());
		Integer userOrgID = userOrgIds.get(0);		
		List<OrganVM> list=new ArrayList<OrganVM>();
		OrganVM frvm = null;
		for(Organ rc : organList){
			if(rc.getId()==userOrgID){
				frvm = new OrganVM();
				List<Organ> itemList = new ArrayList<Organ>();//用于当做OrganVM的itemList
				frvm.setId(rc.getId());
				frvm.setName(rc.getName());
				itemList.add(rc);
				String path =rc.getPath()+"."+rc.getId()+".";//当前登录机构的子机构的path都以此开头
				String substring=null;
				for(Organ rc1 : organList){
					if(rc1.getPath().length()>path.length()){
						substring=rc1.getPath().substring(0, path.length());
					}
					if(rc1.getPid() == rc.getId()){//添加子级节点						
						itemList.add(rc1);
					}else if(path.equals(substring)){//添加孙子级节点	
						itemList.add(rc1);								
					}
				}
				frvm.setItemList(itemList);
				list.add(frvm);
			}
		}
		request.setAttribute("OrgList", list);
		request.setAttribute("ContentTypeId", Constants.CONTENT_TYPE_ID_ZZZZ);
		return "web/manage/support/supportInfo";
	}
	

	/**
	 * 跳转到继续上传资料
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/supportFile.do")
	@RequiresPermissions("manage/support/supportFile.do")
	public String supportFile(Item item,
			HttpServletRequest request, HttpServletResponse response){

		int isValue = item.getIsValue(); 
		item = itemService.selectByPrimaryKey(item.getId());
		if(item.getPreparerTime() != null){
			item.setPreparerTimes(Constants.DATE_FORMAT.format(item.getPreparerTime()));
		}
		List<ItemProcess> itemProcessList = itemProcessService.getItemProcessItemId(item.getId()); 
		ItemProcess itemProcess = new ItemProcess();
		if(itemProcessList.size()>0){
			itemProcess = itemProcessList.get(0); 
		}
		
		List<ItemProcessFile> fileList = new ArrayList<ItemProcessFile>();
		if(itemProcess.getId() != null){
			fileList = itemProcessFileService.getFileListByItemId(itemProcess.getId());
		}
		//获取当前用户
		User lgUser=this.getLoginUser(); 
		 
		if(itemProcess.getIsValue()==Constants.IS_VALUE){
			List<GradeScheme> gradeList =  gradeSchemeService.getGradeSchemeList(new GradeScheme());
			request.setAttribute("GradeList", gradeList);
		} 
		
		request.setAttribute("User", lgUser);
		request.setAttribute("IsValue", isValue);
		request.setAttribute("ItemProcess", itemProcess);
		request.setAttribute("Item", item);
		request.setAttribute("FileList", fileList);
		request.setAttribute("ContentTypeId", Constants.CONTENT_TYPE_ID_ZZZZ_OVER);
		return "web/manage/support/supportFile";
	}
	
	
	
	/**
	 * 跳转到表单查看模块
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/supportView.do")
	@RequiresPermissions("manage/support/supportView.do")
	public String supportView(Item item,
			HttpServletRequest request, HttpServletResponse response){
 
		item = itemService.selectByPrimaryKey(item.getId());
		if(item.getPreparerTime() != null){
			item.setPreparerTimes(Constants.DATE_FORMAT.format(item.getPreparerTime()));
		}
		List<ItemProcess> itemProcessList = itemProcessService.getItemProcessItemId(item.getId()); 
		
		ItemProcess fitemProcess = new ItemProcess();
		ItemProcess sitemProcess = new ItemProcess();
		if(itemProcessList.size()>0){
			fitemProcess = itemProcessList.get(0);
			if(itemProcessList.size() ==2){
				sitemProcess = itemProcessList.get(1);
			}
		}
		
		List<ItemProcessFile> ffileList = new ArrayList<ItemProcessFile>();
		List<ItemProcessFile> sfileList = new ArrayList<ItemProcessFile>();
		if(fitemProcess.getId() != null){
			ffileList = itemProcessFileService.getFileListByItemId(fitemProcess.getId());
			fitemProcess.setFileList(ffileList);
		}
		if(sitemProcess.getId() != null){
			sfileList = itemProcessFileService.getFileListByItemId(sitemProcess.getId());
			sitemProcess.setFileList(sfileList);
		}
		//获取当前用户
		User lgUser=this.getLoginUser();  
		
		request.setAttribute("User", lgUser); 
		request.setAttribute("FItemProcess", fitemProcess);
		request.setAttribute("SItemProcess", sitemProcess);
		request.setAttribute("Item", item); 
		request.setAttribute("ContentTypeId", Constants.CONTENT_TYPE_ID_ZZZZ_OVER);
		return "web/manage/support/supportViewForm";
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
    

	/** 
	 * 新增,编辑项目
	 * @throws ParseException 
	 */
    @ResponseBody
    @RequestMapping(value = "/jsonSaveOrUpdateFileItem.do", method=RequestMethod.POST)
    @RequiresPermissions("manage/support/jsonSaveOrUpdateFileItem.do")
    public JsonResult<ItemProcess> jsonSaveOrUpdateFileItem(ItemProcess itemProcess, 
    		HttpServletRequest request, HttpServletResponse response) throws ParseException{
    	//新建一个json对象 并赋初值
		JsonResult<ItemProcess> js = new JsonResult<ItemProcess>();
    	//获取当前登录用户
    	User u = this.getLoginUser(); 
		js.setCode(new Integer(1));
		js.setMessage("保存项目信息失败!");
		try {   
	    	//获取当前用户所属的机构id，当做制单部门的ID
	    	List<Integer> userOrgIDs = userService.getUserOrgIdsByUserId(u.getId());
	    	itemProcess.setPreparerOrgId(userOrgIDs.get(0)); //制单部门的ID
	    	itemProcess.setOrgId(userOrgIDs.get(0)); //制单部门的ID
	    	itemProcess.setPreparerId(u.getId());
	    	itemProcess.setPreparerTime(new Date());
			itemProcess.setDefined(false); 
			itemProcessService.insert(itemProcess);
			
			Item item = itemService.selectByPrimaryKey(itemProcess.getItemId());
			if(item != null){
				item.setEndTime(new Date());
				item.setStatus(Constants.ITEM_STATUS_OVER);
				itemService.updateByPrimaryKeySelective(item);
			}
			
			
			js.setCode(0);
			js.setMessage("上传资料成功，完整中支立项项目"); 
		}catch(Exception ex){
			js.setMessage("保存数据出错!");
			ex.printStackTrace();
		}
		return js;
    }
    
} 
