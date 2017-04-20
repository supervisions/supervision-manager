package com.rmbank.supervision.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.rmbank.supervision.dao.UserMapper;
import com.rmbank.supervision.dao.UserRoleMapper;
import com.rmbank.supervision.model.Role;
import com.rmbank.supervision.service.RoleService;
@Service("roleService")
public class RoleServiceImpl implements RoleService{


    @Resource
    private UserRoleMapper userRoleMapper;
	
	@Override
	public List<Role> getRolesByUserId(Integer id) {
		// TODO Auto-generated method stub
		return userRoleMapper.getRolesByUserId(id);
	}

}
