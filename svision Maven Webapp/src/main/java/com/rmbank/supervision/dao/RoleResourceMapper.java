package com.rmbank.supervision.dao;

import java.util.List;

import com.rmbank.supervision.model.RoleResource;
@MyBatisRepository
public interface RoleResourceMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(RoleResource record);

    int insertSelective(RoleResource record);

    RoleResource selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(RoleResource record);

    int updateByPrimaryKey(RoleResource record);

	List<RoleResource> selectByRoleId(Integer roleId);

	int deleteByRoleId(Integer roleId);
}