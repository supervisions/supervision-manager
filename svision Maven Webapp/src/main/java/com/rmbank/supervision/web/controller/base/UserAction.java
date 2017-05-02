package com.rmbank.supervision.web.controller.base;

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
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.rmbank.supervision.model.Meta;
import com.rmbank.supervision.model.Organ;
import com.rmbank.supervision.model.Role;
import com.rmbank.supervision.model.User;
import com.rmbank.supervision.model.UserOrgan;
import com.rmbank.supervision.service.ConfigService;
import com.rmbank.supervision.service.OrganService;
import com.rmbank.supervision.service.RoleService;
import com.rmbank.supervision.service.UserService;
import com.rmbank.supervision.web.controller.SystemAction;
import com.rmbank.supervision.common.JsonResult;
import com.rmbank.supervision.common.utils.Constants;


@Scope("prototype")
@Controller
@RequestMapping("/system/user")
public class UserAction extends SystemAction  {
	
		/**
		 * 资源注入
		 */
		@Resource
		private UserService userService;
		@Resource
		private RoleService roleService;
		@Resource
		private OrganService organService; 		
		@Resource
		private ConfigService configService; 
		
		
		/**
	     * 用户管理列表
	     *
	     * @param request
	     * @param response
	     * @return
		 * @throws UnsupportedEncodingException 
	     */
	    @RequestMapping(value = "/userList.do")
	    @RequiresPermissions("system/user/userList.do")
	    public String userList(User user, 
	            HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException { 
	    	//判断搜索名是否为空，不为空则转为utf-8编码	    	
			/*if(user.getSearchName() != null && user.getSearchName() != ""){
				String searchName = new String(user.getSearchName().getBytes(
						"iso8859-1"), "utf-8");
				user.setSearchName(searchName);
			}*/
			if(user.getSearchName() != null && user.getSearchName() != ""){
				String searchName =  URLDecoder.decode(user.getSearchName(),"utf-8");
				user.setSearchName(searchName);
			}
			//设置页面初始值及页面大小
			if (user.getPageNo() == null)
				user.setPageNo(1);
			user.setPageSize(Constants.DEFAULT_PAGE_SIZE);  
			int totalCount =  0;
			//分页集合
			List<User> userList = new ArrayList<User>();
			try{
				//t_user取满足要求的参数数据
				userList =  userService.getUserList(user);
				//当机构名称长度大于15时用......代替
				/*int OrgNameLength =0;
				for (User u : userList) {					
					OrgNameLength= u.getOrgName().length();
					if(OrgNameLength>15){
						String substring = u.getOrgName().substring(0, 14)+"......";
						u.setOrgName(substring);
					}					
				}*/
				//t_user取满足要求的记录总数
				totalCount = userService.getUserCount(user);
			}catch(Exception ex){ 
				ex.printStackTrace();
			}			
			user.setTotalCount(totalCount); 	
			//通过request对象传值到前台
			request.setAttribute("User", user);    	
	    	request.setAttribute("userList", userList);
	    	
	    	//获取用户对应的职务
//	    	List<Meta> postList=configService.getUserPost();
//	    	request.setAttribute("postList", postList);
	    	
	    	return "web/base/user/userList";
	    }
	    
	    /**
	     * 跳转到新增用户/编辑页面
	     * @return
	     */
	    @RequestMapping(value = "/userInfo.do", method = RequestMethod.GET, produces = "application/json;charset=UTF-8")
	    @RequiresPermissions("system/user/userInfo.do")
	    public String editUser(@RequestParam(value = "id", required = false) Integer id,
				HttpServletRequest req, HttpServletResponse res){
	    	
	    	//根据参数id判断是新增还是编辑，新增为0，不用传值；编辑为选中的参数id值，取对象，传值
			if(id != null && id != 0){
				User user = new User();
				try{
					user = userService.getUserById(id);
				}catch(Exception ex){
					ex.printStackTrace();
				}
				req.setAttribute("User", user);
			}
			
			//获取角色的集合
			Role role=new Role();
			List<Role> roleList = roleService.getRoleList(role);
			req.setAttribute("roleList",roleList);
			
			//根据用户ID去查询用户的角色
			List<Role> userRoleList=roleService.getRolesByUserId(id);
			req.setAttribute("userRoleList", userRoleList);
			
			//根据用户ID查询用户所属的机构,用于编辑的时候回显用户所属机构
			List<Organ> userOrgList= organService.getOrgsByUserId(id);
			req.setAttribute("userOrgList", userOrgList);
			
			/*//获取机构列表
			Organ organ =new Organ();
			List<Organ> organList = organService.getOrganList(organ);
			req.setAttribute("organList",organList);*/
			
			//获取职务列表			
			List<Meta> meatListByKey = configService.getMeatListByKey(Constants.META_POSITION_Key);
			req.setAttribute("meatListByKey", meatListByKey);
			
			//根据用户ID查询用户所对应的职务,用于编辑的时候回显用户所属职务
			List<UserOrgan> userPostList= organService.getPostsByUserId(id);
			req.setAttribute("userPostList", userPostList);
			
			
	    	return "web/base/user/userInfo";
	    }
		
	    /** 
		 * 新增,编辑用户
		 */
	    @ResponseBody
	    @RequestMapping(value = "/jsonSaveOrUpdateUser.do", method=RequestMethod.POST)
	    @RequiresPermissions("system/user/jsonSaveOrUpdateUser.do")
	    public JsonResult<User> jsonSaveOrUpdateDevice(User user,
	    		@RequestParam(value = "roleId", required = false) Integer[] roleIds, //用户所属的角色的ID的集合
	    		@RequestParam(value = "orgId", required = false) Integer[] orgIds, //用户所属机构的ID的集合
	    		@RequestParam(value = "userOrgId", required = false) Integer[] userOrgIds, //用户-机构中间表的ID的集合
	    		@RequestParam(value = "postId", required = false) Integer postId, //用户对应的职务的集合	    		
	    		HttpServletRequest request, HttpServletResponse response){
	    	
	    	//新建一个json对象 并赋初值
			JsonResult<User> js = new JsonResult<User>();
			js.setCode(new Integer(1));
			js.setMessage("保存用户信息失败!");
			
			boolean State =  false;
			try {
				//如为新增，则给id置0
				if (user.getId() == null || user.getId() == 0) {
					user.setId(0);					
				} 
				
				//创建用于新增时根据用户账号去查询用户是否存在的user对象
				User u = new User();
				u.setId(user.getId());
				u.setAccount(user.getAccount());
				
				//如为编辑，则给新建user对象赋传来的设备id值
				if (user.getId() > 0) {
					u.setId(user.getId());
					
					State = userService.saveOrUpdateUser(user,roleIds,orgIds,postId);
					if(State){
						js.setCode(new Integer(0));
						js.setMessage("保存用户信息成功!");
						return js;
					}else{
						return js;
					}
				}
				//根据id去数据库匹配，如编辑，则可以直接保存；如新增，则需匹配该账号是否重复
				List<User> lc = userService.getExistUser(u);
				if (lc.size() == 0) {  
					State = userService.saveOrUpdateUser(user,roleIds,orgIds,postId);
					if(State){
						js.setCode(new Integer(0));
						js.setMessage("保存用户信息成功!");
						return js;
					}else{
						return js;
					}
				} else {
					js.setMessage("该账号已存在!");
					return js;
				} 
			}catch(Exception ex){
				ex.printStackTrace();
			}
			return js;
	    }
	    
	    
	    /**
	     * 删除用户
	     */
	    @ResponseBody
		@RequestMapping(value = "/jsondeleteUserById.do", method = RequestMethod.POST)
		@RequiresPermissions("system/user/jsondeleteUserById.do")
		public JsonResult<User> jsondeleteUserById(
				@RequestParam(value = "id", required = false) Integer id,
				HttpServletRequest request, HttpServletResponse response) {
			
			// 新建一个json对象 并赋初值
			JsonResult<User> js = new JsonResult<User>();
			js.setCode(new Integer(1));
			js.setMessage("删除失败!");
			try {					
				boolean state = userService.deleteUserById(id);
				if(state){
					js.setCode(new Integer(0));
					js.setMessage("删除成功!");
					return js;
				}else {
					return js;
				}
			} catch (Exception e) {
				e.printStackTrace();
			}			
			return js;
		}
	    
	    /**
	     * 修改用户状态
	     */
	    @ResponseBody
		@RequestMapping(value = "/jsonupdateUserById.do", method = RequestMethod.POST)
		@RequiresPermissions("system/user/jsonupdateUserById.do")
		public JsonResult<User> jsonupdateUserById(User user,				
				HttpServletRequest request, HttpServletResponse response) {
			
			// 新建一个json对象 并赋初值
			JsonResult<User> js = new JsonResult<User>();
			js.setCode(new Integer(1));
			js.setMessage("修改用户状态失败!");			
			
			try {					
				boolean state = userService.updateUserUsedById(user);
				if(state){
					js.setCode(new Integer(0));
					js.setMessage("修改用户状态成功!");
					return js;
				}else {
					return js;
				}
			} catch (Exception e) {
				e.printStackTrace();
			}			
			return js;
		}
	    
	    /**
	     * 重置密码
	     */
	    @ResponseBody
		@RequestMapping(value = "/jsonResetUserPwd.do", method = RequestMethod.POST)
		@RequiresPermissions("system/user/jsonResetUserPwd.do")
		public JsonResult<User> jsonResetUserPwd(
				@RequestParam(value = "id", required = false) Integer id,
				HttpServletRequest request, HttpServletResponse response) {
	    	// 新建一个json对象 并赋初值
			JsonResult<User> js = new JsonResult<User>();
			js.setCode(new Integer(1));
			js.setMessage("重置用户密码失败!");		
	    	
			//根据id查询用户
			User userById = userService.getUserById(id);
			//重置用户密码
			userById.setPwd(Constants.DEFAULT_USER_PASSWORD);
			try{
				boolean state = userService.updateByPrimaryKey(userById);
				if(state){
					js.setCode(new Integer(0));
					js.setMessage("重置用户密码成功!");
					return js;
				}else {
					return js;
				}				
			}catch (Exception e) {
				e.printStackTrace();
			}			
			return js;
	    }
	    
	    /**
	     * 加载机构的树
	     * @param request
	     * @param response
	     * @return
	     */
	    /*@ResponseBody
		@RequestMapping(value = "/jsonLoadOrganTreeList.do", method = RequestMethod.POST)
		@RequiresPermissions("system/user/jsonLoadOrganTreeList.do")
		public JsonResult<Organ> jsonLoadOrganTreeList(				
				HttpServletRequest request, HttpServletResponse response) {
	    	JsonResult<Organ> js = new JsonResult<Organ>();
	    	//获取机构列表
			Organ organ =new Organ();
			List<Organ> organList = organService.getOrganList(organ);
			js.setList(organList);
			
	    	return js;
	    }*/
	    
	    

}
