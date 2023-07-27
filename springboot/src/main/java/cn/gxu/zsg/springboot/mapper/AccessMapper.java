package cn.gxu.zsg.springboot.mapper;

import cn.gxu.zsg.springboot.entity.Access;
import cn.gxu.zsg.springboot.entity.Community;
import cn.gxu.zsg.springboot.entity.User;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.*;
import org.springframework.stereotype.Repository;

import java.util.List;

@Mapper
@Repository
public interface AccessMapper extends BaseMapper<Access> {
    @Results({
            @Result(column = "district_id", property = "districtId"),
            @Result(column = "district_id", property = "district",
                    one = @One(select = "cn.gxu.zsg.springboot.mapper.DistrictMapper.selectById")
            ),
            @Result(column = "user_phone", property = "userPhone"),
            @Result(column = "user_phone", property = "user",
                    one = @One(select = "cn.gxu.zsg.springboot.mapper.UserMapper.selectById")
            ),
    })
//    @Select("select * from access,user ${sqlCondition}")
    @Select("${sql}")
    List<Access> selectAllAccesses(String sql);

    @Select("${sqlStr}")
    String dynamicSql(@Param("sqlStr") String sql);

    @Results({
            @Result(column = "district_id", property = "districtId"),
            @Result(column = "district_id", property = "district",
                    one = @One(select = "cn.gxu.zsg.springboot.mapper.DistrictMapper.selectById")
            ),
            @Result(column = "user_phone", property = "userPhone"),
            @Result(column = "user_phone", property = "user",
                    one = @One(select = "cn.gxu.zsg.springboot.mapper.UserMapper.selectById")
            ),
    })
    @Select("select * from access where access.id = #{id}")
    Access getAccessById(String id);


    @Results({
            @Result(column = "district_id", property = "districtId"),
            @Result(column = "district_id", property = "district",
                    one = @One(select = "cn.gxu.zsg.springboot.mapper.DistrictMapper.selectById")
            ),
            @Result(column = "user_phone", property = "userPhone"),
            @Result(column = "user_phone", property = "user",
                    one = @One(select = "cn.gxu.zsg.springboot.mapper.UserMapper.selectById")
            ),
    })
    @Select("select * from access,user,district " +
            "where access.user_phone='${phone}' " +
            "and access.user_phone=user.user_phone " +
            "and access.district_id=district.district_id " +
            "order by id DESC")
    List<Access> getAccessByPhone(@Param("phone") String phone);


    @Results({
            @Result(column = "user_phone", property = "userPhone"),
            @Result(column = "user_phone", property = "user",
                    one = @One(select = "cn.gxu.zsg.springboot.mapper.UserMapper.selectById")
            ),
    })
    @Select("SELECT access.* FROM access,user " +
            "WHERE access.user_phone = user.user_phone " +
            "AND access.district_id IN (" +
            "SELECT access.district_id FROM access WHERE access.user_phone = #{phone} AND access_time BETWEEN #{time1} and #{time2} " +
            "GROUP BY access.district_id) " +
            "AND access_time BETWEEN #{time1} and #{time2} " +
//            "GROUP BY access.user_phone;")
            "")
    List<Access> getBt15ByPhone(String time1, String time2, String phone);
}
