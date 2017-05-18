package com.rmbank.supervision.dao;

import java.util.List;

import com.rmbank.supervision.model.Item;
@MyBatisRepository
public interface ItemMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(Item record);

    int insertSelective(Item record);

    Item selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Item record);

    int updateByPrimaryKey(Item record);

	List<Item> getExistItem(Item item);

	List<Item> getItemList(Item item);

	int getItemCount(Item item);

	List<Item> getItemListByType(Item item);

	List<Item> getItemListBylgOrg(Item item);
}