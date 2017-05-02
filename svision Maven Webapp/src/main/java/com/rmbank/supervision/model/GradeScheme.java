package com.rmbank.supervision.model;

public class GradeScheme {
    private Integer id;

    private String name;

    private Integer orgId;

    private Integer inherit;

    private Integer used;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getOrgId() {
        return orgId;
    }

    public void setOrgId(Integer orgId) {
        this.orgId = orgId;
    }

    public Integer getInherit() {
        return inherit;
    }

    public void setInherit(Integer inherit) {
        this.inherit = inherit;
    }

    public Integer getUsed() {
        return used;
    }

    public void setUsed(Integer used) {
        this.used = used;
    }
}