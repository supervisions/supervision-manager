package com.rmbank.supervision.web.controller.base;

import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.rmbank.supervision.web.controller.SystemAction;


@Scope("prototype")
@Controller
@RequestMapping("/system/organ")
public class OrganAction extends SystemAction  {

}
