package cn.gxu.zsg.springboot.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

@TableName("notice")
@Data
public class Notice {
    @TableId(type = IdType.AUTO)
    private int noticeId;
    private String noticeTitle;
    private String noticeContent;
    private String noticeTime;
    private String noticeAuthor;
    private String userPhone;

    @TableField(exist = false)
    private User user;

    public boolean isAvailable() {
        return !noticeTitle.isEmpty() && !noticeContent.isEmpty() && !noticeTime.isEmpty() && !noticeAuthor.isEmpty() && !userPhone.isEmpty();
    }
}
