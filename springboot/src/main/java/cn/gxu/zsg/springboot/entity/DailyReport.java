package cn.gxu.zsg.springboot.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

@TableName("daily_report")
@Data
public class DailyReport {
    @TableId(type = IdType.AUTO)
    private int id;
    private String reportTime;
    private float temperature;
    private String coughed;     // 咳嗽
    private String diarrheaed;  // 腹泻
    private String weaked;      // 乏力
    private String userPhone;

    @TableField(exist = false)
    private User user;

    public boolean isAvailable() {
        return !reportTime.isEmpty() && !diarrheaed.isEmpty() && !coughed.isEmpty() && !weaked.isEmpty() && !userPhone.isEmpty();
    }

    public boolean isSuspect() {
        return temperature >= 38 && (coughed.equals("1") || weaked.equals("1") || diarrheaed.equals("1"));
    }
}
