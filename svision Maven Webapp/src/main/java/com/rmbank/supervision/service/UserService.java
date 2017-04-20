package com.rmbank.supervision.service;

import com.rmbank.supervision.common.ReturnResult;
import com.rmbank.supervision.model.User;

public interface UserService {

	ReturnResult<User> login(String name, String pwd, boolean rememberMe);

}
