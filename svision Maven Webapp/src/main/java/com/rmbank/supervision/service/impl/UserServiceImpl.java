package com.rmbank.supervision.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.ExcessiveAttemptsException;
import org.apache.shiro.subject.Subject;
import org.springframework.stereotype.Service;

import com.rmbank.supervision.common.ReturnResult;
import com.rmbank.supervision.common.shiro.ShiroUsernamePasswordToken;
import com.rmbank.supervision.common.utils.Constants;
import com.rmbank.supervision.common.utils.EndecryptUtils;
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
	
	
	/**
	 * 获取用户列表
	 */
	@Override
	public List<User> getUserList(User user) {
		// TODO Auto-generated method stub		
		return userMapper.getUserList(user);
	}
	/**
	 * 获取用户记录数
	 */
	@Override
	public int getUserCount(User user) {
		// TODO Auto-generated method stub
		return userMapper.getUserCount(user);
	}

	/**
	 * 编辑用户，根据id回显用户信息
	 */
	@Override
	public User getUserById(Integer id) {
		// TODO Auto-generated method stub
		return userMapper.getUserById(id);
	}

	/**
	 * 新增用户时查询用户名是否存在
	 */
	@Override
	public List<User> getExistUser(User u) {
		// TODO Auto-generated method stub
		return userMapper.getExistUser(u);
	}

	/**
	 * 新增用户/修改用户
	 */
	@Override
	public boolean saveOrUpdateUser(User user) {
		boolean isSuccess = false;
		try{
			//id存在则为修改操作
			if(user.getId()>0){
				userMapper.updateByPrimaryKeySelective(user);
				isSuccess = true;
			}else{
				User u = EndecryptUtils.md5Password(user.getAccount(), user.getPwd());
	            if (u != null) {
	                user.setPwd(u.getPwd());
	                user.setSalt(u.getSalt());
	                userMapper.insert(user); 
					isSuccess = true;
	            }
			}
		}catch(Exception ex){
			ex.printStackTrace();
		}
		return isSuccess;
		
	}
	
	
}
