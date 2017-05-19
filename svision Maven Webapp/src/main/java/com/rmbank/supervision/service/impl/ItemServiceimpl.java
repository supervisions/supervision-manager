 
package com.rmbank.supervision.service.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.rmbank.supervision.common.utils.Constants;
import com.rmbank.supervision.dao.ItemMapper;
import com.rmbank.supervision.dao.ItemProcessMapper;
import com.rmbank.supervision.model.Item;
import com.rmbank.supervision.model.ItemProcess;
import com.rmbank.supervision.service.ItemService;
@Service(value="itemService")
public class ItemServiceimpl implements ItemService {
	@Resource 
	private ItemMapper itemMapper;
	@Resource
	private ItemProcessMapper itemProcessMapper;
	
	@Override
	public int deleteByPrimaryKey(Integer id) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int insert(Item record) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int insertSelective(Item record) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public Item selectByPrimaryKey(Integer id) {
		// TODO Auto-generated method stub
		return itemMapper.selectByPrimaryKey(id);
	}

	@Override
	public int updateByPrimaryKeySelective(Item record) {
		// TODO Auto-generated method stub
		return itemMapper.updateByPrimaryKeySelective(record);
	}

	@Override
	public int updateByPrimaryKey(Item record) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public List<Item> getExistItem(Item im) {
		// TODO Auto-generated method stub
		return itemMapper.getExistItem(im);
	}

	@Override
	public boolean saveOrUpdateItem(Item item, Integer[] orgIds,String content) {
		boolean isSuccess = false;
		try{	
			//新增项目成功后返回的itemId的集合 
			List<Integer> itemId=new ArrayList<Integer>();
			
			for (Integer i : orgIds) {				
				item.setSupervisionOrgId(i);
				itemMapper.insert(item); 
				itemId.add(item.getId());
				item.setId(0);
			}
			ItemProcess itemProcess=new ItemProcess();
			for (Integer integer : itemId) {				
				itemProcess.setUuid(item.getUuid());
				itemProcess.setItemId(integer);
				//itemProcess.setDefined();
				itemProcess.setContent(content);
				itemProcess.setContentTypeId(Constants.CONTENT_TYPE_ID_1);
				itemProcess.setPreparerTime(new Date());
				itemProcess.setPreparerId(item.getPreparerId());
				itemProcess.setPreparerOrgId(item.getPreparerOrgId());
				itemProcessMapper.insertSelective(itemProcess);
			}
			
			isSuccess = true;
         
		}catch(Exception ex){
			ex.printStackTrace();
		}
		return isSuccess;
	}

	@Override
	public List<Item> getItemList(Item item) {
		// TODO Auto-generated method stub
		return itemMapper.getItemList(item);
	}

	@Override
	public int getItemCount(Item item) {
		// TODO Auto-generated method stub
		return itemMapper.getItemCount(item);
	}

	@Override
	public boolean deleteItemById(Integer id) {
		// TODO Auto-generated method stub
		boolean isSuccess = false;
		try{
			itemMapper.deleteByPrimaryKey(id);
			isSuccess = true;
		}catch(Exception ex){
			ex.printStackTrace();
		}
		return isSuccess;
	}

	@Override
	public List<Item> getItemListByType(Item item) {
		// TODO Auto-generated method stub
		return itemMapper.getItemListByType(item);
	}

	@Override
	public List<Item> getItemListByLgOrg(Item item) {
		// TODO Auto-generated method stub
		return itemMapper.getItemListByLgOrg(item);
	}

	/**
	 * 查询所有中支立项中支完成的项目
	 * @param item
	 * @return
	 */
	@Override
	public List<Item> getItemListByOrgType(Item item) {
		// TODO Auto-generated method stub
		return itemMapper.getItemListByOrgType(item);
	}

	/**
	 * 查询当前登录中支立的项目
	 * @param item
	 * @return
	 */
	@Override
	public List<Item> getItemListByOrgTypeAndLogOrg(Item item) {
		// TODO Auto-generated method stub
		return itemMapper.getItemListByOrgTypeAndLogOrg(item);
	}

	/**
	 * 分行立项分行完成
	 */
	@Override
	public List<Item> getItemListByFHLXFHWC(Item item) {
		// TODO Auto-generated method stub
		return itemMapper.getItemListByFHLXFHWC(item);
	}

	/**
	 * 分行立项中支完成
	 */
	@Override
	public List<Item> getItemListByFHLXZZWC(Item item) {
		// TODO Auto-generated method stub
		return itemMapper.getItemListByFHLXZZWC(item);
	}

}  