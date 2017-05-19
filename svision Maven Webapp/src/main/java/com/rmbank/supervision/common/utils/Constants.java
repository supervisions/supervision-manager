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

  public static final Integer IO_PORT = 0;
  public static final Integer VIDEO_PORT = 1;
  public static final Integer AUDIO_PORT = 2;

  public static final Integer SERVER_DISABLE = 0;
  public static final Integer SERVER_ENABLE= 1;
  public static final Integer SERVER_NOT_CONNECTED = 2;

  public static final String SERVER_TYPE_GPU = "GPU";
  public static final String SERVER_TYPE_JANUS= "GATEWAY";
  public static final String SERVER_TYPE_GSHARE= "GSHARE";

  public static final String APP_STATUS_CLOSED="CLOSED";
  public static final String APP_STATUS_NOT_ALLOW="NOTALLOW";
  public static final String APP_STATUS_OPENED="OPENED";

  public static final Integer SERVER_INSTANCE_DELETE = 0;
  public static final Integer SERVER_INSTANCE_ENABLE = 1;
  public static final Integer SERVER_INSTANCE_WAIT = 2;
  
  public static final String META_POSITION_KEY = "POSITION";
  public static final String META_PROJECT_KEY = "PROJECT";
  public static final String META_ORGTYPE_KEY = "ORGTYPE";


  public static final Integer STATIC_MODULE_ID = 99999;

  public static final Integer STATIC_ITEM_TYPE_MANAGE = 1; 
  public static final Integer STATIC_ITEM_TYPE_SVISION = 0;
  
  //机构类型
  public static final Integer ORG_TYPE_1= 46; //分行监察室
  public static final Integer ORG_TYPE_2= 47; //分行机关
  public static final Integer ORG_TYPE_3= 48; //中支单位
  public static final Integer ORG_TYPE_4= 49; //县支行
  
  //项目进行流程
  public static final Integer CONTENT_TYPE_ID_1= 31; 
  public static final Integer CONTENT_TYPE_ID_2= 32; 
  public static final Integer CONTENT_TYPE_ID_3= 33; 
  public static final Integer CONTENT_TYPE_ID_4= 34; 
  public static final Integer CONTENT_TYPE_ID_5= 35; 
  public static final Integer CONTENT_TYPE_ID_6= 36; 
  public static final Integer CONTENT_TYPE_ID_7= 37; 
  
  public static final Integer IS_VALUE = 1;
  public static final Integer NOT_VALUE = 0;
  
}