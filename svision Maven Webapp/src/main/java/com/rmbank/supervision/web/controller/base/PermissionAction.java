package com.rmbank.supervision.web.controller.base;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.ArrayList;
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
import com.rmbank.supervision.common.utils.IpUtil;
import com.rmbank.supervision.model.FunctionResourceVM;
import com.rmbank.supervision.model.Permission;
import com.rmbank.supervision.model.PermissionResource;
import com.rmbank.supervision.model.ResourceConfig;
import com.rmbank.supervision.model.RolePermission;
import com.rmbank.supervision.model.User;
import com.rmbank.supervision.service.FunctionService;
import com.rmbank.supervision.service.PermissionResourceService;
import com.rmbank.supervision.service.PermissionService;
import com.rmbank.supervision.service.ResourceService;
import com.rmbank.supervision.service.RoleResourceService;
import com.rmbank.supervision.service.RoleService;
import com.rmbank.supervision.service.SysLogService;
import com.rmbank.supervision.web.controller.SystemAction;

@Scope("prototype")
@Controller
@RequestMapping("/system/permission")
public class PermissionAction extends SystemAction {

	@Resource
	private PermissionService permissionService;
	@Resource
	private SysLogService logService;
	@Resource
	private RoleService roleService;
	@Resource
	private RoleResourceService roleResourceService;
	@Resource
	private FunctionService functionService;
	@Resource
	private ResourceService resourceService;
	@Resource
	private PermissionResourceService permissionResourceService;
	
	/**
	 * 加载权限列表
	 * @param resourceConfig
	 * @param request
	 * @param response
	 * @return
	 * @throws UnsupportedEncodingException
	 */
	@RequestMapping(value = "/permissionList.do")
	@RequiresPermissions("system/permission/permissionList.do")
	public String permissionList(Permission permission, 
			HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException{
		//判断搜索名是否为空，不为空则转为utf-8编码
		if(permission.getSearchName() != null && permission.getSearchName() != ""){
			String searchName = URLDecoder.decode(permission.getSearchName(),"utf-8");
			permission.setSearchName(searchName);
		}
		//设置页面初始值及页面大小
		if (permission.getPageNo() == null)
			permission.setPageNo(1);
		permission.setPageSize(Constants.DEFAULT_PAGE_SIZE);  
		int totalCount =  0;
		//分页集合
		List<Permission> permissionList = new ArrayList<Permission>();
		try{
			//t_resource取满足要求的参数数据
			permissionList =  permissionService.getPermissionList(permission);
			//t_resource取满足要求的记录总数
			totalCount = permissionService.getPermissionCount(permission);
		}catch(Exception ex){ 
			ex.printStackTrace();
		}			
		permission.setTotalCount(totalCount); 	
		//通过request对象传值到前台
		request.setAttribute("Permission", permission);    	
    	request.setAttribute("PermissionList", permissionList);

    	User loginUser = this.getLoginUser();
		String ip = IpUtil.getIpAddress(request);		
		logService.writeLog(Constants.LOG_TYPE_SYS, "用户："+loginUser.getName()+"，执行了资源列表查询", 4, loginUser.getId(), loginUser.getUserOrgID(), ip);
	
		return "web/base/permission/permissionList";
	}
	
	/**
	 * 跳转到新增权限
	 * @param resourceConfig
	 * @param request
	 * @param response
	 * @return
	 * @throws UnsupportedEncodingException
	 */
	@RequestMapping(value = "/permissionInfo.do")
	@RequiresPermissions("system/permission/permissionInfo.do")
	public String permissionInfo(Permission permission, 
			HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException{

		return "web/base/permission/permissionInfo";
	}

	/**
	 * 跳转到资源授权页面 
	 * @throws UnsupportedEncodingException 
	 **/
	@RequestMapping(value = "/toAuthorizationResource.do")
	@RequiresPermissions("system/permission/toAuthorizationResource.do")
	public String authorizeResource(Permission permission,
			HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException{		
		//根据权限id回显该权限对应的资源
		List<PermissionResource> permissionResourceList=permissionResourceService.selectByPermissionId(permission.getId());
		request.setAttribute("permissionResourceList", permissionResourceList);
		
		Permission pms=new Permission();
		Permission permissionKey = permissionService.selectByPrimaryKey(permission.getId());
		//List<ResourceConfig> resourceList=resourceService.getResourceListBymoudleId(resourceConfig);
		
		
		/*Collections.sort(resourceList, new Comparator<ResourceConfig>() {
            public int compare(ResourceConfig arg0, ResourceConfig arg1) {
                return arg0.getMoudleId().compareTo(arg1.getMoudleId());
            }
        });*/
		ResourceConfig resource=new ResourceConfig();
		//获取所有的资源
		List<ResourceConfig> resourceList=resourceService.getResourceList(resource);
		
		List<FunctionResourceVM> list = new ArrayList<FunctionResourceVM>();
		FunctionResourceVM frvm = null;
		Map<Integer,Integer> map = new HashMap<Integer,Integer>();
		for (ResourceConfig re : resourceList) {
			if(re.getMoudleId()==permissionKey.getMoudleId()){
				frvm = new FunctionResourceVM();
				frvm.setId(re.getMoudleId());
				frvm.setName(re.getFunctionName());
				//用于当做FunctionResourceVM的itemList
				List<ResourceConfig> itemList = new ArrayList<ResourceConfig>();

				for(ResourceConfig rc1 : resourceList){
					if(rc1.getMoudleId() == permissionKey.getMoudleId()){ 
						itemList.add(rc1);
					}
				}
				frvm.setItemList(itemList);
				if(map.isEmpty()){
					list.add(frvm);
					map.put(frvm.getId(), frvm.getId());
				}else{
					if(map.get(frvm.getId()) == null){ 
						list.add(frvm);
						map.put(frvm.getId(), frvm.getId());
					}
				}
			}
		}
		/*List<FunctionResourceVM> list = new ArrayList<FunctionResourceVM>();
		int tempId = 0;
		FunctionResourceVM frvm = null;
		Map<Integer,Integer> map = new HashMap<Integer,Integer>();
		for(ResourceConfig rc : resourceList){
			if(tempId != rc.getMoudleId()){
				tempId = rc.getMoudleId(); 
				frvm = new FunctionResourceVM();
			}else{ 
				//用于当做FunctionResourceVM的itemList
				List<ResourceConfig> itemList = new ArrayList<ResourceConfig>();
				
				frvm.setId(rc.getMoudleId());
				frvm.setName(rc.getFunctionName());
				for(ResourceConfig rc1 : resourceList){
					if(rc1.getMoudleId() == tempId){ 
						itemList.add(rc1);
					}
				}
				frvm.setItemList(itemList);
				if(map.isEmpty()){
					list.add(frvm);
					map.put(frvm.getId(), frvm.getId());
				}else{
					if(map.get(frvm.getId()) == null){ 
						list.add(frvm);
						map.put(frvm.getId(), frvm.getId());
					}
				}
			}
		}*/
		 
		request.setAttribute("resourceList", list);
		request.setAttribute("resourceConfig", permission);
		return "web/base/permission/authorizeResource";
	}
	/**
	 * 资源授权
	 * @param roleId
	 * @param resourceIds
	 * @param request
	 * @param response
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/jsonSaveOrUpdateRoleResource.do", method = RequestMethod.POST)
	@RequiresPermissions("system/permission/jsonSaveOrUpdateRoleResource.do")
	public JsonResult<PermissionResource> jsonSaveOrUpdateRoleResource(
			@RequestParam(value="permissionId", required=false) Integer permissionId,
			@RequestParam(value="resourceId", required=false) Integer [] resourceIds,
			HttpServletRequest request, HttpServletResponse response) {

		// 新建一个json对象 并赋初值
		JsonResult<PermissionResource> js = new JsonResult<PermissionResource>();
		js.setCode(new Integer(1));
		js.setMessage("保存失败!");
		boolean state = false;
		try {
			//当roleId不等于0并且不等于null的时候才去新增
			if (permissionId != 0 && permissionId !=null) {
				state = permissionResourceService.savePermissionResource(permissionId,resourceIds);
				if (state) {
					User loginUser = this.getLoginUser();
					String ip = IpUtil.getIpAddress(request);		
					logService.writeLog(Constants.LOG_TYPE_BASE_DATA, "用户："+loginUser.getName()+"，执行了角色授权操作", 2, loginUser.getId(), loginUser.getUserOrgID(), ip);
					js.setCode(new Integer(0));
					js.setMessage("保存成功!");
					return js;
				} else {
					return js;
				}
			}				
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return js;
	}
}
