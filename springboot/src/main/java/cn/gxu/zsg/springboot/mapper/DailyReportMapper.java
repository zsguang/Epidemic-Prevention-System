package cn.gxu.zsg.springboot.mapper;

import cn.gxu.zsg.springboot.entity.Community;
import cn.gxu.zsg.springboot.entity.DailyReport;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.*;
import org.apache.ibatis.mapping.FetchType;

import java.util.List;

@Mapper
public interface DailyReportMapper extends BaseMapper<DailyReport> {

    @Results({
            @Result(column = "user_phone", property = "userPhone"),
            @Result(column = "user_phone", property = "user",
                    one = @One(select = "cn.gxu.zsg.springboot.mapper.UserMapper.selectById")
            ),
    })
    @Select("${sql}")
    List<DailyReport> selectAllCommunities(String sql);

    @Select("${sqlStr}")
    String dynamicSql(@Param("sqlStr") String sql);
}
