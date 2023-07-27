package cn.gxu.zsg.springboot;

import cn.gxu.zsg.springboot.RandomData.RandomCommunity;
import cn.gxu.zsg.springboot.RandomData.RandomUser;
import cn.gxu.zsg.springboot.controller.UserController;
import cn.gxu.zsg.springboot.entity.Community;
import cn.gxu.zsg.springboot.entity.District;
import cn.gxu.zsg.springboot.entity.User;
import cn.gxu.zsg.springboot.mapper.CommunityMapper;
import cn.gxu.zsg.springboot.mapper.DistrictMapper;
import cn.gxu.zsg.springboot.mapper.UserMapper;
import com.fasterxml.jackson.core.JsonEncoding;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.Before;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.ResultMatcher;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultHandlers;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import java.util.List;
import java.util.Locale;
import java.util.Random;

import static org.springframework.test.web.client.match.MockRestRequestMatchers.content;


public class UserTests extends BaseSpringBootTest {

    private MockMvc mockMvc;

    @Autowired
    private UserController userController;

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private CommunityMapper communityMapper;

    @Autowired
    private DistrictMapper districtMapper;

    @Before
    public void setup() {
        mockMvc = MockMvcBuilders.standaloneSetup(userController).build();
    }

    @Test
    public void Text() throws Exception {
        MvcResult mvcResult = mockMvc.perform(MockMvcRequestBuilders.post("/district"))
//                        .param("userPhone", "12345678901"))
                .andExpect(MockMvcResultMatchers.status().isOk())
                .andDo(MockMvcResultHandlers.print())
                .andReturn();

        logger.info(mvcResult.getResponse().getContentAsString());
    }

    @Test
    public void selectPass() throws Exception {
        MvcResult mvcResult = mockMvc.perform(MockMvcRequestBuilders.get("/user/userPass")
                        .param("userPhone", "12345678901"))
                .andExpect(MockMvcResultMatchers.status().isOk())
                .andDo(MockMvcResultHandlers.print())
                .andReturn();

        logger.info(mvcResult.getResponse().getContentAsString());
    }

    @Test
    public void selectOne() throws Exception {
        User user = new User();
        user.setUserPhone("13003673571");
        user.setPassword("13003673571");
        ObjectMapper mapper = new ObjectMapper();
        String json = mapper.writeValueAsString(user);
        MvcResult mvcResult = mockMvc.perform(MockMvcRequestBuilders.post("/user/userInfo")
                        .contentType(MediaType.APPLICATION_JSON_UTF8)
                        .content(json))
                .andExpect(MockMvcResultMatchers.status().isOk())
//                .andDo(MockMvcResultHandlers.print())
                .andReturn();

        logger.info(mvcResult.getResponse().getContentAsString());
        System.out.println("\n------" + mvcResult.getResponse().getContentAsString() + "\n");
    }

    @Test
    public void insertUser() {
//        List<Community> communities = communityMapper.selectAllCommunities();
        List<District> districts = districtMapper.selectAllDistricts();

        Random random = new Random();

        for (int i = 0; i < 10000; i++) {
            User user = RandomUser.getRandomUser();
            // 调用数据库需要先查询小区区地址和具体地址，再生成数据
            int index = random.nextInt(districts.size());
            user.setDistrictId(districts.get(index).getDistrictId());
            user.setUserAddress(RandomCommunity.getRandomAddress(districts, index));
            try {
                userMapper.insert(user);
//                 System.out.println(user);
            } catch (Exception e) {
                i--;
            }
        }
    }

    @Test
    public void deleteAllUser() {
        userMapper.deleteAllUser();
    }
}
