package com.rmbank.supervision.service;

import java.util.List;

import com.rmbank.supervision.model.RoleResource;

public interface RoleResourceService {
	int deleteByPrimaryKey(Integer id);

    int insert(RoleResource record);

    int insertSelective(RoleResource record);

    RoleResource selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(RoleResource record);

    int updateByPrimaryKey(RoleResource record);

	boolean saveRoleResource(Integer roleId, Integer[] resourceIds);

	List<RoleResource> selectByRoleId(Integer id);

	//List<RoleResource> getRoleResourceListByRoleId(Integer id);
	

}
