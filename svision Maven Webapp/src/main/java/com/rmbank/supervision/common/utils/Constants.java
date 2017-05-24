package com.rmbank.supervision.common.utils;

import org.omg.CORBA.PUBLIC_MEMBER;

import java.net.PortUnreachableException;
import java.text.SimpleDateFormat;
import java.util.Iterator;

public class Constants
{
  public static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
  public static final String USER_ADMIN_ACCOUNT = "admin";
  public static final String USER_SUPER_ADMIN_ACCOUNT = "administrator";
  public static final String USER_SESSION_RESOURCE = "userResources";
  public static final String USER_INFO = "userInfo";
  public static final String THE_REALM_NAME = "userRealm";



  public static final String DEFAULT_USER_PASSWORD = "123456";
  public static final int DEFAULT_PAGE_SIZE = 10;



  public static final Integer RESULT_SUCCESS = 200;
  public static final String RESULT_SUCCESS_MESSAGE = "load data success";
  public static final Integer RESULT_FAILED = 201;
  public static final String RESULT_FAILED_MESSAGE = "load data failed";
  public static final Integer RESULT_ERROR = 202;
  public static final String RESULT_ERROR_MESSAGE = "load data error";
  public static final Integer RESULT_EXCEPTION = 203;
  public static final String RESULT_EXCEPTION_MESSAGE = "load data exception";
  public static final Integer RESULT_PARAMS = 204;
  public static final String RESULT_PARAMS_MESSAGE = "param is not invalid";

  public static final Integer USER_TYPE_CUSTOMER = 0;
  public static final Integer USER_TYPE_ADMIN = 1;
  public static final Integer USER_TYPE_SUPERADMIN = 1;

  public static final Integer USER_STATUS_LOCKED = 0;
  public static final Integer USER_STATUS_EFFICTIVE = 1;  


  public static final Integer FLAG_LOCKED = 0;
  public static final Integer FLAG_UNLOCK = 1;
  public static final Integer STATUS_LOCKED = 0;
  public static final Integer STATUS_EFFICTIVE = 1;

  public static final Integer USER_NOT_DELETE = 0;
  public static final Integer USER_DELETED = 1;

  public static final Integer ROLE_TYPE_CUSTOMER = 0;
  public static final Integer ROLE_TYPE_ADMIN = 1; 
  
  public static final String ITEM_TYPE_FH_NAME = "分行"; 
  public static final String ITEM_TYPE_ZZ_NAME = "中支";
  
  
  public static final String META_POSITION_KEY = "POSITION";
  public static final String META_PROJECT_KEY = "PROJECT";
  public static final String META_ORGTYPE_KEY = "ORGTYPE";
  public static final String META_ITEMCATEGORY_KEY = "ITEMCATEGORY";
  public static final String META_LAWTYPE_KEY = "LAWTYPE";


  public static final Integer STATIC_MODULE_ID = 99999;

  //项目类型，综合管理or实时监察
  public static final Integer STATIC_ITEM_TYPE_MANAGE = 1; 
  public static final Integer STATIC_ITEM_TYPE_SVISION = 0;
  
  //机构类型
  public static final Integer ORG_TYPE_1= 46; //分行监察室
  public static final Integer ORG_TYPE_2= 47; //分行机关
  public static final Integer ORG_TYPE_3= 48; //中支单位
  public static final Integer ORG_TYPE_4= 49; //县支行
  
  //分行立项，分行完成项目进行流程
  public static final Integer CONTENT_TYPE_ID_1= 31; 
  public static final Integer CONTENT_TYPE_ID_2= 32; 
  public static final Integer CONTENT_TYPE_ID_3= 33; 
  public static final Integer CONTENT_TYPE_ID_4= 34; 
  public static final Integer CONTENT_TYPE_ID_5= 35;  
  
  
  public static final Integer SUPERVISION_TYPE_ID_XL = 2;
  public static final Integer SUPERVISION_TYPE_ID_LZ = 3;  
  public static final Integer SUPERVISION_TYPE_ID_ZF = 4;
  

  //分行立项，中支完成项目进行流程
  public static final Integer CONTENT_TYPE_ID_FHZZ= 54;  

  //中支立项，中支完成项目进行流程
  public static final Integer CONTENT_TYPE_ID_ZZZZ= 51; 
  public static final Integer CONTENT_TYPE_ID_ZZZZ_OVER= 52;  
  
  public static final Integer IS_VALUE = 1;
  public static final Integer NOT_VALUE = 0;

  public static final Integer IS_OVER = 1;
  public static final Integer NOT_OVER = 0;
  
  
  public static final Integer ITEM_STATUS_NEW =0; 
  public static final Integer ITEM_STATUS_NORMAL =1; 
  public static final Integer ITEM_STATUS_REBACK =2; 
  public static final Integer ITEM_STATUS_OVERLINE =3;
  public static final Integer ITEM_STATUS_OVER =4;
  
  
  //效能监察流程
  public static final Integer EFFICIENCY_VISION_0=-1; //新增项目时的初始状态
  public static final Integer EFFICIENCY_VISION_1=66; //签收
  public static final Integer EFFICIENCY_VISION_2=67; //上传资料
  public static final Integer EFFICIENCY_VISION_3=68; //整改建议和整改建议
  public static final Integer EFFICIENCY_VISION_4=69; //录入整改情况
  public static final Integer EFFICIENCY_VISION_666=666; //整改建议
  public static final Integer EFFICIENCY_VISION_5=70; //跟踪监察
  public static final Integer EFFICIENCY_VISION_6=71; //效能监察流程完成
  
  
  //廉政监察流程
  public static final Integer INCORRUPT_VISION_0=-1; //新增项目时的初始状态
  public static final Integer INCORRUPT_VISION_1=72; //被监察对象录入项目方案
  public static final Integer INCORRUPT_VISION_2=73; //被监察对象录入决策内容
  public static final Integer INCORRUPT_VISION_3=74; //监察室提出监察意见
  
  public static final Integer INCORRUPT_VISION_33=777; //录入会议决策后给出监察意见
  public static final Integer INCORRUPT_VISION_4=75; //被监察对象录入执行情况
  public static final Integer INCORRUPT_VISION_5=76; //监察室监察执行情况
  public static final Integer INCORRUPT_VISION_6=77; //被监察对象提请重新决策
  public static final Integer INCORRUPT_VISION_7=78; //监察室给出监察结论 													
  public static final Integer INCORRUPT_VISION_8=84; //廉政监察完成
  													 
}
