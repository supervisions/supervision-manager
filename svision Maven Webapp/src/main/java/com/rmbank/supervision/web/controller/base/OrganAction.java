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

import com.rmbank.supervision.common.JsonResult;
import com.rmbank.supervision.common.utils.Constants;
import com.rmbank.supervision.model.Organ;
import com.rmbank.supervision.service.OrganService;
import com.rmbank.supervision.web.controller.SystemAction;

@Scope("prototype")
@Controller
@RequestMapping("/system/organ")
public class OrganAction extends SystemAction {

	@Resource
	private OrganService organService;

	/**
	 * 获取机构列表
	 * 
	 * @param organ
	 * @param request
	 * @param response
	 * @return
	 * @throws UnsupportedEncodingException
	 */
	@RequestMapping(value = "/organList.do")
	@RequiresPermissions("system/organ/organList.do")
	public String organList(Organ organ, HttpServletRequest request,
			HttpServletResponse response) throws UnsupportedEncodingException {
		// 判断搜索名是否为空，不为空则转为utf-8编码
		if (organ.getSearchName() != null && organ.getSearchName() != "") {
			String searchName = new String(organ.getSearchName().getBytes(
					"iso8859-1"), "utf-8");
			organ.setSearchName(searchName);
		}
		// 设置页面初始值及页面大小
		if (organ.getPageNo() == null)
			organ.setPageNo(1);
		organ.setPageSize(Constants.DEFAULT_PAGE_SIZE);
		int totalCount = 0;
		// 分页集合
		List<Organ> organList = new ArrayList<Organ>();
		try {
			if(organ.getPid()==null){
				organ.setPid(0);
			}
			// t_org取满足要求的参数数据			
			organList = organService.getOrganListByPid(organ);
			// t_org取满足要求的记录总数
			totalCount = organService.getOrganCount(organ);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		// 通过request对象传值到前台
		organ.setTotalCount(totalCount);

		request.setAttribute("Organ", organ);

		request.setAttribute("organList", organList);

		return "web/base/organ/organList";
	}

	/**
	 * 根据Pid获取机构列表
	 * @param parentId
	 * @param request
	 * @param response
	 * @return
	 */
    @ResponseBody
    @RequestMapping(value = "/jsonLoadOrganListByPid.do", method = RequestMethod.POST)
    @RequiresPermissions("system/organ/jsonLoadOrganListByPid.do")
    public JsonResult<Organ> jsonLoadOrganListByPid(
            @RequestParam(value = "pid", required = false) Integer pid,
            HttpServletRequest request, HttpServletResponse response) {
        JsonResult<Organ> js = new JsonResult<Organ>();
        js.setCode(new Integer(1));
        js.setMessage("获取数据失败!");
        Organ organ = new Organ();
        organ.setPid(pid);
        if (organ.getPageNo() == null)
            organ.setPageNo(1);
        organ.setPageSize(Constants.DEFAULT_PAGE_SIZE);
        try{
            List<Organ> lc = organService.getOrganListByPid(organ);
            int totalCount = organService.getOrganCount(organ);
            for(Organ c : lc){
                if(c.getParentName()==null){
                    c.setParentName("");
                }                
            }
            organ.setTotalCount(totalCount);
            js.setObj(organ);
            js.setCode(0);
            js.setList(lc);
            js.setMessage("获取数据成功!");
        }
        catch(Exception ex){
            ex.printStackTrace();
        }
        return js;
    }
    
	/**
	 * 跳转到新增机构/编辑机构
	 */
	@RequestMapping(value = "/organInfo.do")
	@RequiresPermissions("system/organ/organInfo.do")
	public String editOrgan(
			@RequestParam(value = "id", required = false) Integer id,
			HttpServletRequest req, HttpServletResponse res) {

		// 根据参数id判断是新增还是编辑，新增为0，不用传值；编辑为选中的参数id值，取对象，传值
		if (id != null && id != 0) {
			Organ organ = new Organ();
			try {
				organ = organService.selectByPrimaryKey(id);
			} catch (Exception ex) {
				ex.printStackTrace();
			}
			req.setAttribute("Organ", organ);
		}
		return "web/base/organ/organInfo";
	}

	/**
	 * 新增/编辑机构
	 */
	@ResponseBody
	@RequestMapping(value = "/jsonSaveOrUpdateOrgan.do", method = RequestMethod.POST)
	@RequiresPermissions("system/organ/jsonSaveOrUpdateOrgan.do")
	public JsonResult<Organ> jsonSaveOrUpdateRole(Organ organ,
			HttpServletRequest request, HttpServletResponse response) {

		// 新建一个json对象 并赋初值
		JsonResult<Organ> js = new JsonResult<Organ>();
		js.setCode(new Integer(1));
		js.setMessage("保存失败!");

		boolean state = false;
		try {
			// 如为新增，则给id置0,给其他字段赋予默认值
			if (organ.getId() == null || organ.getId() == 0) {
				organ.setId(0);
				organ.setSort(1);
				organ.setPath("");
				organ.setLeaf(1);
				organ.setLevel(1);
				if (organ.getPid() == null) {
					organ.setPid(0);
				}
			}

			Organ o = new Organ();
			o.setId(organ.getId());
			o.setName(organ.getName());
			// 如为编辑，则给新建role对象赋传来的id值
			if (organ.getId() > 0) {
				o.setId(organ.getId());
				state = organService.saveOrUpdateOrgan(organ);
				if (state) {
					js.setCode(new Integer(0));
					js.setMessage("保存成功!");
					return js;
				} else {
					return js;
				}
			}
			// 根据机构名称去数据库匹配，如编辑，则可以直接保存；如新增，则需匹配机构名称是否重复
			List<Organ> lc = organService.getExistOrgan(o);
			if (lc.size() == 0) {
				state = organService.saveOrUpdateOrgan(organ);
				if (state) {
					js.setCode(new Integer(0));
					js.setMessage("保存成功!");
					return js;
				} else {
					return js;
				}
			} else {
				js.setMessage("该机构已存在!");
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return js;
	}

	/**
	 * 删除机构
	 */
	@ResponseBody
	@RequestMapping(value = "/jsondeleteOrganById.do", method = RequestMethod.POST)
	@RequiresPermissions("system/organ/jsondeleteOrganById.do")
	public JsonResult<Organ> jsondeleteOrganById(
			@RequestParam(value = "id", required = false) Integer id,
			HttpServletRequest request, HttpServletResponse response) {

		// 新建一个json对象 并赋初值
		JsonResult<Organ> js = new JsonResult<Organ>();
		js.setCode(new Integer(1));
		js.setMessage("删除失败!");
		try {
			boolean state = organService.deleteOrgByid(id);
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
	 * 修改机构状态
	 */
	@ResponseBody
	@RequestMapping(value = "/jsonupdateOrganById.do", method = RequestMethod.POST)
	@RequiresPermissions("system/organ/jsonupdateOrganById.do")
	public JsonResult<Organ> jsonupdateUserById(Organ organ,
			HttpServletRequest request, HttpServletResponse response) {

		// 新建一个json对象 并赋初值
		JsonResult<Organ> js = new JsonResult<Organ>();
		js.setCode(new Integer(1));
		js.setMessage("修改机构状态失败!");

		try {
			boolean state = organService.updateOrgStateByid(organ);
			if (state) {
				js.setCode(new Integer(0));
				js.setMessage("修改机构状态成功!");
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
	 * 加载机构的树
	 * 
	 * @param pid
	 * @param request
	 * @param response
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/jsonLoadOrganTreeList.do")
	public List<Organ> getOrganList(
			@RequestParam(value = "pid", required = false) Integer pid,
			HttpServletRequest request, HttpServletResponse response) {

		Organ organ = new Organ();

		if (pid != null) {
			organ.setPid(pid);
		} else {
			organ.setPid(0);
		}

		List<Organ> list = new ArrayList<Organ>();
		list = organService.getOrganByPId(organ);
		// 加载子节点，方式一，无子节点则无展开按钮
		for (Organ a : list) {
			a.setText(a.getName());
			Organ org = new Organ();
			org.setPid(a.getId());
			List<Organ> list1 = new ArrayList<Organ>();
			list1 = organService.getOrganByPId(org);
			if (list1.size() > 0) {
				list1 = setChildren(list1);
			}
			a.setChildren(list1);
			a.setState("open");
		}
		// 加载子节点，方式二，无子节点仍有展开按钮，加载速度快
		// if(list.size() > 0){
		// for(Organ a:list){
		// a.setText(a.getName());
		// a.setState("closed");
		// }
		// }
		return list;// json.toString();
	}

	private List<Organ> setChildren(List<Organ> ls) {
		for (Organ c : ls) {
			c.setText(c.getName());
			Organ c1 = new Organ();
			c1.setPid(c.getId());
			List<Organ> lst = organService.getOrganByPId(c1);
			if (lst.size() > 0) {
				lst = setChildren(lst);
				c.setChildren(lst);
				c.setState("open");
			} else {
				c.setChildren(new ArrayList<Organ>());
				c.setState("open");
			}
		}
		return ls;// json.toString();
	}

}
