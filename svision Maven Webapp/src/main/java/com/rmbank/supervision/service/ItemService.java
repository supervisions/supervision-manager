package com.rmbank.supervision.service;

import java.util.List;

import com.rmbank.supervision.model.Item;

public interface ItemService {
	
	int deleteByPrimaryKey(Integer id);

    int insert(Item record);

    int insertSelective(Item record);

    Item selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Item record);

    int updateByPrimaryKey(Item record);

	List<Item> getExistItem(Item im);

	boolean saveOrUpdateItem(Item item, Integer[] orgIds);

	List<Item> getItemList(Item item);

	int getItemCount(Item item);

	boolean deleteItemById(Integer id);
}
