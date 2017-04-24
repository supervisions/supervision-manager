package com.rmbank.supervision.service;

import java.util.List;

import com.rmbank.supervision.common.ReturnResult;
import com.rmbank.supervision.model.User;



public interface UserService {

	ReturnResult<User> login(String name, String pwd, boolean rememberMe);

	User getUserByAccount(String username);
	
	List<User> getUserList(User user);
	
	int getUserCount(User user);

	User getUserById(Integer id);

	List<User> getExistUser(User u);

	boolean saveOrUpdateUser(User user);


}
