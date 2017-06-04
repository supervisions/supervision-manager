package com.rmbank.supervision.web.controller.cases;

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
import com.rmbank.supervision.common.utils.IpUtil;
import com.rmbank.supervision.model.FunctionMenu;
import com.rmbank.supervision.model.GradeScheme;
import com.rmbank.supervision.model.GradeSchemeDetail;
import com.rmbank.supervision.model.Organ;
import com.rmbank.supervision.model.ResourceConfig;
import com.rmbank.supervision.model.User;
import com.rmbank.supervision.service.GradeSchemeDetailService;
import com.rmbank.supervision.service.GradeSchemeService;
import com.rmbank.supervision.service.SysLogService;
import com.rmbank.supervision.web.controller.SystemAction;


/**
 * 方案明细的Action
 * @author DELL
 *
 */
@Scope("prototype")
@Controller
@RequestMapping("/manage/casedetail")
public class CasedetailAction extends SystemAction {
	@Resource
	private GradeSchemeDetailService  gradeSchemeDetailService;
	@Resource
	private GradeSchemeService gradeSchemeService;
	@Resource
	private SysLogService logService;
	
	/**
	 * 方案明细列表
	 * @param request
	 * @param response
	 * @return
	 * @throws UnsupportedEncodingException 
	 */
	@RequestMapping("/casedetailList.do")
	@RequiresPermissions("manage/casedetail/casedetailList.do")
	public String casedetailList(GradeSchemeDetail gradeSchemeDetail,
			HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException{
		// 判断搜索名是否为空，不为空则转为utf-8编码
		if (gradeSchemeDetail.getSearchName() != null && gradeSchemeDetail.getSearchName() != "") {
			String searchName = new String(gradeSchemeDetail.getSearchName().getBytes(
					"iso8859-1"), "utf-8");
			gradeSchemeDetail.setSearchName(searchName);
		}
		// 设置页面初始值及页面大小
		if (gradeSchemeDetail.getPageNo() == null)
			gradeSchemeDetail.setPageNo(1);
		gradeSchemeDetail.setPageSize(Constants.DEFAULT_PAGE_SIZE);
		int totalCount = 0;
		// 分页集合
		List<GradeSchemeDetail> detailList = new ArrayList<GradeSchemeDetail>();
		try {
			if(gradeSchemeDetail.getPid()==null){
				gradeSchemeDetail.setPid(0);
			}
			//取满足要求的参数数据			
			detailList = gradeSchemeDetailService.getGradeSchemeDetailListByPid(gradeSchemeDetail);
			//取满足要求的记录总数
			totalCount = gradeSchemeDetailService.getGradeSchemeDetailCount(gradeSchemeDetail);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		// 通过request对象传值到前台
		gradeSchemeDetail.setTotalCount(totalCount);
		request.setAttribute("SchemeDetail", gradeSchemeDetail);
		request.setAttribute("DetailList", detailList);
		
		User loginUser = this.getLoginUser();
		String ip = IpUtil.getIpAddress(request);		
		logService.writeLog(Constants.LOG_TYPE_SYS, "用户："+loginUser.getName()+"，执行了量化指标列表的查询", 4, loginUser.getId(), loginUser.getUserOrgID(), ip);
		
		return "web/manage/casedetail/casedetailList";
	}
	
	/**
	 * 根据Pid,geadeId获取明细列表
	 * @param parentId
	 * @param request
	 * @param response
	 * @return
	 */
    @ResponseBody
    @RequestMapping(value = "/jsonLoadSchemeDetailListByPid.do", method = RequestMethod.POST)
    @RequiresPermissions("manage/casedetail/jsonLoadSchemeDetailListByPid.do")
    public JsonResult<GradeSchemeDetail> jsonLoadOrganListByPid(
            @RequestParam(value = "pid", required = false) Integer pid,
            @RequestParam(value = "gradeId", required = false) Integer gradeId,
            HttpServletRequest request, HttpServletResponse response) {    	
//        JsonResult<GradeSchemeDetail> js = new JsonResult<GradeSchemeDetail>();
//        js.setCode(new Integer(1));
//        js.setMessage("获取数据失败!");
//        GradeSchemeDetail detail = new GradeSchemeDetail();
//        detail.setPid(pid);
//        detail.setGradeId(gradeId);        
//        if (detail.getPageNo() == null)
//        	detail.setPageNo(1);
//        detail.setPageSize(Constants.DEFAULT_PAGE_SIZE);
//        
//        try{
//            List<GradeSchemeDetail> lc = gradeSchemeDetailService.getSchemeDetailListByPidAndGradeId(detail);
//            int totalCount = gradeSchemeDetailService.getGradeSchemeDetailCount(detail);
//            List<GradeSchemeDetail> deylist=new ArrayList<GradeSchemeDetail>();
//            for(GradeSchemeDetail c : lc){
//                if(c.getpName()==null){
//                    c.setpName("");
//                }   
//                if(c.getLeafed()==0 && c.getPid()!=0){
//                	GradeSchemeDetail det = new GradeSchemeDetail();
//                	det.setPid(c.getId());
//                	det.setGradeId(c.getGradeId());
//                	deylist = gradeSchemeDetailService.getSchemeDetailListByPidAndGradeId(det);
//                }
//            }
//            lc.addAll(deylist);
//            detail.setTotalCount(totalCount);
//            js.setObj(detail);
//            js.setCode(0);
//            js.setList(lc);
//            js.setMessage("获取数据成功!");
//        }
//        catch(Exception ex){
//            ex.printStackTrace();
//        }
//        return js;
    	JsonResult<GradeSchemeDetail> js = new JsonResult<GradeSchemeDetail>();
        js.setCode(new Integer(1));
        js.setMessage("获取数据失败!");
        GradeSchemeDetail detail = new GradeSchemeDetail();            
        if (detail.getPageNo() == null)
        	detail.setPageNo(1);
        detail.setPageSize(Constants.DEFAULT_PAGE_SIZE);        
        try{
            List<GradeSchemeDetail> lc = gradeSchemeDetailService.getGradeSchemeDetailList(detail);
            int totalCount = gradeSchemeDetailService.getGradeSchemeDetailCount(detail);
            List<GradeSchemeDetail> deylist=new ArrayList<GradeSchemeDetail>();
            String thisPath=pid+"."; //当前节点的孙子节点的path都是以此开头
            String substring = null;
            for(GradeSchemeDetail c : lc){
            	if(c.getPid() == pid && c.getGradeId()==gradeId){
                	deylist.add(c); //获取儿子节点                	
                }if(c.getPath().length()>2){
            		substring = c.getPath().substring(0, thisPath.length());
            	}if(thisPath.equals(substring) && c.getGradeId()==gradeId){
                	deylist.add(c);
                }
            }            
            detail.setTotalCount(totalCount);
            js.setObj(detail);
            User loginUser = this.getLoginUser();
    		String ip = IpUtil.getIpAddress(request);		
    		logService.writeLog(Constants.LOG_TYPE_SYS, "用户："+loginUser.getName()+"，执行了对下级量化指标列表的查询", 4, loginUser.getId(), loginUser.getUserOrgID(), ip);
    		
            js.setCode(0);
            js.setList(deylist);
            js.setMessage("获取数据成功!");
        }
        catch(Exception ex){
            ex.printStackTrace();
        }
        return js;
    }
    
    /**
     * 删除方案明细
     * @param id
     * @param request
     * @param response
     * @return
     */
    @ResponseBody
	@RequestMapping(value = "/jsondeleteDetailById.do", method = RequestMethod.POST)
	@RequiresPermissions("manage/casedetail/jsondeleteDetailById.do")
	public JsonResult<GradeSchemeDetail> jsondeleteGradeSchemeById(
			@RequestParam(value = "id", required = false) Integer id,
			HttpServletRequest request, HttpServletResponse response) {
		
		// 新建一个json对象 并赋初值
		JsonResult<GradeSchemeDetail> js = new JsonResult<GradeSchemeDetail>();
		js.setCode(new Integer(1));
		js.setMessage("删除失败!");
		try {	
			GradeSchemeDetail detail = gradeSchemeDetailService.selectByPrimaryKey(id);
			int state= gradeSchemeDetailService.deleteByPrimaryKey(id);
			
			if(state==1){
				User loginUser = this.getLoginUser();
	    		String ip = IpUtil.getIpAddress(request);		
	    		logService.writeLog(Constants.LOG_TYPE_LXGL, "用户："+loginUser.getName()+"，删除了量化指标："+detail.getName(), 3, loginUser.getId(), loginUser.getUserOrgID(), ip);
	    		
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
	 * 跳转到新增/编辑方案
	 * @param request
	 * @param response
	 * @return
	 * @throws UnsupportedEncodingException 
	 */
	@RequestMapping("/casedetailInfo.do")
	@RequiresPermissions("manage/casedetail/casedetailInfo.do")
	public String exitCasedetail(GradeSchemeDetail detail,
			HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException{
		
		
		GradeSchemeDetail schemeDetail= new GradeSchemeDetail();
		//若为编辑回显指标属性
		if(detail.getId() != null && detail.getId() != 0){
			String pName=new String(detail.getpName().getBytes("iso8859-1"), "utf-8");
			schemeDetail=gradeSchemeDetailService.getGradeSchemeDetailById(detail.getId());
			schemeDetail.setpName(pName);
		}
		
		request.setAttribute("SchemeDetail", schemeDetail);
		
		return "web/manage/casedetail/casedetailInfo";
	}
	
	/**
	 * 新增/编辑指标
	 */
	@ResponseBody
	@RequestMapping(value = "/jsonSaveOrUpdateDetail.do", method = RequestMethod.POST)
	@RequiresPermissions("manage/casedetail/jsonSaveOrUpdateDetail.do")
	public JsonResult<GradeSchemeDetail> jsonSaveOrUpdateDetail(GradeSchemeDetail detail,
			HttpServletRequest request, HttpServletResponse response) {

		// 新建一个json对象 并赋初值
		JsonResult<GradeSchemeDetail> js = new JsonResult<GradeSchemeDetail>();
		js.setCode(new Integer(1));
		js.setMessage("保存失败!");
		boolean state = false;
		try {
			// 如为新增，则给id置0
			if (detail.getId() == null || detail.getId() == 0) {
				detail.setId(0);
				detail.setLevel(1);				
				detail.setLeafed(1);
			}
			GradeSchemeDetail gsd = new GradeSchemeDetail();
			gsd.setId(detail.getId());
			gsd.setName(detail.getName());
			// 如为编辑，则给新建ResourceConfig对象赋传来的id值,并根据ID去修改
			if (detail.getId() > 0) {
				gsd.setId(detail.getId());
				state = gradeSchemeDetailService.saveOrUpdateDetail(detail);
				if (state) {
					User loginUser = this.getLoginUser();
		    		String ip = IpUtil.getIpAddress(request);		
		    		logService.writeLog(Constants.LOG_TYPE_LXGL, "用户："+loginUser.getName()+"，新增了量化指标："+detail.getName(), 1, loginUser.getId(), loginUser.getUserOrgID(), ip);
		    		
					js.setCode(new Integer(0));
					js.setMessage("保存成功!");
					return js;
				} else {
					return js;
				}
			}
			// 根据指标名称（name）去数据库匹配，如编辑，则可以直接保存；如新增，则需匹配名称是否重复
			List<GradeSchemeDetail> lc = gradeSchemeDetailService.getExistDetail(gsd);
			if (lc.size() == 0) {
				state = gradeSchemeDetailService.saveOrUpdateDetail(detail);
				if (state) {
					js.setCode(new Integer(0));
					js.setMessage("保存成功!");
					return js;
				} else {
					return js;
				}
			} else {
				js.setMessage("该资源已存在!");
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return js;
	}
	
	/**
	 * 加载方案管理的树
	 * @param pid
	 * @param request
	 * @param response
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/jsonLoadGradeSchemeTreeList.do")
	@RequiresPermissions("manage/casedetail/jsonLoadGradeSchemeTreeList.do")
	public List<GradeScheme> getGradeSchemeList(
			@RequestParam(value = "pid", required = false) Integer pid,
			HttpServletRequest request, HttpServletResponse response) {
    	
		GradeScheme gradeScheme = new GradeScheme();	
		//第一级父节点的集合
		List<GradeScheme> list = gradeSchemeService.getGradeSchemeListASC(gradeScheme);
		
		if(list.size() > 0){
			for(GradeScheme a:list){
				a.setText(a.getName());	
				
				GradeSchemeDetail gradeSchemeDetail=new GradeSchemeDetail();
				gradeSchemeDetail.setPid(0);
				gradeSchemeDetail.setGradeId(a.getId());
				List<GradeSchemeDetail> list2=gradeSchemeDetailService.getSchemeDetailListByPidAndGradeId(gradeSchemeDetail);
				for(GradeSchemeDetail a1:list2){
					a1.setText(a1.getName());
					a.setChildren(list2);
					a1.setState("open");
				}
				//a.setChildren(list2);
				a.setState("open");
			}
		}
		
		return list;// json.toString();
	}
    
	/**
	 * 新增指标时加载上级指标的树
	 * @param pid
	 * @param request
	 * @param response
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/jsonLoadSchemeDetailTreeList.do")
	@RequiresPermissions("manage/casedetail/jsonLoadSchemeDetailTreeList.do")
	public List<GradeSchemeDetail> jsonLoadSchemeDetailTreeList(
			@RequestParam(value = "pid", required = false) Integer pid,
			HttpServletRequest request, HttpServletResponse response) {
    	
		GradeSchemeDetail schemeDetail = new GradeSchemeDetail();	
		if (pid != null){
			schemeDetail.setPid(pid);
		}else {
			schemeDetail.setPid(0);
		}
		//第一级父节点的集合
		List<GradeSchemeDetail> list = gradeSchemeDetailService.getGradeSchemeDetailTreeByPid(schemeDetail);
		
		for(GradeSchemeDetail a:list){
			a.setText(a.getName());
			GradeSchemeDetail fun = new GradeSchemeDetail();
			fun.setPid(a.getId());
			List<GradeSchemeDetail> list1 = new ArrayList<GradeSchemeDetail>();
			list1 = gradeSchemeDetailService.getGradeSchemeDetailTreeByPid(fun);
			if(list1.size() > 0){
				list1 = setChildren(list1);
			}
			a.setChildren(list1);
			a.setState("open");
		}
		
		return list;// json.toString();
	}
	
	private List<GradeSchemeDetail> setChildren(List<GradeSchemeDetail> ls) {
		for (GradeSchemeDetail c : ls) {
			c.setText(c.getName());
			GradeSchemeDetail c1 = new GradeSchemeDetail();
			c1.setPid(c.getId());
			List<GradeSchemeDetail> lst = gradeSchemeDetailService.getGradeSchemeDetailTreeByPid(c1);
			if (lst.size() > 0) {
				lst = setChildren(lst);
				c.setChildren(lst);
				c.setState("open");
			} else {
				c.setChildren(new ArrayList<GradeSchemeDetail>());
				c.setState("open");
			}
		}
		return ls;// json.toString();
	}
	
	
}
