package com.rmbank.supervision.model;

import java.util.Date;

public class Item {
    private Integer id;

    private Integer supervisionTypeId;

    private Integer pid;

    private Byte stageIndex;

    private String name;

    private Integer supervisionOrgId;

    private Integer supervisionUserId;

    private Integer preparerOrgId;

    private Integer preparerId;

    private Date preparerTime;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getSupervisionTypeId() {
        return supervisionTypeId;
    }

    public void setSupervisionTypeId(Integer supervisionTypeId) {
        this.supervisionTypeId = supervisionTypeId;
    }

    public Integer getPid() {
        return pid;
    }

    public void setPid(Integer pid) {
        this.pid = pid;
    }

    public Byte getStageIndex() {
        return stageIndex;
    }

    public void setStageIndex(Byte stageIndex) {
        this.stageIndex = stageIndex;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getSupervisionOrgId() {
        return supervisionOrgId;
    }

    public void setSupervisionOrgId(Integer supervisionOrgId) {
        this.supervisionOrgId = supervisionOrgId;
    }

    public Integer getSupervisionUserId() {
        return supervisionUserId;
    }

    public void setSupervisionUserId(Integer supervisionUserId) {
        this.supervisionUserId = supervisionUserId;
    }

    public Integer getPreparerOrgId() {
        return preparerOrgId;
    }

    public void setPreparerOrgId(Integer preparerOrgId) {
        this.preparerOrgId = preparerOrgId;
    }

    public Integer getPreparerId() {
        return preparerId;
    }

    public void setPreparerId(Integer preparerId) {
        this.preparerId = preparerId;
    }

    public Date getPreparerTime() {
        return preparerTime;
    }

    public void setPreparerTime(Date preparerTime) {
        this.preparerTime = preparerTime;
    }
}