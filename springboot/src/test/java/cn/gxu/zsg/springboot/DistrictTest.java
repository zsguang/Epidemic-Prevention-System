package cn.gxu.zsg.springboot;

import cn.gxu.zsg.springboot.RandomData.RandomCommunity;
import cn.gxu.zsg.springboot.entity.District;
import cn.gxu.zsg.springboot.mapper.CommunityMapper;
import cn.gxu.zsg.springboot.mapper.DistrictMapper;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.web.servlet.MockMvc;


public class DistrictTest extends BaseSpringBootTest{
    private MockMvc mockMvc;

    @Autowired
    private DistrictMapper districtMapper;

    @Test
    public void insertDistrict() {
        String[] communityId = {"450107003001", "450107003003", "450107003004",
                "450107003005", "450107003006", "450107003007", "450107003009",
                "450107003010", "450107003011", "450107003012", "450107003013", "450107003201"};
        String[][] communities = RandomCommunity.Communities;
        String[][] extras = RandomCommunity.extras;
        for (int i = 0; i < communityId.length; i++) {
            for (int j = 0; j < extras[i].length; j++) {
                District district = new District();
                district.setCommunityId(communityId[i]);
                district.setDistrictName(extras[i][j]);
                district.setDistrictAddress("广西壮族自治区南宁市西乡塘街道" + communities[0][i]);
                String maxDistrictId = districtMapper.getMaxIdByCommunity(communityId[i]);
                String id = maxDistrictId == null || maxDistrictId.equals("")
                        ? district.getCommunityId() + "01"
                        : String.valueOf(Long.parseLong(maxDistrictId) + 1);
                district.setDistrictId(id);
                System.out.println(district);
                districtMapper.insert(district);
            }
        }
    }

}
