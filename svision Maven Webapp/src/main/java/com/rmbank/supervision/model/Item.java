package com.rmbank.supervision.model;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import com.rmbank.supervision.common.utils.Page;

public class Item extends Page {
    private Integer id;

    private Integer supervisionTypeId;

    private Integer pid;

    private Byte stageIndex;

    private String name;

    private Integer supervisionOrgId;

    private Integer supervisionUserId;

    private Integer preparerOrgId;

    private Integer preparerId;
    
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date preparerTime;

    
    private String orgName;
    
    private String sType;
    
    private String showDate;
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

	public String getOrgName() {
		return orgName;
	}

	public void setOrgName(String orgName) {
		this.orgName = orgName;
	}

	public String getsType() {
		return sType;
	}

	public void setsType(String sType) {
		this.sType = sType;
	}

	public String getShowDate() {
		return showDate;
	}

	public void setShowDate(String showDate) {
		this.showDate = showDate;
	}
}