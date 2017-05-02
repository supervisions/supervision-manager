package com.rmbank.supervision.dao;

import com.rmbank.supervision.model.GradeScheme;
@MyBatisRepository
public interface GradeSchemeMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(GradeScheme record);

    int insertSelective(GradeScheme record);

    GradeScheme selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(GradeScheme record);

    int updateByPrimaryKey(GradeScheme record);
}