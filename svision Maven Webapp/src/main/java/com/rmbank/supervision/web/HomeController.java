package com.rmbank.supervision.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.rmbank.supervision.common.JsonResult;
import com.rmbank.supervision.common.ReturnResult;
import com.rmbank.supervision.common.utils.Constants;
import com.rmbank.supervision.model.FunctionMenu;
import com.rmbank.supervision.model.Organ;
import com.rmbank.supervision.model.ResourceConfig;
import com.rmbank.supervision.model.Role;
import com.rmbank.supervision.model.RoleResource;
import com.rmbank.supervision.model.User;
import com.rmbank.supervision.service.FunctionService;
import com.rmbank.supervision.service.OrganService;
import com.rmbank.supervision.service.ResourceService;
import com.rmbank.supervision.service.RoleResourceService;
import com.rmbank.supervision.service.RoleService;
import com.rmbank.supervision.service.UserService;
import com.rmbank.supervision.web.controller.SystemAction;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

@Controller
public class HomeController extends SystemAction {

    @Resource(name="userService")
    private UserService userService;

    @Resource(name="functionService")
    private FunctionService functionService;

    @Resource(name="organService")
    private OrganService organService;

    @Resource(name="resourceService")
    private ResourceService resourceService;

    @Resource(name="roleService")
    private RoleService roleService;

    @Resource(name="roleResourceService")
    private RoleResourceService roleResourceService;
    
    /***
     * 首页 返回至/page/login.jsp页面
     * @return
     */
    @RequestMapping("index")
    public ModelAndView index(
            HttpServletRequest request, HttpServletResponse response){
        //创建模型跟视图，用于渲染页面。并且指定要返回的页面为login页面
        ModelAndView mav = new ModelAndView("login");
        return mav;
    }
    

	/**
	 * 加载机构的树
	 * 
	 * @param pid
	 * @param request
	 * @param response
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/loadOrganTreeList.do")
	public List<Organ> getOrganList(
			@RequestParam(value = "pid", required = false) Integer pid,
			HttpServletRequest request, HttpServletResponse response) {
		
		Organ organ = new Organ();
		if (pid != null) {
			organ.setPid(pid);
		} else {
			organ.setPid(0);
		}

		//获取用户所属的机构
		HttpSession session = request.getSession();
		List<Integer> userOrgIds= (List<Integer>) session.getAttribute("userOrgIds");
		
		List<Organ> list = new ArrayList<Organ>();
		if(userOrgIds!=null){
			if(pid != null){				
				list = organService.getOrganByPId(organ);	
			}else {
				list = organService.getOrganByOrgIds(userOrgIds);
			}			
		}else{
			list = organService.getOrganByPId(organ);	
		}
		// 加载子节点，方式一，无子节点则无展开按钮
		for (Organ a : list) {
			a.setText(a.getName()); 
			if(a.getChildrenCount()>0){
				a.setState("closed");
			}else{
				a.setState("open");
			}
			
		}
		
		return list;// json.toString();
	}
	 /**
     * 根据机构ID查询用户
     */
    @ResponseBody
	@RequestMapping(value = "/loadUserListByOrgId.do", method = RequestMethod.POST) 
	public List<User> loadUserListByOrgId(
			@RequestParam(value = "orgId", required = false) Integer orgId,
			HttpServletRequest request, HttpServletResponse response) { 
    	List<User> list = new ArrayList<User>();
        try{
        	list = userService.getUserListByOrgId(orgId);	 
        }
        catch(Exception ex){
            ex.printStackTrace();
        }
        return list;
	}
	
	
	
    @ResponseBody
    @RequestMapping(value={"/userLogin.do"}, method={org.springframework.web.bind.annotation.RequestMethod.POST})
    public JsonResult<User> userLogin(User user, HttpServletRequest request, HttpServletResponse response) {
        JsonResult<User> json = new JsonResult<User>();
        json.setCode(Constants.RESULT_FAILED);
        json.setMessage("登录失败!");
        try {
            ReturnResult<User> res = this.userService.login(user.getAccount(), user.getPwd(),false);
            if (res.getCode().intValue() == ReturnResult.SUCCESS) {
                User u = res.getResultObject(); 
                //获取该用户类型所有模块 
                List<FunctionMenu> lf = new ArrayList<FunctionMenu>(); 
//                //不是超级管理员
                if(!u.getAccount().equals(Constants.USER_SUPER_ADMIN_ACCOUNT)){
                    //获取当前用户角色  
                    List<Role> roleList = roleService.getRolesByUserId(u.getId());
                    
                    
                    //根据角色查询资源
                    /*List<RoleResource> roleResourceList=new ArrayList<RoleResource>();                    
                    for (Role role : roleList) {
                    	List<RoleResource> rrl=new ArrayList<RoleResource>();
                    	rrl=roleResourceService.selectByRoleId(role.getId());
                    	roleResourceList.addAll(rrl);
					}
                    //用户角色所对应的资源
                    List<ResourceConfig> resourceList = new ArrayList<ResourceConfig>(); 
                    for (RoleResource roleResource : roleResourceList) {
                    	ResourceConfig resourceById=new ResourceConfig();
                    	resourceById = resourceService.getResourceById(roleResource.getResourceId());
                    	resourceList.add(resourceById);
                    }
                    //根据用户对应的资源查询function  
                    List<FunctionMenu> fList=new ArrayList<FunctionMenu>();
                    Map<String,String> map = new HashMap<String,String>();
                    FunctionMenu functionMenu=null;
                    for(ResourceConfig rcf : resourceList) {
                    	functionMenu=functionService.getFunctionMenusById(rcf.getMoudleId());
                    	if(map.isEmpty()){
                    		fList.add(functionMenu);
         					map.put(functionMenu.getName(), functionMenu.getName());
         				}else{
	     					if(map.get(functionMenu.getName())==null){ 
	     						fList.add(functionMenu);
	     						map.put(functionMenu.getName(), functionMenu.getName());
	     					}
         				}
                    	 //lf.add(functionMenu);        
					}
                    Map<String,String> map1 = new HashMap<String,String>();
                    FunctionMenu functionMenusById=null;
                    for (FunctionMenu am : fList) {
                    	functionMenusById = functionService.getFunctionMenusById(am.getParentId());
                    	if(map1.isEmpty()){
                    		lf.add(functionMenusById);
                    		map1.put(functionMenusById.getName(), functionMenusById.getName());
         				}else{
	     					if(map1.get(functionMenusById.getName())==null){ 
	     						lf.add(functionMenusById);
	     						map1.put(functionMenusById.getName(), functionMenusById.getName());
	     					}
         				}
                    	
					}*/
                   
                    //根据用户角色查询一级按钮
                   	//lf = functionService.getFunctionMenusByUserRoles(roleList);
                    
                    
                    
                    //查询当前用户权限拥有的资源
                    List<ResourceConfig> ResourceConfigList = resourceService.getResourceConfigsByUserRoles(roleList);
                    
                    Map<String,String> map = new HashMap<String,String>();
                    for (ResourceConfig rcf : ResourceConfigList) {
						if(map.isEmpty()){
							map.put(rcf.getParentName(), rcf.getParentName());
							FunctionMenu functionMenu=new FunctionMenu();
							functionMenu.setName(rcf.getParentName());
							functionMenu.setUrl(rcf.getUrl());
							functionMenu.setId(rcf.getMoudleId());							
							List<FunctionMenu> fList= new ArrayList<FunctionMenu>();							
							Map<Integer,Integer> map1=new HashMap<Integer, Integer>();
							Integer pid=rcf.getParentId();							 
							for (ResourceConfig rcl : ResourceConfigList) {
								if(map1.isEmpty()){
									map1.put(rcl.getMoudleId(),rcl.getParentId());
									FunctionMenu fm=new FunctionMenu();
									fm.setName(rcl.getFunctionName());
									fm.setUrl(rcl.getUrl());
									fm.setId(rcl.getMoudleId());
									fList.add(fm);
								}else {
									if(map1.get(rcl.getMoudleId())==null && rcl.getParentId()==pid){
										map1.put(rcl.getMoudleId(),rcl.getParentId());
										FunctionMenu fm=new FunctionMenu();
										fm.setName(rcl.getFunctionName());
										fm.setUrl(rcl.getUrl());
										fm.setId(rcl.getMoudleId());
										fList.add(fm);
									}
								}								
							}
							functionMenu.setChildMenulist(fList);
							lf.add(functionMenu);
						}else {
							if(map.get(rcf.getParentName())==null){
								map.put(rcf.getParentName(), rcf.getParentName());
								FunctionMenu functionMenu=new FunctionMenu();
								functionMenu.setName(rcf.getParentName());
								functionMenu.setUrl(rcf.getUrl());
								functionMenu.setId(rcf.getMoudleId());								
								List<FunctionMenu> fList= new ArrayList<FunctionMenu>();								
								Map<Integer,Integer> map1=new HashMap<Integer, Integer>();
								Integer pid=rcf.getParentId();					 
								for (ResourceConfig rcl : ResourceConfigList) {
									if(map1.isEmpty() && rcl.getParentId()==pid){
										map1.put(rcl.getMoudleId(),rcl.getParentId());
										FunctionMenu fm=new FunctionMenu();
										fm.setName(rcl.getFunctionName());
										fm.setUrl(rcl.getUrl());
										fm.setId(rcl.getMoudleId());
										fList.add(fm);
									}else {
										if(map1.get(rcl.getMoudleId())==null && rcl.getParentId()==pid){
											map1.put(rcl.getMoudleId(),rcl.getParentId());
											FunctionMenu fm=new FunctionMenu();
											fm.setName(rcl.getFunctionName());
											fm.setUrl(rcl.getUrl());
											fm.setId(rcl.getMoudleId());
											fList.add(fm);
										}
									}								
								}
								functionMenu.setChildMenulist(fList);
								lf.add(functionMenu);
							}
						}
					}                   
       
                    
                }
                else{                	
                    lf = parseFunctionMenuList(this.functionService.getFunctionMenuByParentId(0));
                } 
                request.getSession().setAttribute(Constants.USER_SESSION_RESOURCE, lf);
               
                
                json.setGotoUrl(((FunctionMenu)lf.get(0)).getUrl()); 
                ((User)res.getResultObject()).setSelectedMainMemu(((FunctionMenu)lf.get(0)).getId().intValue());
                if(((FunctionMenu)lf.get(0)).getChildMenulist() != null){
                    ((User)res.getResultObject()).setSelectedChildMenu(((FunctionMenu)((FunctionMenu)lf.get(0)).getChildMenulist().get(0)).getId().intValue());
                    ((User)res.getResultObject()).setChildMenuList(((FunctionMenu)lf.get(0)).getChildMenulist());
                }else{
                    ((User)res.getResultObject()).setSelectedChildMenu(((FunctionMenu)lf.get(0)).getId().intValue());
                }
                
                //获取当前登录用户的机构
                List<Organ> userOrgByUserId = userService.getUserOrgByUserId(u.getId());
                Organ organ = userOrgByUserId.get(0);
                if(organ.getSupervision()==1){
                	u.setIsSupervision(true);
                }else{
                	u.setIsSupervision(false);
                }
                if(organ.getOrgtype()==Constants.ORG_TYPE_1 || organ.getOrgtype()==Constants.ORG_TYPE_2){
                	u.setIsBranch(true);                	
                }else {
                	u.setIsBranch(false);
				}
                setLoginUser(u);  /////
                json.setCode(Constants.RESULT_SUCCESS);
                json.setMessage("登录成功!");
            } else {
                json.setMessage(res.getMessage());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return json;
    }
  

    private List<FunctionMenu> parseFunctionMenuList(List<FunctionMenu> src)
    {
        for (FunctionMenu f : src) {
            if(f.getLeaf() == 0) {
                f.setChildMenulist(this.functionService.getFunctionMenuByParentId(f.getId()));
            }
        }
        return src;
    }
    
    @ResponseBody
    @RequestMapping({"/jsonLoadSession.do"})
    public JsonResult<User> jsonLoadSession(
            @RequestParam(value="selectedMainMemu", required=false) Integer selectedMainMemu,
            @RequestParam(value="selectedChildMenu", required=false) Integer selectedChildMenu,
            HttpServletRequest request, HttpServletResponse response) {
        JsonResult<User> json = new JsonResult<User>();
        if (selectedMainMemu != null) {
            getLoginUser().setSelectedMainMemu(selectedMainMemu.intValue());
            List<FunctionMenu> lf = (List<FunctionMenu>) request.getSession().getAttribute(Constants.USER_SESSION_RESOURCE);
            for (FunctionMenu resource : lf) {
                if (resource.getId().intValue() == selectedMainMemu.intValue()) {
                    if(resource.getChildMenulist() != null) {
                        getLoginUser().setSelectedChildMenu(resource.getChildMenulist().get(0).getId());
                    }else{
                        getLoginUser().setSelectedChildMenu(resource.getId().intValue());
                    }
                    break;
                }
            }
        }
        else if (selectedChildMenu != null) {
            getLoginUser().setSelectedChildMenu(selectedChildMenu.intValue());
        }
        json.setCode(new Integer(0));
        json.setMessage("更新成功!");

        return json;
    }
}