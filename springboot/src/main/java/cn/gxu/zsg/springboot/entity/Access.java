package cn.gxu.zsg.springboot.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

@TableName("access")
@Data
public class Access {
    @TableId(type = IdType.AUTO)
    private int id;
    private String accessTime;
    private String userPhone;
    private String districtId;
    private String outProvince;

    @TableField(exist = false)
    private User user;
    @TableField(exist = false)
    private District district;

    public boolean isAvailable() {
        return !accessTime.isEmpty() && !userPhone.isEmpty() && !districtId.isEmpty() && !outProvince.isEmpty();
    }

    private boolean isEmpty(String s) {
        return s == null || s.equals("");
    }

}
