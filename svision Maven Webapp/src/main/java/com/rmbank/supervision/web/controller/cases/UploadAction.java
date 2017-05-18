package com.rmbank.supervision.web.controller.cases;

import java.io.File;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FilenameUtils;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import com.rmbank.supervision.model.ItemProcessFile;
import com.rmbank.supervision.model.Organ;
import com.rmbank.supervision.model.User;
import com.rmbank.supervision.common.JsonResult;
import com.rmbank.supervision.common.utils.Constants;
import com.rmbank.supervision.service.ItemProcessFileService;
import com.rmbank.supervision.service.ItemProcessService;
import com.rmbank.supervision.service.UserService;
import com.rmbank.supervision.web.controller.SystemAction;

@Controller
@Scope("prototype")
@RequestMapping("/system/upload")
public class UploadAction extends SystemAction {
	
	@Resource
	private  ItemProcessService itemProcessService;
	@Resource
	private UserService userService;
	@Resource
	private ItemProcessFileService itemProcessFileService;
	
	
	@ResponseBody
    @RequestMapping(value = "/jsonUploadFile.do", method = RequestMethod.POST,produces={ "text/html;charset=UTF-8"} )
    public JsonResult<File> jsonSaveOrUpdateVideoItem(
            @RequestParam(value = "uuid", required = true) String uuid,
            @RequestParam(value = "file", required = true) CommonsMultipartFile file,
            HttpServletRequest request,HttpServletResponse response,HttpSession session) {
		//获取文件上传的路径
		String path = session.getServletContext().getRealPath("/source/uploadfile/"+uuid);
		System.out.println(path);
		//获得原始文件名称
		String fileName = file.getOriginalFilename();
		//获取文件的扩展名
		String extName = FilenameUtils.getExtension(fileName);
		File uploadpath =new File(path);    
		//判断文件夹是否存在，如果文件夹不存在则创建    
		if(!uploadpath.exists()  && !uploadpath.isDirectory()){	       
		    System.out.println("目录不存在");  
		    uploadpath.mkdir();    
		}else{    
		    System.out.println("目录存在");  
		}  
        JsonResult<File> js = new JsonResult<File>();
        js.setCode(Constants.RESULT_FAILED);
        js.setMessage("上传文件失败!");
        
        try {
        	if(uuid == null || file == null){
                return js;
            }
        	String absPath = path + "/" + fileName;
        	File targetFile = new File(absPath);
        	file.transferTo(targetFile);
        	
        	//获取当前用户
        	User loginUser = this.getLoginUser();
        	List<Integer> ipid=itemProcessService.getItemProcessIdByUuid(uuid);
        	//制单机构
        	List<Integer> orgIds = userService.getUserOrgIdsByUserId(loginUser.getId());
        	
        	ItemProcessFile ipf=new ItemProcessFile();
        	ipf.setFileName(fileName);
        	ipf.setFilePath(path);
        	ipf.setFileExt(extName);
        	ipf.setPreparerId(loginUser.getId());
        	Date date = new Date();
        	ipf.setPreparerTime(new Date());
        	ipf.setPreparerOrgId(orgIds.get(0));        	
        	boolean state = itemProcessFileService.insertSelective(ipf,ipid);
        	if(state){
        		js.setCode(Constants.RESULT_SUCCESS);
                js.setMessage("上传文件成功!");
        	}
		} catch (Exception e) {
			e.printStackTrace();
		}
        
       /* try {
            if(uuid == null){
                return js;
            }
            
            if(video == null){
                return js;
            }
            User user = this.getLoginUser();
            try {
                String path = video.getUrl();
                for(CommonsMultipartFile cFile: file){
                    UploadVideoItem videoItem = new UploadVideoItem();
                    videoItem.setDownloadTimes(0);
                    videoItem.setFlag(1);
                    videoItem.setId(0);
                    videoItem.setIsDelete(1);
                    videoItem.setUploadTime(new Date());
                    videoItem.setVideoId(video.getId());
                    String tempName = cFile.getOriginalFilename().replaceAll(" ","");    //这里不用原文件名称

                    String absPath = path + "/" + tempName;
                    File targetFile = new File(absPath);
                    cFile.transferTo(targetFile);
                    videoItem.setUrl(absPath);
                    videoItem.setSize(cFile.getSize()+"");
                    videoItem.setItemName(tempName);
                    videoService.saveOrUpdateVideoItem(videoItem);
                }
                js.setCode(Constants.RESULT_SUCCESS);
                js.setMessage("上传视频文件成功!");
            }
            catch (Exception ex){
                js.setMessage(ex.getMessage());
            }
        }
        catch (Exception e){
            js.setMessage(e.getMessage());
        }*/
        return js;
    }
}
