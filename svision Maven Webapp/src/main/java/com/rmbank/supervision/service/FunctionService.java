package com.rmbank.supervision.service;

import java.util.List;

import com.rmbank.supervision.model.FunctionMenu;
import com.rmbank.supervision.model.Role;

public interface FunctionService {
	List<FunctionMenu> getFunctionMenuByParentId(Integer id);

	List<FunctionMenu> getFunctionMenusByUserRoles(List<Role> roleList);

	List<FunctionMenu> getOrganByParentId(FunctionMenu functionMenu);
 
}
