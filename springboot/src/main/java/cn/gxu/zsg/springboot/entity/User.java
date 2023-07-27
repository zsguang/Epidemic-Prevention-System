package cn.gxu.zsg.springboot.entity;

import com.baomidou.mybatisplus.annotation.*;
import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Data;


/**
 * 用户信息实体类
 */
@TableName("user")
@Data
public class User {
    private String userPhone;
    private String userIdcard;
    private String userName;
    private String password;
    private String userGender;
    private String districtId;
    private String userAddress;
    private String userBirthday;
    private String manager;
    private String health;
    private String avatar;

    @TableField(exist = false)
    private District district;


}
