package com.rmbank.supervision.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.rmbank.supervision.dao.RoleMapper;
import com.rmbank.supervision.dao.UserRoleMapper;
import com.rmbank.supervision.model.Role;
import com.rmbank.supervision.service.RoleService;
@Service("roleService")
public class RoleServiceImpl implements RoleService{


    @Resource
    private UserRoleMapper userRoleMapper;
    
    @Resource
    private RoleMapper roleMapper;
	
	@Override
	public List<Role> getRolesByUserId(Integer id) {
		// TODO Auto-generated method stub
		return userRoleMapper.getRolesByUserId(id);
	}

	@Override
	public List<Role> getRoleList(Role role) {
		// TODO Auto-generated method stub
		return roleMapper.getRoleList(role);
	}

	@Override
	public int getRoleCount(Role role) {
		// TODO Auto-generated method stub
		return roleMapper.getRoleCount(role);
	}

	@Override
	public Role getRoleById(Integer id) {
		// TODO Auto-generated method stub
		return roleMapper.getRoleById(id);
	}

	@Override
	public List<Role> getExistRole(Role role) {
		// TODO Auto-generated method stub
		return roleMapper.getExistRole(role);
	}

	@Override
	public boolean saveOrUpdateRole(Role role) {
		boolean isSuccess = false;
		try{
			//id存在则为修改操作
			if(role.getId()>0){
				roleMapper.updateByPrimaryKeySelective(role);
				isSuccess = true;
			}else{	               
                roleMapper.insert(role); 
				isSuccess = true;
         
			}
		}catch(Exception ex){
			ex.printStackTrace();
		}
		return isSuccess;
		
	}

	@Override
	public boolean deleteRoleById(Integer id) {
		boolean isSuccess = false;
		try{
			roleMapper.deleteRoleById(id);
		
		}catch(Exception ex){
			ex.printStackTrace();
		}
		return isSuccess;

	}

}
