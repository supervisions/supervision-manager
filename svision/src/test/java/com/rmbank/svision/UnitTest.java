package com.rmbank.svision;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.junit.Test;
import org.mybatis.generator.api.MyBatisGenerator;
import org.mybatis.generator.config.Configuration;
import org.mybatis.generator.config.xml.ConfigurationParser;
import org.mybatis.generator.exception.InvalidConfigurationException;
import org.mybatis.generator.exception.XMLParserException;
import org.mybatis.generator.internal.DefaultShellCallback;
 

public class UnitTest {
	@Test
    public  void main()  { 
		 //genCfg();
		arrayTest();
    }

    private void arrayTest() {
		// TODO Auto-generated method stub 
            ArrayList<String> arrL = new ArrayList<String>();  
            ArrayList<String> arrLTmp1 = new ArrayList<String>();  
            ArrayList<String> arrLTmp2 = new ArrayList<String>();  
            ArrayList<String> arrLTmp3 = new ArrayList<String>();  
            ArrayList<String> arrLTmp4 = new ArrayList<String>();  
            for (int i=0;i<1000000;i++){  
                arrL.add("第"+i+"个");  
            }  
            long t1 = System.nanoTime();  
            //方法1  
            Iterator<String> it = arrL.iterator();  
            while(it.hasNext()){  
                arrLTmp1.add(it.next());  
            }  
            long t2 = System.nanoTime();  
            //方法2  
            for(Iterator<String> it2 = arrL.iterator();it2.hasNext();){  
                arrLTmp2.add(it2.next());  
            }  
            long t3 = System.nanoTime();  
            //方法3  
            for (String vv :arrL){  
                arrLTmp3.add(vv);  
            }  
            long t4 = System.nanoTime();  
            //方法4  
            for(int i=0;i<arrL.size();i++){  
                arrLTmp4.add(arrL.get(i));  
            }  
            long t5 = System.nanoTime();  
            System.out.println("第一种方法耗时：" + (t2-t1)/1000000 + "微秒");  
            System.out.println("第二种方法耗时：" + (t3-t2)/1000000 + "微秒");  
            System.out.println("第三种方法耗时：" + (t4-t3)/1000000 + "微秒");  
            System.out.println("第四种方法耗时：" + (t5-t4)/1000000 + "微秒");  
               
	}

	public void genCfg(){
        List<String> warnings = new ArrayList<String>();
        boolean overwrite = true;
        String genCfg = "src/main/resources/mybatis/generatorConfig.xml";
        File configFile = new File(genCfg);
        ConfigurationParser cp = new ConfigurationParser(warnings);
        Configuration config = null;
        try {
            config = cp.parseConfiguration(configFile);
        } catch (IOException e) {
            e.printStackTrace();
        } catch (XMLParserException e) {
            e.printStackTrace();
        }
        DefaultShellCallback callback = new DefaultShellCallback(overwrite);
        MyBatisGenerator myBatisGenerator = null;
        try {
            myBatisGenerator = new MyBatisGenerator(config, callback, warnings);
        } catch (InvalidConfigurationException e) {
            e.printStackTrace();
        }
        try {
            myBatisGenerator.generate(null);
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}
