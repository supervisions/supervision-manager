package com.rmbank.supervision.model;

import java.util.List;

public class FunctionMenu {
    private Integer id;
    
    private String name;

    private Integer parentId;

    private Integer leaf;

    private String url;

    private Integer sort;

    private Integer used;


    private int selected;

    private List<FunctionMenu> childMenulist; 
    
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getParentId() {
        return parentId;
    }

    public void setParentId(Integer parentId) {
        this.parentId = parentId;
    }

    public Integer getLeaf() {
        return leaf;
    }

    public void setLeaf(Integer leaf) {
        this.leaf = leaf;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public Integer getSort() {
        return sort;
    }

    public void setSort(Integer sort) {
        this.sort = sort;
    }

    public Integer getUsed() {
        return used;
    }

    public void setUsed(Integer used) {
        this.used = used;
    }

	public List<FunctionMenu> getChildMenulist() {
		return childMenulist;
	}

	public void setChildMenulist(List<FunctionMenu> childMenulist) {
		this.childMenulist = childMenulist;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
}