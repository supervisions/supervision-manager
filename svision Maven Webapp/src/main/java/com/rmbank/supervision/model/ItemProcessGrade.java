package com.rmbank.supervision.model;

public class ItemProcessGrade {
    private Integer id;

    private Integer itemProcessId;

    private Integer gradeDetailId;

    private Integer grade;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getItemProcessId() {
        return itemProcessId;
    }

    public void setItemProcessId(Integer itemProcessId) {
        this.itemProcessId = itemProcessId;
    }

    public Integer getGradeDetailId() {
        return gradeDetailId;
    }

    public void setGradeDetailId(Integer gradeDetailId) {
        this.gradeDetailId = gradeDetailId;
    }

    public Integer getGrade() {
        return grade;
    }

    public void setGrade(Integer grade) {
        this.grade = grade;
    }
}