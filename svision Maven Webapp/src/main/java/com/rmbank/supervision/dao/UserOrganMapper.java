package com.rmbank.supervision.dao;

import com.rmbank.supervision.model.UserOrgan;
@MyBatisRepository
public interface UserOrganMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(UserOrgan record);

    int insertSelective(UserOrgan record);

    UserOrgan selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(UserOrgan record);

    int updateByPrimaryKey(UserOrgan record);
}