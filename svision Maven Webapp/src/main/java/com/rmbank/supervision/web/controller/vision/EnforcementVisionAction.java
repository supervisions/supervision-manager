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
import com.rmbank.supervision.model.ItemProcess;
import com.rmbank.supervision.model.ItemProcessFile;
import com.rmbank.supervision.model.Meta;
import com.rmbank.supervision.model.Organ;
import com.rmbank.supervision.model.OrganVM;
import com.rmbank.supervision.model.User;
import com.rmbank.supervision.service.ConfigService;
import com.rmbank.supervision.service.ItemProcessFileService;
import com.rmbank.supervision.service.ItemProcessService;
import com.rmbank.supervision.service.ItemService;
import com.rmbank.supervision.service.OrganService;
import com.rmbank.supervision.service.UserService;
import com.rmbank.supervision.web.controller.SystemAction;

/**
 * 执法监察控制器
 * 
 * @author DELL
 *
 */
@Scope("prototype")
@Controller
@RequestMapping("/vision/enforce")
public class EnforcementVisionAction extends SystemAction {

	@Resource
	private ItemService itemService;
	@Resource
	private UserService userService;
	@Resource
	private OrganService organService;
	@Resource
	private ConfigService configService;
	@Resource
	private ItemProcessService itemProcessService;
	@Resource
	private ItemProcessFileService itemProcessFileService;

	/**
	 * 执法监察列表
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws UnsupportedEncodingException
	 */
	@RequestMapping(value = "/enforceList.do")
	@RequiresPermissions("vision/enforce/enforceList.do")
	public String enforceList(Item item, HttpServletRequest request,
			HttpServletResponse response) throws UnsupportedEncodingException {
		// 判断搜索名是否为空，不为空则转为utf-8编码
		if (item.getSearchName() != null && item.getSearchName() != "") {
			String searchName = URLDecoder
					.decode(item.getSearchName(), "utf-8");
			item.setSearchName(searchName);
		}
		// 设置页面初始值及页面大小
		if (item.getPageNo() == null) {
			item.setPageNo(1);
		}
		item.setPageSize(Constants.DEFAULT_PAGE_SIZE);
		int totalCount = 0;
		// 分页集合
		List<Item> itemList = new ArrayList<Item>();
		// 获取当前登录用户
		User loginUser = this.getLoginUser();
		// 获取当前用户对应的机构列表
		List<Organ> userOrgList = userService.getUserOrgByUserId(loginUser
				.getId());
		// 获取当前用户对应的第一个机构
		Organ userOrg = userOrgList.get(0);
		try {
			if (userOrg.getOrgtype() == Constants.ORG_TYPE_1
					|| Constants.USER_SUPER_ADMIN_ACCOUNT.equals(loginUser
							.getAccount())) {
				// 取满足要求的参数数据
				item.setSupervisionTypeId(4);
				item.setItemType(Constants.STATIC_ITEM_TYPE_SVISION);
				itemList = itemService.getItemListByType(item);
				// 取满足要求的记录总数
				totalCount = itemService.getItemCountBySSJC(item);
			} else {
				// 取满足要求的参数数据
				item.setSupervisionTypeId(4);
				item.setSupervisionOrgId(userOrg.getId());
				item.setItemType(Constants.STATIC_ITEM_TYPE_SVISION);
				itemList = itemService.getItemListByTypeAndLogOrg(item);
				// 取满足要求的记录总数
				totalCount = itemService.getItemCountByLogOrgSSJC(item);
			}

		} catch (Exception ex) {
			ex.printStackTrace();
		}

		for (Item it : itemList) {
			List<ItemProcess> itemprocessList = itemProcessService
					.getItemProcessItemId(it.getId());
			if (itemprocessList.size() > 0) {
				ItemProcess lastItem = itemprocessList.get(itemprocessList
						.size() - 1);
				it.setLasgTag(lastItem.getContentTypeId());
			}
		}
		// 通过request对象传值到前台
		item.setTotalCount(totalCount);
		request.setAttribute("Item", item);
		request.setAttribute("userOrg", userOrg);
		request.setAttribute("itemList", itemList);
		return "web/vision/enforce/enforceList";
	}

	/**
	 * 跳转到添加工作事项
	 * 
	 * @param id
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = "/itemInfo.do")
	@RequiresPermissions("vision/enforce/itemInfo.do")
	public String ItemInfo(
			@RequestParam(value = "id", required = false) Integer id,
			HttpServletRequest request, HttpServletResponse response) {
		// 获取机构
		Organ organ = new Organ();
		List<Organ> organList = organService.getOrganList(organ);
		// 页面加载的机构
		List<OrganVM> list = new ArrayList<OrganVM>();
		OrganVM frvm = null;
		for (Organ rc : organList) {
			if (rc.getId() == 21) {
				frvm = new OrganVM();
				List<Organ> itemList = new ArrayList<Organ>();// 用于当做OrganVM的itemList
				frvm.setId(rc.getId());
				frvm.setName(rc.getName());
				for (Organ rc1 : organList) {
					if (rc1.getPid() == rc.getId() && rc1.getSupervision() == 0) {
						itemList.add(rc1);
					} else if (rc1.getId() == 43 && rc1.getPid() == rc.getId()) {
						itemList.add(rc1);
					}
				}
				frvm.setItemList(itemList);
				list.add(frvm);
			}
		}
		// 获取当前登录用户所属机构下的所有用户
		User lgUser = this.getLoginUser();
		List<User> byLgUser = userService.getUserListByLgUser(lgUser);
		// 获取执法类型
		List<Meta> meatListByKey = configService
				.getMeatListByKey(Constants.META_LAWTYPE_KEY);
		request.setAttribute("meatListByKey", meatListByKey);
		request.setAttribute("byLgUser", byLgUser);
		request.setAttribute("OrgList", list);
		return "web/vision/enforce/ItemInfo";
	}

	/**
	 * 依法行政领导小组添加工作事项
	 * 
	 * @throws ParseException
	 */
	@ResponseBody
	@RequestMapping(value = "/jsonSaveOrUpdateItem.do", method = RequestMethod.POST)
	@RequiresPermissions("vision/enforce/jsonSaveOrUpdateItem.do")
	public JsonResult<Item> jsonSaveOrUpdateItem(
			Item item,
			@RequestParam(value = "end_time", required = false) String end_time,// 用于接收前台传过来的String类型的时间
			@RequestParam(value = "content", required = false) String content,
			@RequestParam(value = "OrgId", required = false) Integer[] OrgIds,
			HttpServletRequest request, HttpServletResponse response)
			throws ParseException {
		// 将前台传过来的String类型的时间转换为Date类型
		if (end_time != null) {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			Date date = sdf.parse(end_time);
			item.setEndTime(date); // 完成时间
		}
		item.setPreparerTime(new Date()); // 创建时间
		item.setItemType(Constants.STATIC_ITEM_TYPE_SVISION); // 项目类型
		item.setSupervisionTypeId(4);
		item.setPid(0); // 主任务节点的ID
		item.setStageIndex(new Byte("0")); // 工作阶段排序
		// 获取当前登录用户
		User u = this.getLoginUser();
		item.setPreparerId(u.getId()); // 制单人的ID
		item.setSupervisionUserId(0); //
		// 获取当前用户所属的机构id，当做制单部门的ID
		List<Integer> userOrgIDs = userService.getUserOrgIdsByUserId(u.getId());
		item.setPreparerOrgId(userOrgIDs.get(0)); // 制单部门的ID
		// 新建一个json对象 并赋初值
		JsonResult<Item> js = new JsonResult<Item>();
		js.setCode(new Integer(1));
		js.setMessage("保存项目信息失败!");

		boolean State = false;
		try {
			// 如为新增，则给id置0
			if (item.getId() == null || item.getId() == 0) {
				item.setId(0);
			}
			// 创建用于新增时根据项目名称去查询项目是否存在的对象
			Item im = new Item();
			im.setName(item.getName());
			// 根据name去数据库匹配，如编辑，则可以直接保存；如新增，则需匹配该项目是否重复
			List<Item> lc = itemService.getExistItem(im);
			if (lc.size() == 0) {
				State = itemService.saveOrUpdateItem(item, OrgIds, content);
				if (State) {
					js.setCode(new Integer(0));
					js.setMessage("保存项目信息成功!");
					return js;
				} else {
					return js;
				}
			} else {
				js.setMessage("该项目已存在!");
				return js;
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return js;
	}

	/**
	 * 跳转到立项监察
	 * 
	 * @param id
	 * @param req
	 * @param res
	 * @return
	 */
	@RequestMapping(value = "/enforceInfo.do")
	@RequiresPermissions("vision/enforce/enforceInfo.do")
	public String efficiencyInfo(
			@RequestParam(value = "id", required = false) Integer id,// 项目id
			HttpServletRequest request, HttpServletResponse response) {

		Item item = itemService.selectByPrimaryKey(id);
		// 获取机构
		Organ organ = new Organ();
		List<Organ> organList = organService.getOrganList(organ);
		// 页面加载的机构
		List<OrganVM> list = new ArrayList<OrganVM>();
		OrganVM frvm = null;
		for (Organ rc : organList) {
			if (rc.getId() == 21) {
				frvm = new OrganVM();
				List<Organ> itemList = new ArrayList<Organ>();// 用于当做OrganVM的itemList
				frvm.setId(rc.getId());
				frvm.setName(rc.getName());
				for (Organ rc1 : organList) {
					if (rc1.getPid() == rc.getId() && rc1.getSupervision() == 0) {
						itemList.add(rc1);
					}/*
					 * else if(rc1.getId()==43 && rc1.getPid() == rc.getId()){
					 * itemList.add(rc1); }
					 */
				}
				frvm.setItemList(itemList);
				list.add(frvm);
			}
		}
		// 获取当前登录用户所属机构下的所有用户
		User lgUser = this.getLoginUser();
		List<User> byLgUser = userService.getUserListByLgUser(lgUser);
		// 获取执法类型
		List<Meta> meatListByKey = configService
				.getMeatListByKey(Constants.META_LAWTYPE_KEY);
		request.setAttribute("meatListByKey", meatListByKey);
		request.setAttribute("byLgUser", byLgUser);
		request.setAttribute("OrgList", list);
		request.setAttribute("Item", item);
		return "web/vision/enforce/enforceInfo";
	}

	/**
	 * 监察室进行执法监察立项操作
	 * 
	 * @param item
	 * @param end_time
	 * @param content
	 * @param OrgIds
	 * @param request
	 * @param response
	 * @return
	 * @throws ParseException
	 */
	@ResponseBody
	@RequestMapping(value = "/jsonUpdateItem.do", method = RequestMethod.POST)
	@RequiresPermissions("vision/enforce/jsonUpdateItem.do")
	public JsonResult<Item> jsonUpdateItem(
			Item item,
			@RequestParam(value = "end_time", required = false) String end_time,// 用于接收前台传过来的String类型的时间
			@RequestParam(value = "content", required = false) String content,
			@RequestParam(value = "OrgId", required = false) Integer[] OrgIds,
			HttpServletRequest request, HttpServletResponse response)
			throws ParseException {
		// 获取当前登录用户
		User u = this.getLoginUser();
		// 将前台传过来的String类型的时间转换为Date类型
		Item item2 = itemService.selectByPrimaryKey(item.getId());
		if (item.getSuperItemType() == 61) {// 综合执法
			if (end_time != null) {
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				Date date = sdf.parse(end_time);
				item2.setEndTime(date); // 完成时间
				item2.setSupervisionOrgId(OrgIds[0]);
				item2.setStatus(1);
				item2.setUuid(item.getUuid());
			}
		}
		// 新建一个json对象 并赋初值
		JsonResult<Item> js = new JsonResult<Item>();
		js.setCode(new Integer(1));
		js.setMessage("保存项目信息失败!");
		try {
			itemService.updateByPrimaryKeySelective(item2);

			List<Integer> userOrgIDs = userService.getUserOrgIdsByUserId(u
					.getId());
			ItemProcess itemProcess = new ItemProcess();
			itemProcess.setUuid(item.getUuid());
			itemProcess.setItemId(item.getId());
			itemProcess.setDefined(false);
			itemProcess.setContentTypeId(Constants.ENFORCE_VISION_1);// 监察室立项状态
			itemProcess.setPreparerOrgId(userOrgIDs.get(0)); // 制单部门的ID
			itemProcess.setOrgId(userOrgIDs.get(0));
			itemProcess.setContent(content);
			itemProcess.setPreparerId(u.getId());
			itemProcess.setPreparerTime(new Date());
			itemProcessService.insert(itemProcess);
			js.setCode(new Integer(0));
			js.setMessage("保存项目信息成功!");
			return js;
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {

		}
		return js;
	}

	/**
	 * 执法监察所有流程
	 * 
	 * @param item
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/enforceFile.do")
	@RequiresPermissions("vision/enforce/enforceFile.do")
	public String branchFHFile(Item item, HttpServletRequest request,
			HttpServletResponse response) {
		int tag = item.getTag();
		item = itemService.selectByPrimaryKey(item.getId());
		if (item.getPreparerTime() != null) {
			item.setPreparerTimes(Constants.DATE_FORMAT.format(item
					.getPreparerTime()));
		}
		List<ItemProcess> itemProcessList = itemProcessService
				.getItemProcessItemId(item.getId());

		if (itemProcessList.size() > 0) {
			for (ItemProcess ip : itemProcessList) {
				List<ItemProcessFile> fileList = new ArrayList<ItemProcessFile>();
				fileList = itemProcessFileService.getFileListByItemId(ip
						.getId());
				ip.setFileList(fileList);
				if (ip.getContentTypeId() == Constants.ENFORCE_VISION_0) {
					request.setAttribute("ItemProcess", ip); // 新建状态
				}else if (ip.getContentTypeId() == Constants.ENFORCE_VISION_1.intValue()) {
					request.setAttribute("ItemProcess1", ip); // 被监察对象录入项目方案
				}else if (ip.getContentTypeId() == Constants.ENFORCE_VISION_2.intValue()) {
					request.setAttribute("ItemProcess2", ip); // 监察室给出监察意见，并且项目合规
				}else if (ip.getContentTypeId() == Constants.ENFORCE_VISION_3.intValue()) {						
					request.setAttribute("ItemProcess3", ip); // 监察室给出监察意见,资料合规
				}else if (ip.getContentTypeId() == Constants.ENFORCE_VISION_1A.intValue()){						
					request.setAttribute("ItemProcess4", ip); // 监察室给出监察意见，资料不合规
				}else if (ip.getContentTypeId() == Constants.ENFORCE_VISION_4.intValue()) {
					request.setAttribute("ItemProcess5", ip); // 被监察对象已经录入录入意见书
				}else if (ip.getContentTypeId() == Constants.ENFORCE_VISION_5.intValue()) {
					request.setAttribute("ItemProcess6", ip); // 监察室对象已经检查意见书
				}else if (ip.getContentTypeId() == Constants.ENFORCE_VISION_6.intValue()) {
					request.setAttribute("ItemProcess8", ip); // 监察室已经录入监察执行情况，并且合规
				} else if (ip.getContentTypeId() == 666) {
					request.setAttribute("ItemProcess12", ip); // 监察室录入问责资料
				} else if (ip.getContentTypeId() == 777) {
					request.setAttribute("ItemProcess6", ip); // 被监察对象录入会议决策内容
				} else if (ip.getContentTypeId() == 778) {
					request.setAttribute("ItemProcess10", ip); // 需要问责，问责前一节点的监察意见
				} else if (ip.getContentTypeId() == 779) {
					request.setAttribute("ItemProcess11", ip); // 已经给出监察意见，执行情况不合规，但是不问责，回到被监察对象录入执行情况
				}
			}
		}
		// 获取当前用户
		User lgUser = this.getLoginUser();

		request.setAttribute("User", lgUser);
		request.setAttribute("tag", tag);
		request.setAttribute("Item", item);
		request.setAttribute("ContentTypeId",
				Constants.CONTENT_TYPE_ID_ZZZZ_OVER);

		if (tag == Constants.ENFORCE_VISION_1.intValue()) {
			return "web/vision/enforce/itemProcess130"; // 到被监察对象录入立项资料页面
		}
		if (tag == Constants.ENFORCE_VISION_2.intValue()) {
			return "web/vision/enforce/itemProcess131"; // 到监察室录入监察意见页面
		}
		if (tag == Constants.ENFORCE_VISION_3.intValue()) {
			return "web/vision/enforce/itemProcess132"; // 到被监察对象录入监察报告、意见书页面
		}
		if (tag == Constants.ENFORCE_VISION_4.intValue()) {
			return "web/vision/enforce/itemProcess133"; // 监察室给出监察意见书的意见页面
		}
		if (tag == Constants.ENFORCE_VISION_5.intValue()) {
			return "web/vision/enforce/itemProcess134"; // 到被监察对象录入督促整改情况页面
		}
		if (tag == Constants.ENFORCE_VISION_6.intValue()) {
			return "web/vision/enforce/itemProcess135"; // 到监察室给出监察结论页面
		}
		if (tag == 777) {
			return "web/vision/enforce/advice"; // 到监察室对会议决策内容给出意见
		}
		if (tag == 778) {
			return "web/vision/enforce/wenZe"; // 到监察室录入问责资料
		}
		return "";
	}

	/**
	 * 流程
	 * @param itemProcess
	 * @param request
	 * @param response
	 * @return
	 * @throws ParseException
	 */
	@ResponseBody
	@RequestMapping(value = "/jsonSaveItemProcess.do", method = RequestMethod.POST)
	@RequiresPermissions("vision/enforce/jsonSaveItemProcess.do")
	public JsonResult<ItemProcess> jsonSaveOrUpdateFileItem(
			@RequestParam(value="tag" ,required=false) Integer tag,
			@RequestParam(value="status" ,required=false) Integer status,
			ItemProcess itemProcess, HttpServletRequest request,
			HttpServletResponse response) throws ParseException {
		// 新建一个json对象 并赋初值
		JsonResult<ItemProcess> js = new JsonResult<ItemProcess>();
		// 获取当前登录用户
		User u = this.getLoginUser();
		js.setCode(new Integer(1));
		js.setMessage("保存项目信息失败!");
		try {
			// 获取当前用户所属的机构id，当做制单部门的ID
			List<Integer> userOrgIDs = userService.getUserOrgIdsByUserId(u
					.getId());
			itemProcess.setPreparerOrgId(userOrgIDs.get(0)); // 制单部门的ID
			itemProcess.setOrgId(userOrgIDs.get(0)); // 制单部门的ID
			itemProcess.setPreparerId(u.getId());
			itemProcess.setPreparerTime(new Date());
			itemProcess.setDefined(false);
			if(tag==130){
				itemProcess.setContentTypeId(Constants.ENFORCE_VISION_2);//被监察对象已经录入立项资料 
			}else if(tag==131 && status==0){
				itemProcess.setContentTypeId(Constants.ENFORCE_VISION_3);//监察室给出监察意见，并且合规 
			}else if(tag==131 && status==1){
				itemProcess.setContentTypeId(Constants.ENFORCE_VISION_1A);//监察室给出监察意见，但是不合规
			}else if(tag==132){
				itemProcess.setContentTypeId(Constants.ENFORCE_VISION_4);//被监察对象录入现场监察报告、意见书
			}else if(tag==133 && status==0){
				itemProcess.setContentTypeId(Constants.ENFORCE_VISION_5);//监察室给出监察意见书意见，并且合规
			}else if(tag==133 && status==1){
				itemProcess.setContentTypeId(Constants.ENFORCE_VISION_3A);//监察室给出监察意见书意见，但是不合规
			}else if(tag==134 && status==0){
				itemProcess.setContentTypeId(Constants.ENFORCE_VISION_6);//被监察对象录入督促整改情况，并且不处罚
			}else if(tag==134 && status==1){
				itemProcess.setContentTypeId(Constants.ENFORCE_VISION_7);//被监察对象录入督促整改情况，但是要处罚
			}else if(tag==135){
				itemProcess.setContentTypeId(Constants.ENFORCE_VISION_OVER);//监察室给出监察结论，项目完结
				Item item = itemService.selectByPrimaryKey(itemProcess.getItemId());
				item.setEndTime(new Date());
				item.setStatus(Constants.ITEM_STATUS_OVER);
				itemService.updateByPrimaryKeySelective(item);
			}
			

			itemProcessService.insert(itemProcess);

			js.setCode(0);
			js.setMessage("录入方案成功!");
		} catch (Exception ex) {
			js.setMessage("保存数据出错!");
			ex.printStackTrace();
		}
		return js;
	}

	
	
	
	/**
	 * 修改立项状态
	 */
	@ResponseBody
	@RequestMapping(value = "/jsonsetProjectById.do", method = RequestMethod.POST)
	@RequiresPermissions("vision/enforce/jsonsetProjectById.do")
	public JsonResult<Item> jsonsetProjectById(
			@RequestParam(value = "id", required = false) Integer id,
			HttpServletRequest request, HttpServletResponse response) {

		// 新建一个json对象 并赋初值
		JsonResult<Item> js = new JsonResult<Item>();
		js.setCode(new Integer(1));
		js.setMessage("修改立项状态失败!");
		try {
			Item item = new Item();
			item.setId(id);
			item.setStatus(1);
			int state = itemService.updateByPrimaryKeySelective(item);
			if (state == 1) {
				js.setCode(new Integer(0));
				js.setMessage("修改立项状态成功!");
				return js;
			} else {
				return js;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return js;
	}

	/**
	 * 删除项目
	 * 
	 * @param id
	 * @param request
	 * @param response
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/jsondeleteItemById.do", method = RequestMethod.POST)
	@RequiresPermissions("vision/enforce/jsondeleteItemById.do")
	public JsonResult<Item> jsondeleteItemById(
			@RequestParam(value = "id", required = false) Integer id,
			HttpServletRequest request, HttpServletResponse response) {

		// 新建一个json对象 并赋初值
		JsonResult<Item> js = new JsonResult<Item>();
		js.setCode(new Integer(1));
		js.setMessage("删除失败!");
		boolean state = false;
		try {
			state = itemService.deleteItemById(id);
			if (state) {
				js.setCode(new Integer(0));
				js.setMessage("删除成功!");
				return js;
			} else {
				return js;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return js;

	}

	/**
	 * 查看项目
	 * 
	 * @param item
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "/showItem.do")
	@RequiresPermissions("vision/enforce/showItem.do")
	public String showItem(Item item, HttpServletRequest request,
			HttpServletResponse response) {
		item = itemService.selectByPrimaryKey(item.getId()); // 项目基本信息
		if (item.getPreparerTime() != null) {
			item.setPreparerTimes(Constants.DATE_FORMAT.format(item
					.getPreparerTime()));
		}
		// 获取流程集合
		List<ItemProcess> itemProcessList = itemProcessService
				.getItemProcessItemId(item.getId());
		if (itemProcessList.size() > 0) {
			for (ItemProcess ip : itemProcessList) {
				List<ItemProcessFile> fileList = new ArrayList<ItemProcessFile>();
				fileList = itemProcessFileService.getFileListByItemId(ip
						.getId()); // 获取当前流程拥有的附件
				ip.setFileList(fileList);
				if (ip.getContentTypeId() == Constants.ENFORCE_VISION_0) {
					request.setAttribute("ItemProcess", ip); // 添加工作事项后的信息
				}else if (ip.getContentTypeId() == Constants.ENFORCE_VISION_1.intValue()) {						
					request.setAttribute("ItemProcess1", ip); // 监察室立项后的信息
				}else if (ip.getContentTypeId() == Constants.ENFORCE_VISION_2.intValue()) {						
					request.setAttribute("ItemProcess2", ip); // 被监察对象录入立项后的信息
				}else if (ip.getContentTypeId() == Constants.ENFORCE_VISION_3.intValue()) {						
					List<ItemProcess> list = new ArrayList<ItemProcess>(); // 这里处理了循环不合规的情况
					for (ItemProcess iplt : itemProcessList) {
						if (iplt.getContentTypeId() == Constants.ENFORCE_VISION_2.intValue()) {
							list.add(iplt); //获取回到被监察对象录入资料的情况的流程
						}
					}
					ItemProcess itemProcess = itemProcessList.get(itemProcessList.size() - 1); // 获取最后一个元素
					if (list.size() <= 1||itemProcess.getContentTypeId() == Constants.ENFORCE_VISION_3.intValue()){
						request.setAttribute("ItemProcess3", ip); // 监察室给出监察意见,资料合规
					}else if(list.size() > 1 && itemProcess.getContentTypeId()>Constants.ENFORCE_VISION_3.intValue()){
						request.setAttribute("ItemProcess3", ip); // 监察室给出监察意见,资料合规
					}else {
						request.setAttribute("ItemProcess3", null); // 已经重新录入资料，上一次的监察意见不显示
					}					
				}else if (ip.getContentTypeId() == Constants.ENFORCE_VISION_1A.intValue()) {						
					List<ItemProcess> list = new ArrayList<ItemProcess>(); // 这里处理了循环不合规的情况
					for (ItemProcess iplt : itemProcessList) {
						if (iplt.getContentTypeId() == Constants.ENFORCE_VISION_2.intValue()) {
							list.add(iplt);
						}
					}
					ItemProcess itemProcess = itemProcessList.get(itemProcessList.size() - 1); // 获取最后一个元素
					if (list.size() <= 1 || itemProcess.getContentTypeId() == Constants.ENFORCE_VISION_1A.intValue()) {
						request.setAttribute("ItemProcess4", ip); // 第一次录入资料，监察室给出监察意见
					}else {
						request.setAttribute("ItemProcess4", null); // 已经重新上传方案，上一次的监察意见不显示
					}
					
				}else if (ip.getContentTypeId() == Constants.ENFORCE_VISION_4.intValue()) {						
					request.setAttribute("ItemProcess5", ip); // 被监察对象录入现场监察报告、意见书
				}else if (ip.getContentTypeId() == Constants.ENFORCE_VISION_5.intValue()) {						
					List<ItemProcess> list = new ArrayList<ItemProcess>(); // 这里处理了循环不合规的情况
					for (ItemProcess iplt : itemProcessList) {
						if (iplt.getContentTypeId() == Constants.ENFORCE_VISION_2.intValue()) {
							list.add(iplt); //获取回到被监察对象录入资料的情况的流程
						}
					}
					ItemProcess itemProcess = itemProcessList.get(itemProcessList.size() - 1); // 获取最后一个元素
					if (list.size() <= 1||itemProcess.getContentTypeId() == Constants.ENFORCE_VISION_5.intValue()){
						request.setAttribute("ItemProcess6", ip); // 监察室给出监察意见,意见书合规
					}else if(list.size() > 1 && itemProcess.getContentTypeId()>Constants.ENFORCE_VISION_5.intValue()){
						request.setAttribute("ItemProcess6", ip); // 监察室给出监察意见,意见书合规
					}else {
						request.setAttribute("ItemProcess6", null); // 已经重新录入资料，上一次的监察意见不显示
					}					
				}else if (ip.getContentTypeId() == Constants.ENFORCE_VISION_3A.intValue()) {						
					List<ItemProcess> list = new ArrayList<ItemProcess>(); // 这里处理了循环不合规的情况
					for (ItemProcess iplt : itemProcessList) {
						if (iplt.getContentTypeId() == Constants.ENFORCE_VISION_4.intValue()) {
							list.add(iplt);
						}
					}
					ItemProcess itemProcess = itemProcessList.get(itemProcessList.size() - 1); // 获取最后一个元素
					if (list.size() <= 1 || itemProcess.getContentTypeId() == Constants.ENFORCE_VISION_3A.intValue()) {
						request.setAttribute("ItemProcess7", ip); // 第一次录入资料，监察室给出监察意见
					}else {
						request.setAttribute("ItemProcess7", null); // 已经重新上传方案，上一次的监察意见不显示
					}
					
				}else if (ip.getContentTypeId() == Constants.ENFORCE_VISION_6.intValue()) {						
					request.setAttribute("ItemProcess8", ip); // 被监察对象录入督促整改情况，并且不处罚
				}else if (ip.getContentTypeId() == Constants.ENFORCE_VISION_7.intValue()) {						
					request.setAttribute("ItemProcess10", ip); // 被监察对象录入督促整改情况
				}else if (ip.getContentTypeId() == Constants.ENFORCE_VISION_OVER.intValue()) {						
					request.setAttribute("ItemProcess9", ip); // 监察给出监察结论，项目完结
				}
				
			}
		}

		// 获取当前用户
		User lgUser = this.getLoginUser();
		request.setAttribute("User", lgUser);
		request.setAttribute("Item", item);
		request.setAttribute("ContentTypeId",
				Constants.CONTENT_TYPE_ID_ZZZZ_OVER);
		return "web/vision/enforce/showItem";
	}
}
