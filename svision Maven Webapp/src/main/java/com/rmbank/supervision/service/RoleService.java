package com.rmbank.supervision.service;

import java.util.List;

import com.rmbank.supervision.model.Role;

public interface RoleService {

	List<Role> getRolesByUserId(Integer id);

}
