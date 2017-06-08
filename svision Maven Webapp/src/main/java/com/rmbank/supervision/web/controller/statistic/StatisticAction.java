package com.rmbank.supervision.web.controller.statistic;

import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
 
import com.rmbank.supervision.model.Item; 

/**
 * 分行立项的Action
 * @author LQ
 *
 */
@Scope("prototype")
@Controller
@RequestMapping("/statistic")
public class StatisticAction {
	
		/**
		 * 效能监察统计
		 * @param request
		 * @param response
		 * @return
		 * @throws UnsupportedEncodingException 
		 */
		@RequestMapping("/efficiency/efficencyStatistic.do")
		@RequiresPermissions("statistic/efficiency/efficencyStatistic.do")
		public String efficencyStatistic(Item item, 
				HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException{
			 
			return "web/statistic/branchFHList";
		}

		/**
		 * 廉政监察统计
		 * @param request
		 * @param response
		 * @return
		 * @throws UnsupportedEncodingException 
		 */
		@RequestMapping("/incorrupt/incorruptStatistic.do")
		@RequiresPermissions("statistic/incorrupt/incorruptStatistic.do")
		public String incorruptStatistic(Item item, 
				HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException{
			 
			return "web/statistic/incorruptStatistic";
		}

		/**
		 * 执法监察统计
		 * @param request
		 * @param response
		 * @return
		 * @throws UnsupportedEncodingException 
		 */
		@RequestMapping("/enforce/enforceStatistic.do")
		@RequiresPermissions("statistic/enforce/enforceStatistic.do")
		public String enforceStatistic(Item item, 
				HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException{
			 
			return "web/statistic/enforceStatistic";
		}

		/**
		 * 分行立项统计
		 * @param request
		 * @param response
		 * @return
		 * @throws UnsupportedEncodingException 
		 */
		@RequestMapping("/branch/branchStatistic.do")
		@RequiresPermissions("statistic/branch/branchStatistic.do")
		public String branchStatistic(Item item, 
				HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException{
			 
			return "web/statistic/branchStatistic";
		}

		/**
		 * 分行立项统计
		 * @param request
		 * @param response
		 * @return
		 * @throws UnsupportedEncodingException 
		 */
		@RequestMapping("/support/supportStatistic.do")
		@RequiresPermissions("statistic/support/supportStatistic.do")
		public String supportStatistic(Item item, 
				HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException{
			 
			return "web/statistic/supportStatistic";
		}
}
