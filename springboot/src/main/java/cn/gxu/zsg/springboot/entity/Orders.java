package cn.gxu.zsg.springboot.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

@TableName("orders")
@Data
public class Orders {
    @TableId(type = IdType.AUTO)
    private int orderId;
    private int orderGoods;
    private String orderUser;
    private int orderNumber;
    private float orderPrice;
    private String orderTime;

}
