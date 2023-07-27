package cn.gxu.zsg.springboot;

import cn.gxu.zsg.springboot.controller.AccessController;
import cn.gxu.zsg.springboot.entity.Access;
import cn.gxu.zsg.springboot.entity.District;
import cn.gxu.zsg.springboot.mapper.AccessMapper;
import cn.gxu.zsg.springboot.mapper.CommunityMapper;
import cn.gxu.zsg.springboot.mapper.DistrictMapper;
import cn.gxu.zsg.springboot.mapper.UserMapper;
import com.apifan.common.random.RandomSource;
import org.apache.commons.lang3.RandomUtils;
import org.junit.Before;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Random;

public class AccessText extends BaseSpringBootTest {

    private MockMvc mockMvc;

    @Autowired
    private AccessController accessController;

    @Autowired
    private AccessMapper accessMapper;

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private CommunityMapper communityMapper;

    @Autowired
    private DistrictMapper districtMapper;

    @Before
    public void setup() {
        mockMvc = MockMvcBuilders.standaloneSetup(accessController).build();
    }

    @Test
    public void insertAccess() {
        List<String> userList = userMapper.selectUserPhone();
        List<String> districtList = districtMapper.selectDistrictId();

        Random random = new Random();
        LocalDate beginDate = LocalDate.of(2023, 1, 1);
        LocalDate endDate = LocalDate.of(2023, 4, 16);
        for (int i = 0; i < 10000; i++) {
            int userIndex = random.nextInt(userList.size());
            int districtIndex = random.nextInt(districtList.size());

            String date = RandomSource.dateTimeSource().randomDate(beginDate, endDate, "yyyy-MM-dd");
            int hour = RandomUtils.nextInt(0, 24);
            int minute = RandomUtils.nextInt(0, 60);
            int second = RandomUtils.nextInt(0, 60);
            String time = date + (hour < 10 ? " 0" : " ") + hour + (minute < 10 ? ":0" : ":")  + minute + (second < 10 ? ":0" : ":") + second;

            Access access = new Access();
            access.setAccessTime(time);
            access.setUserPhone(userList.get(userIndex));
            access.setDistrictId(districtList.get(districtIndex));
            access.setOutProvince("0");

//            System.out.println(access);
            accessMapper.insert(access);
        }
    }

    public static void main(String[] args) {
//        LocalDateTime begin = LocalDateTime.of(2020, 1, 6, 12, 0, 0);
//        LocalDateTime end = LocalDateTime.of(2020, 3, 6, 12, 30, 0);
//        long ts3 = RandomSource.dateTimeSource().randomTimestamp(begin, end);
//        System.out.println(ts3);
//
//        Date date = new Date(ts3);
//        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
//        String formattedDate = sdf.format(date);
//        System.out.println(formattedDate);
    }
}
