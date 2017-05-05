package com.rmbank.supervision.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.rmbank.supervision.dao.RoleResourceMapper;
import com.rmbank.supervision.model.RoleResource;
import com.rmbank.supervision.model.UserOrgan;
import com.rmbank.supervision.service.RoleResourceService;

@Service("roleResourceService")
public class RoleResourceServiceimpl implements RoleResourceService {

	@Resource
	private RoleResourceMapper roleResourceMapper;
	
	
	@Override
	public int deleteByPrimaryKey(Integer id) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int insert(RoleResource record) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int insertSelective(RoleResource record) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public RoleResource selectByPrimaryKey(Integer id) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int updateByPrimaryKeySelective(RoleResource record) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int updateByPrimaryKey(RoleResource record) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public boolean saveRoleResource(Integer roleId, Integer[] resourceIds) {
		// TODO Auto-generated method stub
		boolean isSuccess = false;
		try {
			roleResourceMapper.deleteByRoleId(roleId);
			for (Integer resId : resourceIds) {
				RoleResource roleResource=new RoleResource();
				roleResource.setId(0);
				roleResource.setRoleId(roleId);
				roleResource.setResourceId(resId);
				roleResource.setControl(1);
				roleResourceMapper.insert(roleResource);
			}
			isSuccess = true;
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return isSuccess;
	}

	@Override
	public List<RoleResource> selectByRoleId(Integer id) {
		// TODO Auto-generated method stub
		return roleResourceMapper.selectByRoleId(id);
	}

}
