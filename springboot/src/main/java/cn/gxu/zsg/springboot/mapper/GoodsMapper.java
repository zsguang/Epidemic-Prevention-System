package cn.gxu.zsg.springboot.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import cn.gxu.zsg.springboot.entity.Goods;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface GoodsMapper extends BaseMapper<Goods> {
    @Select("${sqlStr}")
    List<Goods> dynamicSql(@Param("sqlStr") String sql);

    @Select("${sqlStr}")
    List<String> dynamicSqlForString(@Param("sqlStr") String sql);


}
