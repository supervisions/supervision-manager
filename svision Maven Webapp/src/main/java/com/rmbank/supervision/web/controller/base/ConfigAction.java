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

import com.rmbank.supervision.common.JsonResult;
import com.rmbank.supervision.common.utils.Constants;
import com.rmbank.supervision.model.Meta;
import com.rmbank.supervision.model.Organ;
import com.rmbank.supervision.service.ConfigService;
import com.rmbank.supervision.web.controller.SystemAction;


@Scope("prototype")
@Controller
@RequestMapping("/system/config")
public class ConfigAction extends SystemAction {
	/**
	 *资源注入
	 */
	@Resource 
	private ConfigService configService;
	
	
	
	/**
	 * 配置列表
	 * @param meta
	 * @param request
	 * @param response
	 * @return
	 * @throws UnsupportedEncodingException
	 */
	@RequestMapping(value = "/configList.do")
	@RequiresPermissions("system/role/configList.do")
	public String configList(Meta meta, HttpServletRequest request,
			HttpServletResponse response) throws UnsupportedEncodingException{
		// 判断搜索名是否为空，不为空则转为utf-8编码
		if (meta.getSearchName() != null && meta.getSearchName() != "") {
			String searchName = new String(meta.getSearchName().getBytes(
					"iso8859-1"), "utf-8");
			meta.setSearchName(searchName);
		}
		// 设置页面初始值及页面大小
		if (meta.getPageNo() == null)
			meta.setPageNo(1);
		meta.setPageSize(Constants.DEFAULT_PAGE_SIZE);
		int totalCount = 0;
		// 分页集合
		List<Meta> configList = new ArrayList<Meta>();
		try {
			if(meta.getPid()==null){
				meta.setPid(0);
			}
			// t_meta取满足要求的参数数据
			configList = configService.getConfigListByPid(meta);
			// t_meta取满足要求的记录总数
			totalCount = configService.getConfigCount(meta);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		// 通过request对象传值到前台
		meta.setTotalCount(totalCount);
		request.setAttribute("Config", meta);

		request.setAttribute("configList", configList);

		return "web/base/config/configList";
	}
	
	 /**
     * 跳转到新增配置/编辑配置页面
     * @return
     */
    @RequestMapping(value = "/configInfo.do", method = RequestMethod.GET, produces = "application/json;charset=UTF-8")
    @RequiresPermissions("system/config/configInfo.do")
    public String editConfig(@RequestParam(value = "id", required = false) Integer id,
			HttpServletRequest req, HttpServletResponse res){
    	//根据参数id判断是新增还是编辑，新增为0，不用传值；编辑为选中的参数id值，取对象，传值
		if(id != null && id != 0){
			Meta meta = new Meta();
			try{
				meta = configService.selectByPrimaryKey(id);
			}catch(Exception ex){
				ex.printStackTrace();
			}
			req.setAttribute("Config", meta);
		}
		
		//获取所属配置列表
		Meta meta = new Meta(); 
		//pid为0的是根配置
		meta.setPid(0);
		List<Meta> configList = configService.getConfigListByPid(meta);
		req.setAttribute("configList", configList);
		
		
    	return "web/base/config/configInfo";
    }
	
    /**
     * 新增/编辑配置
     * @param meta
     * @param request
     * @param response
     * @return
     */
    @ResponseBody
    @RequestMapping(value="jsonSaveOrUpdateMeta.do", method=RequestMethod.POST)
    @RequiresPermissions("system/config/jsonSaveOrUpdateMeta.do")
    public JsonResult<Meta> jsonSaveOrUpdateMeta(Meta meta,				
			HttpServletRequest request, HttpServletResponse response){
    	//新建一个json对象 并赋初值
    	JsonResult<Meta> js = new JsonResult<Meta>();
		js.setCode(new Integer(1));
		js.setMessage("保存失败!");
		
		boolean State =  false;
		try {
			//如果ID和pid相同，则修改无效
			if(meta.getId()==meta.getPid()){
				js.setCode(new Integer(1));
				js.setMessage("编辑无效，配置名称不能和所属配置相同！");
				return js;
			}
			
			//如为新增，则给id置0
			if (meta.getId() == null || meta.getId() == 0) {
				meta.setId(0);					
			} 
			
			Meta mt = new Meta();
			mt.setId(meta.getId());
			mt.setName(meta.getName());		
			
			//根据新增的是根配置还是子配置，来给相对应的字段赋值，若为根配置ConfigType=0，子配置为1
			if(meta.getConfigType()==0){
				meta.setLevel(0);
				meta.setLeafed(0);
				meta.setPid(0);
				meta.setPath(new String());
			}else if(meta.getConfigType()==1) {
				meta.setLevel(1);
				meta.setLeafed(1);
				meta.setKey(new String());
				meta.setPath(meta.getPid().toString());
			}
			
			
			
			//如为编辑，则给新建meta对象赋传来的id值
			if (meta.getId() > 0) {
				mt.setId(meta.getId());
				State = configService.saveOrUpdateMeta(meta);
				if(State){
					js.setCode(new Integer(0));
					js.setMessage("修改配置信息成功!");
					return js;
				}else{
					return js;
				}
			}

			//根据id去数据库匹配，如编辑，则可以直接保存；如新增，则需匹配该账号是否重复
			List<Meta> lc = configService.getExistMeta(mt);
			if (lc.size() == 0) {  
				State = configService.saveOrUpdateMeta(meta);
				if(State){
					js.setCode(new Integer(0));
					js.setMessage("保存配置信息成功!");
					return js;
				}else{
					return js;
				}
			} else {
				js.setMessage("该配置已存在!");
				return js;
			} 
		}catch(Exception ex){
			ex.printStackTrace();
		}
		
		return js;
    }
    
    /**
     * 修改配置状态
     */
    @ResponseBody
    @RequestMapping(value="/jsonMetaStateById.do", method=RequestMethod.POST)
    @RequiresPermissions("system/config/jsonMetaStateById.do")
    public JsonResult<Meta> jsonMetaStateById(Meta meta,				
			HttpServletRequest request, HttpServletResponse response) {
		
		//新建一个json对象 并赋初值
    	JsonResult<Meta> js = new JsonResult<Meta>();
		js.setCode(new Integer(1));
		js.setMessage("修改配置状态失败!");
		
		boolean metaState =false;
		try {					
			metaState= configService.MetaStateById(meta);
			if(metaState){
				js.setCode(new Integer(0));
				js.setMessage("修改配置状态成功!");
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
	 * 加载配置的树
	 * 
	 * @param pid
	 * @param request
	 * @param response
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/jsonLoadMetaTreeList.do")
	public List<Meta> getOrganList(
			@RequestParam(value = "pid", required = false) Integer pid,
			HttpServletRequest request, HttpServletResponse response) {

		Meta meta = new Meta();

		if (pid != null) {
			meta.setPid(pid);
		} else {
			meta.setPid(0);
		}

		List<Meta> list = new ArrayList<Meta>();
		list = configService.getConfigListByPid(meta);
		// for(Organ a:list){
		// a.setName(a.getName());
		// if(a.getChildrenCount() > 0){
		// a.setState("closed");
		// }else{
		// a.setChildren(new ArrayList<Organ>());
		// a.setState("open");
		// }
		// }
		// 加载子节点，方式一，无子节点则无展开按钮
		for (Meta a : list) {
			a.setText(a.getName());
			Meta m = new Meta();
			m.setPid(a.getId());
			List<Meta> list1 = new ArrayList<Meta>();
			list1 = configService.getConfigListByPid(m);
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

	private List<Meta> setChildren(List<Meta> ls) {
		// TODO Auto-generated method stub
		for (Meta c : ls) {
			c.setText(c.getName());
			Meta c1 = new Meta();
			c1.setPid(c.getId());
			List<Meta> lst = configService.getConfigListByPid(c1);
			if (lst.size() > 0) {
				lst = setChildren(lst);
				c.setChildren(lst);
				c.setState("open");
			} else {
				c.setChildren(new ArrayList<Meta>());
				c.setState("open");
			}
		}
		return ls;// json.toString();
	}

    
    
    
}
