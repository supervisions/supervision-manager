package com.rmbank.supervision.dao;

import com.rmbank.supervision.model.GradeSchemeDetail;
@MyBatisRepository
public interface GradeSchemeDetailMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(GradeSchemeDetail record);

    int insertSelective(GradeSchemeDetail record);

    GradeSchemeDetail selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(GradeSchemeDetail record);

    int updateByPrimaryKey(GradeSchemeDetail record);
}