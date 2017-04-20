package com.rmbank.supervision.dao;

import com.rmbank.supervision.model.ResourceConfig;
@MyBatisRepository
public interface ResourceConfigMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(ResourceConfig record);

    int insertSelective(ResourceConfig record);

    ResourceConfig selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(ResourceConfig record);

    int updateByPrimaryKey(ResourceConfig record);
}