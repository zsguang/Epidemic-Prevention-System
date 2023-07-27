package cn.gxu.zsg.springboot.controller;

import cn.gxu.zsg.springboot.common.Result;
import cn.gxu.zsg.springboot.entity.Community;
import cn.gxu.zsg.springboot.entity.District;
import cn.gxu.zsg.springboot.entity.User;
import cn.gxu.zsg.springboot.mapper.DailyReportMapper;
import cn.gxu.zsg.springboot.mapper.DistrictMapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;

@RestController
@RequestMapping("/district")
public class DistrictController {
    static Logger logger = LoggerFactory.getLogger(DistrictController.class);

    @Resource
    DistrictMapper districtMapper;

    @PostMapping
    public Result<?> save(@RequestBody District district) {
        if (district == null || district.getDistrictAddress().equals("")
                || district.getDistrictName().equals("") || district.getCommunityId().equals("")) {
            return Result.error("-1", "小区信息不完整");
        }
        List<District> selectList = districtMapper.selectList(Wrappers.<District>lambdaQuery()
                .eq(District::getDistrictName, district.getDistrictName())
                .eq(District::getCommunityId, district.getCommunityId())
        );
        if (!selectList.isEmpty()) {
            return Result.error("-1", "小区名字已存在");
        }

        String maxDistrictId = districtMapper.getMaxIdByCommunity(district.getCommunityId());
        String id = maxDistrictId == null || maxDistrictId.equals("")
                ? district.getCommunityId() + "01"
                : String.valueOf(Long.parseLong(maxDistrictId) + 1);
        district.setDistrictId(id);

        logger.info("District Insert: " + district);
        int insert = districtMapper.insert(district);

        if (insert == 1) return Result.success();
        else return Result.error("-1", "小区创建失败");
    }

    @GetMapping("/all")
    public Result<?> getAllDailyReports(@RequestParam String search) {
        List<District> communities = districtMapper.selectList(Wrappers.<District>lambdaQuery()
                .like(District::getDistrictId, search)
                .or()
                .like(District::getDistrictName, search)
                .or()
                .like(District::getDistrictAddress, search)
        );
        logger.info("getAllDistricts  size=" + communities.size());
        return Result.success(communities);
    }
}
