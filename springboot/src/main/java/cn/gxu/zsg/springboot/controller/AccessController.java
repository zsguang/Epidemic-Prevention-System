package cn.gxu.zsg.springboot.controller;

import cn.gxu.zsg.springboot.common.Result;
import cn.gxu.zsg.springboot.entity.Access;
import cn.gxu.zsg.springboot.mapper.AccessMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;

@RestController
@RequestMapping("/access")
public class AccessController {
    static Logger logger = LoggerFactory.getLogger(AccessController.class);

    @Resource
    AccessMapper accessMapper;

    @GetMapping("/all")
    public Result<?> getAllAccess(
            @RequestParam(defaultValue = "") String time,
            @RequestParam(defaultValue = "") String user,
            @RequestParam(defaultValue = "") String community,
            @RequestParam(defaultValue = "") String district,
            @RequestParam(defaultValue = "") String outPrince
    ) {
        System.out.printf("getAllAccess: time=%s  user=%s  community=%s  district=%s  outPrince=%s\n", time, user, community, district, outPrince);

        String sqlCondition = "";
        if (!time.equals("")) {
            sqlCondition += "access_time like '%" + time + "%' ";
        }
        if (!user.equals("")) {
            if (!sqlCondition.equals("")) sqlCondition += "and ";
            sqlCondition += "(access.user_phone like '%" + user + "%' or user.user_name like'%" + user + "%') ";
        }
        if (!community.equals("")) {
            if (!sqlCondition.equals("")) sqlCondition += "and ";
            sqlCondition += "(district.community_id like '%" + community + "' or district.community_name like '%" + community + "%') ";
        }
        if (!district.equals("")) {
            if (!sqlCondition.equals("")) sqlCondition += "and ";
            sqlCondition += "( access.district_id like '%" + district + "%' or district.district_name like '%" + district + "%') ";
        }
        if (!outPrince.equals("") && !outPrince.equals("01")) {
            if (!sqlCondition.equals("")) sqlCondition += "and ";
            sqlCondition += "access.out_province='" + outPrince + "'";
        }

        String sql = "select * from access,user,district where access.user_phone=user.user_phone and access.district_id=district.district_id"
                + (sqlCondition.equals("") ? " " : " and ") + sqlCondition + "order by id DESC";

        System.out.println(sql);

        List<Access> accessList = accessMapper.selectAllAccesses(sql);
        logger.info("getAllAccess  size=" + accessList.size());
        return Result.success(accessList);
    }

    @GetMapping("/id")
    public Result<?> getAccessById(@RequestParam String id) {
        if (id == null || id.equals("")) return Result.error("-1", "查询编号不能为空");
        Access access = accessMapper.getAccessById(id);
        System.out.println("\n" + access);
        return Result.success(access);
    }

    @PostMapping
    public Result<?> save(@RequestBody Access access) {
        if (!access.isAvailable()) return Result.error("-1", "数据错误");
        int insert = accessMapper.insert(access);
        if (insert == 1) {
            logger.info("Success insert " + access);
            return Result.success();
        } else {
            logger.warn("Failure insert " + access);
            return Result.error("-1", "失败");
        }
    }

    @GetMapping("/phone")
    public Result<?> getAccessByPhone(@RequestParam String phone) {
        if (phone.isEmpty()) return Result.error("-1", "请求数据不能为空");
        List<Access> accessList = accessMapper.getAccessByPhone(phone);
        return Result.success(accessList);
    }
}
