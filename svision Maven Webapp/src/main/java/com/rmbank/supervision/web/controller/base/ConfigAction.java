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

import com.rmbank.supervision.common.utils.Constants;
import com.rmbank.supervision.model.Meta;
import com.rmbank.supervision.model.Role;
import com.rmbank.supervision.service.ConfigService;
import com.rmbank.supervision.web.controller.SystemAction;

@Scope("prototype")
@Controller
@RequestMapping("/system/config")
public class ConfigAction extends SystemAction {
	
	@Resource 
	private ConfigService configService;
	
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
			// t_role取满足要求的参数数据
			configList = configService.getConfigList(meta);
			// t_role取满足要求的记录总数
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
}
