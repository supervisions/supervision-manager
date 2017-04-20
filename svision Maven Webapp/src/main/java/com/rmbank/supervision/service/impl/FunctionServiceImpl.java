package com.rmbank.supervision.service.impl;

import java.util.List;

import javax.annotation.Resource;

import com.rmbank.supervision.dao.FunctionMenuMapper;
import com.rmbank.supervision.model.FunctionMenu;
import com.rmbank.supervision.service.FunctionService;

public class FunctionServiceImpl implements FunctionService{

    @Resource
    private FunctionMenuMapper functionMenuMapper;

	@Override
	public List<FunctionMenu> getFunctionMenuByParentId(Integer id) {
		 FunctionMenu functionMenu = new FunctionMenu();
	        functionMenu.setParentId(id);
	        return functionMenuMapper.getFunctionMenuByCondition(functionMenu);
	    }
}
