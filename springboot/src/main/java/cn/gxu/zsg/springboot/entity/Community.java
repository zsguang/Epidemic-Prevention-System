package cn.gxu.zsg.springboot.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

@TableName("community")
@Data
public class Community {
    private String communityId;
    private String communityName;
    private String communityAddress;
}
