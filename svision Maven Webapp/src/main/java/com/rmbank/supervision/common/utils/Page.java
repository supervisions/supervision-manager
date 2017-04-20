/**
 *
 */
package com.rmbank.supervision.common.utils;

/**
 * @author Leo
 *
 */
public class Page {
	private String searchName;
	/**
	 * 鍒嗛〉璧峰琛屾暟锛岃嚜鍔ㄨ绠�
	 */
	private Integer pageStart;
	/**
	 * 姣忛〉璁板綍鏁帮紝闇�缃�
	 */
	private Integer pageSize;
	/**
	 * 褰撳墠椤垫暟锛岄渶璁剧疆
	 */
	private Integer pageNo;
	/**
	 * 鍒嗛〉璧峰琛屾暟锛岃嚜鍔ㄨ绠�
	 */
	private Integer pageCount;
	private Integer totalCount;

	private Integer pageEnd;

	private String cTime;

	private String uTime;

	private String schBeginTime;

	private String schEndTime;

	public String getcTime() {
		return cTime;
	}

	public void setcTime(String cTime) {
		this.cTime = cTime;
	}

	public String getuTime() {
		return uTime;
	}

	public void setuTime(String uTime) {
		this.uTime = uTime;
	}

	public Integer getPageStart() {
		if (pageNo != null && pageSize != null) {
			pageStart = pageSize * (pageNo-1);
		}
		return pageStart;
	}

	public Integer getPageSize() {
		return pageSize;
	}
	public void setPageSize(Integer pageSize) {
		this.pageSize = pageSize;
	}
	public Integer getPageNo() {
		return pageNo;
	}
	public void setPageNo(Integer pageNo) {
		this.pageNo = pageNo;
	}
	public Integer getPageCount() {
		int pageCount = 0;
		if(totalCount != null){
			pageCount = totalCount%pageSize==0 ? totalCount/pageSize:totalCount/pageSize+1;
			if(pageCount == 0){
				pageCount = 1;
			}
		}else{
			pageCount = 1;
		}
		return pageCount;
	}

	public Integer getTotalCount() {
		return totalCount;
	}
	public void setTotalCount(Integer totalCount) {
		this.totalCount = totalCount;
	}

	/**
	 * @return the pageEnd
	 */
	public Integer getPageEnd() {
		if (pageStart == null) {
			return null;
		}
		if (totalCount < pageStart + pageSize) {
			pageEnd = totalCount;
		} else {
			pageEnd = pageStart + pageSize;
		}
		return pageEnd;
	}


	public String getSearchName() {
		return searchName;
	}

	public void setSearchName(String searchName) {
		this.searchName = searchName;
	}

	public String getSchBeginTime() {
		return schBeginTime;
	}

	public void setSchBeginTime(String schBeginTime) {
		this.schBeginTime = schBeginTime;
	}

	public String getSchEndTime() {
		return schEndTime;
	}

	public void setSchEndTime(String schEndTime) {
		this.schEndTime = schEndTime;
	}
}

