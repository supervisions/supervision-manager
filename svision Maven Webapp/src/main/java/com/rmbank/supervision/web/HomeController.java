package com.rmbank.supervision.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.rmbank.supervision.common.JsonResult;
import com.rmbank.supervision.common.ReturnResult;
import com.rmbank.supervision.common.utils.Constants;
import com.rmbank.supervision.model.FunctionMenu;
import com.rmbank.supervision.model.ResourceConfig;
import com.rmbank.supervision.model.Role;
import com.rmbank.supervision.model.User;
import com.rmbank.supervision.service.FunctionService;
import com.rmbank.supervision.service.ResourceService;
import com.rmbank.supervision.service.RoleService;
import com.rmbank.supervision.service.UserService;
import com.rmbank.supervision.web.controller.SystemAction;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class HomeController extends SystemAction {

    @Resource(name="userService")
    private UserService userService;

    @Resource(name="functionService")
    private FunctionService functionService;

    @Resource(name="resourceService")
    private ResourceService resourceService;

    @Resource(name="roleService")
    private RoleService roleService;

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
                    //获取当前用户资源  
                    List<Role> roleList = roleService.getRolesByUserId(u.getId());
                    lf = functionService.getFunctionMenusByUserRoles(roleList);
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
                setLoginUser(u);
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