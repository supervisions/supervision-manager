package com.rmbank.supervision.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.rmbank.supervision.dao.ItemMapper;
import com.rmbank.supervision.model.Item;
import com.rmbank.supervision.service.ItemService;
@Service(value="itemService")
public class ItemServiceimpl implements ItemService {
	@Resource 
	private ItemMapper itemMapper;
	
	
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
		return 0;
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
	public boolean saveOrUpdateItem(Item item, Integer[] orgIds) {
		boolean isSuccess = false;
		try{
			//id存在则为修改操作
			if(item.getId()>0){
				itemMapper.deleteByPrimaryKey(item.getId());
				itemMapper.updateByPrimaryKeySelective(item);
				isSuccess = true;
			}else{	               
				for (Integer i : orgIds) {
					item.setSupervisionOrgId(i);
					itemMapper.insert(item); 
				}
				
				isSuccess = true;
         
			}
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

}
