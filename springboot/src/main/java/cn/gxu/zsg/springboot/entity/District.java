package cn.gxu.zsg.springboot.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

@TableName("district")
@Data
public class District {
    private String districtId;
    private String districtName;
    private String districtAddress;
    private String communityId;
    private String communityName;
}
