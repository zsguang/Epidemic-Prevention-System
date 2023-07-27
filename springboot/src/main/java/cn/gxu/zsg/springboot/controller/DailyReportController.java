package cn.gxu.zsg.springboot.controller;

import cn.gxu.zsg.springboot.common.Result;
import cn.gxu.zsg.springboot.entity.Community;
import cn.gxu.zsg.springboot.entity.DailyReport;
import cn.gxu.zsg.springboot.mapper.DailyReportMapper;
import cn.gxu.zsg.springboot.mapper.UserMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;

@RestController
@RequestMapping("/dailyReport")
public class DailyReportController {
    static Logger logger = LoggerFactory.getLogger(DailyReportController.class);

    @Resource
    DailyReportMapper dailyReportMapper;

    @Resource
    UserMapper userMapper;

    @GetMapping("/all")
    public Result<?> getAllDailyReports(
            @RequestParam(defaultValue = "") String time,
            @RequestParam(defaultValue = "") String user,
            @RequestParam(defaultValue = "") String address,
            @RequestParam(defaultValue = "") String temperature,
            @RequestParam(defaultValue = "") String coughed,
            @RequestParam(defaultValue = "") String diarrheaed,
            @RequestParam(defaultValue = "") String weaked
    ) {
        System.out.printf("getAllDailyReports time=%s  user=%s  address=%s  temperature=%s  coughed=%s  diarrheaed=%s  weaked=%s\n",
                time, user, address, temperature, coughed, diarrheaed, weaked);

//        Map<SFunction<DailyReport, ?>, Object> map = new HashMap<>();
//        if (coughed.equals("1")) map.put(DailyReport::getCoughed, coughed);
//        if (diarrheaed.equals("1")) map.put(DailyReport::getDiarrheaed, diarrheaed);
//        if (weaked.equals("1")) map.put(DailyReport::getWeaked, weaked);
//
//        List<DailyReport> dailyReportList = dailyReportMapper.selectList(Wrappers.<DailyReport>lambdaQuery()
//                .like(DailyReport::getReportTime, time)
//                .like(DailyReport::getUserPhone, phone)
//                .like(DailyReport::getTemperature, temperature)
//                .allEq(map)
//        );

        String sqlCondition = "";
        if (!time.equals("")) {
            sqlCondition += "daily_report.report_time like '%" + time + "%' ";
        }
        if (!user.equals("")) {
            if (!sqlCondition.equals("")) sqlCondition += "and ";
            sqlCondition += "(daily_report.user_phone like '%" + user + "%' or user.user_name like '%" + user + "%') ";
        }
        if (!address.equals("")) {
            if (!sqlCondition.equals("")) sqlCondition += "and ";
            sqlCondition += "(user.user_address like '%" + address + "%' or user.district_id like '%" + address + "%') ";
        }
        if (!temperature.equals("")) {
            if (!sqlCondition.equals("")) sqlCondition += "and ";
            sqlCondition += "daily_report.temperature like '%" + temperature + "%' ";
        }
        if (coughed.equals("1")) {
            if (!sqlCondition.equals("")) sqlCondition += "and ";
            sqlCondition+= "daily_report.coughed = '1' ";
        }
        if (diarrheaed.equals("1")) {
            if (!sqlCondition.equals("")) sqlCondition += "and ";
            sqlCondition+= "daily_report.diarrheaed = '1' ";
        }
        if (weaked.equals("1")) {
            if (!sqlCondition.equals("")) sqlCondition += "and ";
            sqlCondition+= "daily_report.weaked = '1' ";
        }


        String sql = "select * from daily_report,user,district where daily_report.user_phone=user.user_phone and user.district_id = district.district_id "
                + (sqlCondition.equals("") ? " " : " and ") + sqlCondition + "order by id DESC";

        logger.info(sql);

        List<DailyReport> dailyReportList = dailyReportMapper.selectAllCommunities(sql);

        logger.info("getAllDailyReports  size=" + dailyReportList.size());
        return Result.success(dailyReportList);
    }

    @PostMapping
    public Result<?> save(@RequestBody DailyReport dailyReport) {
        if (!dailyReport.isAvailable()) return Result.error("-1", "数据错误");
        int insert = dailyReportMapper.insert(dailyReport);
        if (insert == 1) {
            logger.info("Success insert " + dailyReport);
            return Result.success();
        } else {
            logger.warn("Failure insert " + dailyReport);
            return Result.error("-1", "失败");
        }
    }

}
