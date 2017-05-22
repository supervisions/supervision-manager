
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

	boolean saveOrUpdateItem(Item item, Integer[] orgIds, String content);

	List<Item> getItemList(Item item);

	int getItemCount(Item item);

	boolean deleteItemById(Integer id);

	/**
	 * 实时监察类型的项目
	 * @param item
	 * @return
	 */
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

	/**
	 * 分行立项分行完成
	 * @param item
	 * @return
	 */
	List<Item> getItemListByFHLXFHWC(Item item);

	/**
	 * 分行立项中支完成
	 * @param item
	 * @return
	 */
	List<Item> getItemListByFHLXZZWC(Item item);
} 