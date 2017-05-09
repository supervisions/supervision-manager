package com.rmbank.supervision.dao;

import com.rmbank.supervision.model.ItemProcess;
@MyBatisRepository
public interface ItemProcessMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(ItemProcess record);

    int insertSelective(ItemProcess record);

    ItemProcess selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(ItemProcess record);

    int updateByPrimaryKey(ItemProcess record);
}