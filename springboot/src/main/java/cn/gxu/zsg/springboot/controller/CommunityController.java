package cn.gxu.zsg.springboot.controller;

import cn.gxu.zsg.springboot.common.Result;
import cn.gxu.zsg.springboot.entity.Community;
import cn.gxu.zsg.springboot.mapper.CommunityMapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;

@RestController
@RequestMapping("/community")
public class CommunityController {
    static Logger logger = LoggerFactory.getLogger(CommunityController.class);

    @Resource
    CommunityMapper communityMapper;

    @PostMapping
    public Result<?> save(@RequestBody Community community) {
        if (community == null || community.getCommunityId().equals("")
                || community.getCommunityName().equals("") || community.getCommunityAddress().equals("")) {
            return Result.error("-1", "社区信息不完整");
        }
        List<Community> selectList = communityMapper.selectList(Wrappers.<Community>lambdaQuery()
                .eq(Community::getCommunityId, community.getCommunityId())
                .or()
                .eq(Community::getCommunityAddress, community.getCommunityAddress())
                .eq(Community::getCommunityName, community.getCommunityName())
        );
        if (!selectList.isEmpty()) {
            return Result.error("-1", "社区信息已存在");
        }

        logger.info("Community Insert: " + community);
        int insert = communityMapper.insert(community);

        if (insert == 1) return Result.success();
        else return Result.error("-1", "社区创建失败");
    }

    @GetMapping("/all")
    public Result<?> getAllCommunities(@RequestParam String search) {
        List<Community> communities = communityMapper.selectList(Wrappers.<Community>lambdaQuery()
                .like(Community::getCommunityId, search)
                .or()
                .like(Community::getCommunityName, search)
                .or()
                .like(Community::getCommunityAddress, search)
        );
        logger.info("getAllCommunities  size=" + communities.size());
        return Result.success(communities);
    }

    @GetMapping("/getCommunityName")
    public Result<?> getCommunityName(@RequestParam String communityId) {
        Community community = communityMapper.selectOne(Wrappers.<Community>lambdaQuery().eq(Community::getCommunityId, communityId));
        if (community == null) {
            return Result.error("-1", "社区ID不存在");
        }
        return Result.success(community.getCommunityName());
    }

}
