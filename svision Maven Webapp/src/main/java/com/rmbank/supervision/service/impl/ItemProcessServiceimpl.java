package com.rmbank.supervision.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.rmbank.supervision.model.ItemProcess;
import com.rmbank.supervision.service.ItemProcessService;
import com.rmbank.supervision.dao.ItemProcessMapper;

@Service("itemProcessService")
public class ItemProcessServiceimpl implements ItemProcessService{

	@Resource
	private ItemProcessMapper itemProcessMapper;
	
	@Override
	public int deleteByPrimaryKey(Integer id) {
		// TODO Auto-generated method stub
		return itemProcessMapper.deleteByPrimaryKey(id);
	}

	@Override
	public int insert(ItemProcess record) {
		// TODO Auto-generated method stub
		return itemProcessMapper.insert(record);
	}

	@Override
	public int insertSelective(ItemProcess record) {
		// TODO Auto-generated method stub
		return itemProcessMapper.insertSelective(record);
	}

	@Override
	public ItemProcess selectByPrimaryKey(Integer id) {
		// TODO Auto-generated method stub
		return itemProcessMapper.selectByPrimaryKey(id);
	}

	@Override
	public int updateByPrimaryKeySelective(ItemProcess record) {
		// TODO Auto-generated method stub
		return itemProcessMapper.updateByPrimaryKeySelective(record);
	}

	@Override
	public int updateByPrimaryKey(ItemProcess record) {
		// TODO Auto-generated method stub
		return itemProcessMapper.updateByPrimaryKey(record);
	}

	@Override
	public List<Integer> getItemProcessIdByUuid(String uuid) {
		// TODO Auto-generated method stub
		return itemProcessMapper.getItemProcessIdByUuid(uuid);
	}

	@Override
	public List<ItemProcess> getItemProcessItemId(Integer id) {
		// TODO Auto-generated method stub
		return itemProcessMapper.getItemProcessItemId(id);
	}

}
