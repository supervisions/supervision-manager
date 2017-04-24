package com.rmbank.supervision.service.impl;

import java.util.List;

import javax.annotation.Resource;

import com.rmbank.supervision.dao.MetaMapper;
import com.rmbank.supervision.model.Meta;
import com.rmbank.supervision.service.ConfigService;

public class ConfigServiceimpl implements ConfigService {

	@Resource 
	private MetaMapper metaMapper;
	
	@Override
	public List<Meta> getConfigByUserId(Integer id) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<Meta> getConfigList(Meta meta) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int getConfigCount(Meta meta) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public Meta getConfigById(Integer id) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<Meta> getExistConfig(Meta meta) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public boolean saveOrUpdateConfig(Meta meta) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean deleteConfigById(Integer id) {
		// TODO Auto-generated method stub
		return false;
	}

}
