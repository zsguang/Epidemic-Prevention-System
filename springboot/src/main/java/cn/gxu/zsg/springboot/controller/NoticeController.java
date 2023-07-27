package cn.gxu.zsg.springboot.controller;

import cn.gxu.zsg.springboot.common.Result;
import cn.gxu.zsg.springboot.entity.Notice;
import cn.gxu.zsg.springboot.mapper.NoticeMapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;

@RestController
@RequestMapping("/notice")
public class NoticeController {
    static Logger logger = LoggerFactory.getLogger(NoticeController.class);

    @Resource
    NoticeMapper noticeMapper;

    @GetMapping("/all")
    public Result<?> getAllNotice(
            @RequestParam(defaultValue = "") String time,
            @RequestParam(defaultValue = "") String title,
            @RequestParam(defaultValue = "") String author,
            @RequestParam(defaultValue = "") String user
    ) {
        System.out.printf("getAllNotice: time=%s  title=%s  author=%s  user=%s  \n", time, title, author, user);

        List<Notice> noticeList = noticeMapper.getAllNotice();
        logger.info("getAllNotice  size=" + noticeList.size());
        return Result.success(noticeList);
    }

    @PostMapping
    public Result<?> save(@RequestBody Notice notice) {
        if (!notice.isAvailable()) return Result.error("-1", "数据错误");
        int insert = noticeMapper.insert(notice);
        if (insert == 1) {
            logger.info("Success insert " + notice);
            return Result.success();
        } else {
            logger.warn("Failure insert " + notice);
            return Result.error("-1", "失败");
        }
    }

    @PutMapping
    public Result<?> update(@RequestBody Notice notice) {
        System.out.println("Update: " + notice);
        int update = noticeMapper.update(notice, Wrappers.<Notice>lambdaQuery().eq(Notice::getNoticeId, notice.getNoticeId()));
        if (update == 1) {
            return Result.success();
        } else {
            return Result.error("-1", "修改失败");
        }
    }

    @PutMapping("/delete")
    public Result<?> delete(@RequestBody List<Notice> noticeList) {
        if (noticeList.isEmpty()) return Result.error("-1", "数据不存在");
        logger.info("Notice delete size=" + noticeList.size());

        int delete = noticeMapper.deleteBatchIds(noticeList);
        if (delete == noticeList.size()) {
            return Result.success();
        } else {
            return Result.error("-1", "数据不存在");
        }
    }

    @GetMapping("/latest")
    public Result<?> getAllNotice() {
        Notice notice = noticeMapper.selectOne(Wrappers.<Notice>lambdaQuery().orderByDesc(Notice::getNoticeId).last("limit 1"));
//        logger.info("latest Notice: "+notice.toString());
        return Result.success(notice);
    }
}
