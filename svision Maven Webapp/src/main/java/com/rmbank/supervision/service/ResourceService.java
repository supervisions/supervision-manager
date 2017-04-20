package com.rmbank.supervision.service;

import java.util.List;

import com.rmbank.supervision.model.ResourceConfig;

public interface ResourceService {

	List<ResourceConfig> getAllResourceByUserId(Integer id);

}
