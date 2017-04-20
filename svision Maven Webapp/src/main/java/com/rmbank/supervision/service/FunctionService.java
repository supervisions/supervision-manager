package com.rmbank.supervision.service;

import java.util.List;

import com.rmbank.supervision.model.FunctionMenu;

public interface FunctionService {
	List<FunctionMenu> getFunctionMenuByParentId(Integer id);
}
