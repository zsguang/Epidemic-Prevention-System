package cn.gxu.zsg.springboot.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

@TableName("goods")
@Data
public class Goods {
    private int goodsId;
    private String goodName;
    private String goodsImage;
    private float goodsPrice;
    private int goodsNumber;
    private String goodsState;

}
