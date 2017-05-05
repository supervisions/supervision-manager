package com.rmbank.supervision.service;

import java.util.List;

import com.rmbank.supervision.model.ResourceConfig;

public interface ResourceService {

	List<ResourceConfig> getAllResourceByUserId(Integer id);

	List<ResourceConfig> getResourceList(ResourceConfig resourceConfig);

	int getResourceCount(ResourceConfig resourceConfig);

	ResourceConfig getResourceById(Integer id);

	boolean saveOrUpdateResource(ResourceConfig resourceConfig);

	List<ResourceConfig> getExistRresource(ResourceConfig resourceConfig);

	boolean deleteResourceById(Integer id);

	List<ResourceConfig> getResourceListBymoudleId(ResourceConfig resourceConfig);

}
