package cn.gxu.zsg.springboot.controller;

import cn.gxu.zsg.springboot.common.BaseConfig;
import cn.gxu.zsg.springboot.common.Result;
import cn.hutool.core.io.FileUtil;
import cn.hutool.core.util.IdUtil;
import cn.hutool.core.util.StrUtil;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.List;

@RestController
@RequestMapping("/images")
public class ImageController {

    @Value("${server.port}")
    private String port;

    private final String imageFile = "/springboot/src/main/resources/static/images/";

    /**
     * 上传接口
     *
     * @param file 图片文件
     * @return 文件的唯一标识符
     */
    @PostMapping("/upload")
    public Result<?> upload(MultipartFile file) {
        String filename = file.getOriginalFilename();   //获取源文件名称
        String flag = IdUtil.fastSimpleUUID();   //定义文件的唯一标识符(前缀)
        String rootFilePath = System.getProperty("user.dir") + imageFile + flag + "_" + filename;   //获取文件路径
        try {
            FileUtil.writeBytes(file.getBytes(), rootFilePath);
        } catch (IOException e) {
            e.printStackTrace();
        }
//        return Result.success(BaseConfig.baseIP + ":" + port + "/images/" + flag);
        return Result.success("/images/"+flag);
    }

    /**
     * 下载接口
     *
     * @param flag 文件的唯一标识符(前缀)
     * @param response
     */
    @GetMapping("/{flag}")
    public void getFiles(@PathVariable String flag, HttpServletResponse response) {
        OutputStream os;    //新建一个输出流
        String basePath = System.getProperty("user.dir") + imageFile;    //文件上传根路径
        List<String> fileNames = FileUtil.listFileNames(basePath);   //获取所有的文件名称
        String fileName = fileNames.stream().filter(name -> name.contains(flag)).findAny().orElse("");  //找到跟参数一致的文件
        try {
            if (StrUtil.isNotEmpty(fileName)) {
                response.addHeader("Content-Disposition", "attachment;filenames" + URLEncoder.encode(fileName, "UTF-8"));
                response.setContentType("application/octet-stream");
                byte[] bytes = FileUtil.readBytes(basePath + fileName); //通过文件的路径读取文件字节流
                os = response.getOutputStream();    //通过输出流返回文件
                os.write(bytes);
                os.flush();
                os.close();
            }
        } catch (Exception e) {
//            e.printStackTrace();
            System.out.println("文件下载失败");
        }
    }
}
