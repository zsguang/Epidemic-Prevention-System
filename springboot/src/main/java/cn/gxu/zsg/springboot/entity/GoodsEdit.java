package cn.gxu.zsg.springboot.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

@TableName("goods_edit")
@Data
public class GoodsEdit {
    @TableId(type = IdType.AUTO)
    private int editId;
    private int editGoods;
    private String editManager;
    private String editType;
    private String editTime;
    private String preData;
    private String newData;

}
