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

	List<Item> getItemListByLgOrg(Item item);

	/**
	 * 查询所有中支立项中支完成的项目
	 * @param item
	 * @return
	 */
	List<Item> getItemListByOrgType(Item item);

	/**
	 * 查询当前登录中支立的项目
	 * @param item
	 * @return
	 */
	List<Item> getItemListByOrgTypeAndLogOrg(Item item);

	List<Item> getItemListByFHLXFHWC(Item item);
}