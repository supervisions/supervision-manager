package com.rmbank.supervision.web.controller.base;

import java.io.UnsupportedEncodingException;
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

import com.rmbank.supervision.model.User;
import com.rmbank.supervision.service.UserService;
import com.rmbank.supervision.web.controller.SystemAction;
import com.rmbank.supervision.common.JsonResult;
import com.rmbank.supervision.common.utils.Constants;






@Scope("prototype")
@Controller
@RequestMapping("/system/user")
public class UserAction extends SystemAction  {
	
	
		@Resource
		private UserService userService;
		
		
		/**
	     * 用户管理
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
			if(user.getSearchName() != null && user.getSearchName() != ""){
				String searchName = new String(user.getSearchName().getBytes(
						"iso8859-1"), "utf-8");
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
				//t_user取满足要求的记录总数
				totalCount = userService.getUserCount(user);
			}catch(Exception ex){ 
				ex.printStackTrace();
			}
			//通过request对象传值到前台
			user.setTotalCount(totalCount); 
			request.setAttribute("User", user); 
	    	
	    	request.setAttribute("userList", userList);
	    	
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
	    	return "web/base/user/userInfo";
	    }
		
	    /** 
		 * 新增,编辑用户
		 */
	    @ResponseBody
	    @RequestMapping(value = "/jsonSaveOrUpdateUser.do", method=RequestMethod.POST)
	    @RequiresPermissions("system/user/jsonSaveOrUpdateUser.do")
	    public JsonResult<User> jsonSaveOrUpdateDevice(User user,
	    		HttpServletRequest request, HttpServletResponse response){
	    	
	    	//新建一个json对象 并赋初值
			JsonResult<User> js = new JsonResult<User>();
			js.setCode(new Integer(1));
			js.setMessage("保存失败!");
			boolean saveOrUpdateUser =  false;
			try {
				//如为新增，则给id置0
				if (user.getId() == null || user.getId() == 0) {
					user.setId(0);					
				} 
				
				User u = new User();
				u.setId(user.getId());
				u.setAccount(user.getAccount());
				
				//如为编辑，则给新建device对象赋传来的设备id值
				if (user.getId() > 0) {
					u.setId(user.getId());
					saveOrUpdateUser= userService.saveOrUpdateUser(user);
					if(saveOrUpdateUser){
						js.setCode(new Integer(0));
						js.setMessage("保存成功!");
						return js;
					}else{
						return js;
					}
				}
				//根据设备编号和id去数据库匹配，如编辑，则可以直接保存；如新增，则需匹配设备编号是否重复
				List<User> lc = userService.getExistUser(u);
				if (lc.size() == 0) {  
					saveOrUpdateUser = userService.saveOrUpdateUser(user);
					if(saveOrUpdateUser){
						js.setCode(new Integer(0));
						js.setMessage("保存成功!");
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
	    
}
