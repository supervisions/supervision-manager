package com.rmbank.supervision.service.impl;

import javax.annotation.Resource;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.ExcessiveAttemptsException;
import org.apache.shiro.subject.Subject;
import org.springframework.stereotype.Service;

import com.rmbank.supervision.common.ReturnResult;
import com.rmbank.supervision.common.shiro.ShiroUsernamePasswordToken;
import com.rmbank.supervision.common.utils.Constants;
import com.rmbank.supervision.dao.UserMapper;
import com.rmbank.supervision.model.User;
import com.rmbank.supervision.service.UserService;



@Service("userService")
public class UserServiceImpl implements UserService {

    @Resource
    private UserMapper userMapper;
    
	@Override
	public ReturnResult<User> login(String name, String pwd, boolean rememberMe) {
		Subject subject = SecurityUtils.getSubject();
        ReturnResult<User> res = new ReturnResult<User>();
        try {
            User temp = new User();
            temp.setAccount(name);
            temp.setUsed(Constants.USER_STATUS_EFFICTIVE); 
            User u = this.userMapper.getUserByAccount(temp);
            if (u == null) {
                res.setCode(Integer.valueOf(0));
                res.setMessage("用户[" + name + "]不存在！");
            }
            else{
                ShiroUsernamePasswordToken token = new ShiroUsernamePasswordToken(
                        u.getAccount(), pwd, u.getPwd(), u.getSalt(),
                        null);
//                token.setRememberMe(rememberMe);
                subject.login(token);
                if (subject.isAuthenticated()) {
                    res.setCode(Integer.valueOf(1));
                    res.setMessage("登录成功！");
                    res.setResultObject(u);
                } else {
                    res.setCode(Integer.valueOf(0));
                    res.setMessage("登录失败，密码错误。");
                }
            }
        }
        catch (ExcessiveAttemptsException ex) {
            res.setCode(Integer.valueOf(0));
            res.setMessage("登录失败，未知错误。");
        } catch (AuthenticationException ex) {
            res.setCode(Integer.valueOf(0));
            res.setMessage("登录失败，密码错误。");
        }
        return res;
	}

	@Override
	public User getUserByAccount(String username) {
		// TODO Auto-generated method stub
		User user = new User();
		user.setAccount(username);
		return userMapper.getUserByAccount(user);
	}

}
