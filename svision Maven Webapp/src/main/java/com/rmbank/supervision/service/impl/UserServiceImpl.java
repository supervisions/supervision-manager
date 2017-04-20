package com.rmbank.supervision.service.impl;

import org.springframework.stereotype.Service;

import com.rmbank.supervision.common.ReturnResult;
import com.rmbank.supervision.model.User;
import com.rmbank.supervision.service.UserService;



@Service("userService")
public class UserServiceImpl implements UserService {

	@Override
	public ReturnResult<User> login(String name, String pwd, boolean rememberMe) {
		// TODO Auto-generated method stub
		return null;
	}

}
