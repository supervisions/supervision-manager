package com.rmbank.supervision.dao;

import com.rmbank.supervision.model.Meta;
@MyBatisRepository
public interface MetaMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(Meta record);

    int insertSelective(Meta record);

    Meta selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Meta record);

    int updateByPrimaryKey(Meta record);
}