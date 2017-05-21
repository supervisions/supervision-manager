package com.rmbank.supervision.model;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import com.rmbank.supervision.common.utils.Page;

public class Item extends Page {
    private Integer id;
    
    private Integer itemType;

    private Integer supervisionTypeId;

    private Integer pid;

    private Byte stageIndex;

    private String name;

    private Integer supervisionOrgId;

    private Integer supervisionUserId;

    private Integer preparerOrgId;

    private Integer preparerId;
    
    private Integer status;
    
    private Integer isStept;
    
    private Integer isValue;
    
    //自定义字段供sql查询使用，机构类型A
    private Integer orgTypeA;
    //自定义字段供sql查询使用，机构类型B
    private Integer orgTypeB;
    //自定义字段供sql查询使用，机构类型C
    private Integer orgTypeC;
    //自定义字段供sql查询使用，机构类型D
    private Integer orgTypeD;

	@DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date endTime;
    
    private String endTimes;
    
    //制单部门
    private String preparerOrg;
    
    /**
     * 定义字段供前台使用
     */
    private String uuid;

	public Integer getStatus() {
		return status;
	}

	public void setStatus(Integer status) {
		this.status = status;
	}

	public Integer getIsStept() {
		return isStept;
	}

	public void setIsStept(Integer isStept) {
		this.isStept = isStept;
	}

	public Date getEndTime() {
		return endTime;
	}

	public void setEndTime(Date endTime) {
		this.endTime = endTime;
	}

	@DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date preparerTime;

	

    private String preparerTimes;
    
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

	public String getUuid() {
		return uuid;
	}

	public void setUuid(String uuid) {
		this.uuid = uuid;
	}

	public String getPreparerOrg() {
		return preparerOrg;
	}

	public void setPreparerOrg(String preparerOrg) {
		this.preparerOrg = preparerOrg;
	}

	public Integer getItemType() {
		return itemType;
	}

	public void setItemType(Integer itemType) {
		this.itemType = itemType;
	}

	public Integer getOrgTypeA() {
		return orgTypeA;
	}

	public void setOrgTypeA(Integer orgTypeA) {
		this.orgTypeA = orgTypeA;
	}

	public Integer getOrgTypeB() {
		return orgTypeB;
	}

	public void setOrgTypeB(Integer orgTypeB) {
		this.orgTypeB = orgTypeB;
	}

	public Integer getOrgTypeC() {
		return orgTypeC;
	}

	public void setOrgTypeC(Integer orgTypeC) {
		this.orgTypeC = orgTypeC;
	}

	public Integer getOrgTypeD() {
		return orgTypeD;
	}

	public void setOrgTypeD(Integer orgTypeD) {
		this.orgTypeD = orgTypeD;
	}

	public String getEndTimes() {
		return endTimes;
	}

	public void setEndTimes(String endTimes) {
		this.endTimes = endTimes;
	}

	public String getPreparerTimes() {
		return preparerTimes;
	}

	public void setPreparerTimes(String preparerTimes) {
		this.preparerTimes = preparerTimes;
	}

	public Integer getIsValue() {
		return isValue;
	}

	public void setIsValue(Integer isValue) {
		this.isValue = isValue;
	}
}