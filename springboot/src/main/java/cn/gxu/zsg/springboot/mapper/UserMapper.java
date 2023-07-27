package cn.gxu.zsg.springboot.mapper;

import cn.gxu.zsg.springboot.entity.District;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import cn.gxu.zsg.springboot.entity.User;
import org.apache.ibatis.annotations.*;
import org.apache.ibatis.mapping.FetchType;

import java.util.List;

@Mapper
public interface UserMapper extends BaseMapper<User> {

    @Select("select user_phone from user ")
    List<String> selectUserPhone();

    @Select("delete from user")
    int deleteAllUser();

    @Select("${sqlStr}")
    String dynamicSql(@Param("sqlStr") String sql);


    @Select("select * from `user` where user_phone = #{id}")
    User selectById(String id);


    @Results({
            @Result(column = "district_id", property = "districtId"),
            @Result(column = "district_id", property = "district",
                    one = @One(select = "com.example.mapper.DistrictMapper.selectById")
            )
    })
    @Select("select * from `user` where user_phone = '${phone}'")
    User selectUserWithDistrict(@Param("phone") String phone);


//    @Results(id = "userWithDistrictMap", value = {
//            @Result(property = "userPhone", column = "user_phone"),
//            @Result(property = "district", column = "district_id",
//                    one = @One(select = "com.example.mapper.DistrictMapper.selectById"))
//    })
//    @Select("<script>" +
//            "SELECT * FROM user " +
//            "WHERE 1 = 1 " +
//            "<if test='userPhone != null'>AND user_phone LIKE CONCAT('%', #{userPhone}, '%')</if> " +
//            "<if test='userName != null'>AND user_name LIKE CONCAT('%', #{userName}, '%')</if> " +
//            "<if test='userIdCard != null'>AND user_idcard LIKE CONCAT('%', #{userIdCard}, '%')</if> " +
//            "<if test='userCommunity != null'>AND user_address LIKE CONCAT('%', #{userCommunity}, '%')</if> " +
//            "<if test='healthValues != null and !healthValues.isEmpty()'>AND health IN " +
//            "<foreach item='item' index='index' collection='healthValues' open='(' separator=',' close=')'>#{item}</foreach>" +
//            "</if> " +
//            "<if test='managerValues != null and !managerValues.isEmpty()'>AND manager IN " +
//            "<foreach item='item' index='index' collection='managerValues' open='(' separator=',' close=')'>#{item}</foreach>" +
//            "</if> " +
//            "</script>"
//    )
//    List<User> selectUserWithDistrict(
//            @Param("userPhone") String userPhone,
//            @Param("userName") String userName,
//            @Param("userIdCard") String userIdCard,
//            @Param("districtId") String districtId,
//            @Param("healthValues") List<String> healthValues,
//            @Param("managerValues") List<String> managerValues
//    );
}

