package com.rmbank.supervision.rest.interceptor;

import com.rmbank.supervision.common.RestModelResult;
import org.apache.log4j.Logger;
import org.springframework.web.servlet.HandlerExceptionResolver;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Created by admin on 2016/9/18.
 */
public class ExceptionResolver implements HandlerExceptionResolver {


    private static Logger logger = Logger.getLogger(ExceptionResolver.class);


    @Override
    public ModelAndView resolveException(HttpServletRequest request,
                                         HttpServletResponse response, Object handler, Exception ex) {
        logger.error("Catch Exception: ",ex);//把漏网的异常信息记入日志

        RestModelResult result = new RestModelResult();


        try {
            result.setCode(1);
            //result.setMessage(ex.getMessage());
            return null;
        } catch (Exception e) {

        }
        return new ModelAndView("error");
    }
}
