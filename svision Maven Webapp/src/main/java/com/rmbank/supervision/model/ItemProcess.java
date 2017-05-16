package com.rmbank.supervision.model;

import java.util.Date;

public class ItemProcess {
    private Integer id;
    
    private String uuid;

    private Integer itemId;

    private Boolean defined;

    private Integer contentTypeId;

    private Integer orgId;

    private String last;

    private String content;

    private Integer preparerOrgId;

    private Integer preparerId;

    private Date preparerTime;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getItemId() {
        return itemId;
    }

    public void setItemId(Integer itemId) {
        this.itemId = itemId;
    }

    public Boolean getDefined() {
        return defined;
    }

    public void setDefined(Boolean defined) {
        this.defined = defined;
    }

    public Integer getContentTypeId() {
        return contentTypeId;
    }

    public void setContentTypeId(Integer contentTypeId) {
        this.contentTypeId = contentTypeId;
    }

    public Integer getOrgId() {
        return orgId;
    }

    public void setOrgId(Integer orgId) {
        this.orgId = orgId;
    }

    public String getLast() {
        return last;
    }

    public void setLast(String last) {
        this.last = last;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
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

	public String getUuid() {
		return uuid;
	}

	public void setUuid(String uuid) {
		this.uuid = uuid;
	}
}