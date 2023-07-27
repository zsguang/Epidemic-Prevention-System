package cn.gxu.zsg.springboot.mapper;

import cn.gxu.zsg.springboot.entity.Community;
import cn.gxu.zsg.springboot.entity.District;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface DistrictMapper extends BaseMapper<District> {

    @Select("select * from district")
    List<District> selectAllDistricts();

    @Select("${sqlStr}")
    String dynamicSql(@Param("sqlStr") String sql);

    @Select("SELECT MAX(district_id) FROM `district` WHERE community_id = '${communityId}';")
    String getMaxIdByCommunity(@Param("communityId") String communityId);

    @Select("select * from district where district_id = #{id}")
    District selectById(String id);

    @Select("select district_id from district")
    List<String> selectDistrictId();

}
