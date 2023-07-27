package cn.gxu.zsg.springboot.mapper;

import cn.gxu.zsg.springboot.entity.Community;
import cn.gxu.zsg.springboot.entity.User;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface CommunityMapper extends BaseMapper<Community> {
    @Select("select * from community")
    List<Community> selectAllCommunities();

    @Select("${sqlStr}")
    String dynamicSql(@Param("sqlStr") String sql);
}
