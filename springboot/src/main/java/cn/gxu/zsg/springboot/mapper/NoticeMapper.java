package cn.gxu.zsg.springboot.mapper;

import cn.gxu.zsg.springboot.entity.Access;
import cn.gxu.zsg.springboot.entity.Notice;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.*;
import org.springframework.stereotype.Repository;

import java.util.List;

@Mapper
@Repository
public interface NoticeMapper extends BaseMapper<Notice> {

    @Results({
            @Result(column = "user_phone", property = "userPhone"),
            @Result(column = "user_phone", property = "user",
                    one = @One(select = "cn.gxu.zsg.springboot.mapper.UserMapper.selectById")
            )
    })
    @Select("select * from notice,user where notice.user_phone = user.user_phone order by notice_id DESC")
    List<Notice> getAllNotice();
}
