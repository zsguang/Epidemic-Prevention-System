package cn.gxu.zsg.springboot.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import cn.gxu.zsg.springboot.entity.Orders;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface OrderMapper extends BaseMapper<Orders> {
    @Select("${sqlStr}")
    List<Orders> dynamicSql(@Param("sqlStr") String sql);
}
