package cn.gxu.zsg.springboot.controller;

import cn.gxu.zsg.springboot.common.Result;
import cn.gxu.zsg.springboot.entity.Access;
import cn.gxu.zsg.springboot.entity.DailyReport;
import cn.gxu.zsg.springboot.entity.User;
import cn.gxu.zsg.springboot.mapper.AccessMapper;
import cn.gxu.zsg.springboot.mapper.DailyReportMapper;
import cn.gxu.zsg.springboot.mapper.UserMapper;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.LinkedList;
import java.util.List;

@RestController
@RequestMapping("/predict")
public class PredictController {
    static Logger logger = LoggerFactory.getLogger(PredictController.class);

    @Resource
    private UserMapper userMapper;

    @Resource
    private DailyReportMapper dailyReportMapper;

    @Resource
    private AccessMapper accessMapper;

    @GetMapping("/all")
    public Result<?> getAllSuspect(@RequestParam(defaultValue = "") String defaultUser) {
        List<User> suspectUsers = new LinkedList<>();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); // 指定日期格式
        Calendar calendar = Calendar.getInstance();

        // 找出指定或所有红码人员
        LambdaQueryWrapper<User> wrapper;

        if (defaultUser.equals("")) {
            wrapper = Wrappers.<User>lambdaQuery().eq(User::getHealth, "2");
        } else {
            wrapper = Wrappers.<User>lambdaQuery()
                    .eq(User::getUserPhone, defaultUser)
                    .or().eq(User::getUserIdcard, defaultUser)
                    .or().eq(User::getUserName, defaultUser);
        }
        List<User> users = userMapper.selectList(wrapper);
        // 找出和红码人员有关的密切接触者
        for (User userValue : users) {
            QueryWrapper<Access> lastDateWrapper = new QueryWrapper<>();
            lastDateWrapper.eq("user_phone", userValue.getUserPhone()).select("max(access_time)");
            String lastTime = (String) accessMapper.selectObjs(lastDateWrapper).get(0); // 获取最新行程
            String pre15Time = lastTime;
            try {
                calendar.setTime(dateFormat.parse(lastTime));
                calendar.add(Calendar.DATE, -15);
                Date date = calendar.getTime();
                pre15Time = dateFormat.format(date);
            } catch (Exception e) {
                e.printStackTrace();
            }

            // 获取最近15天与红码或指定人员的轨迹相同的人员行程
            List<Access> date15Access = accessMapper.getBt15ByPhone(pre15Time, lastTime, userValue.getUserPhone());
            // 根据条件筛选可疑人员 (近15天体温大于38° 且 咳嗽 | 腹泻 | 乏力)
            for (Access access : date15Access) {
                User user = access.getUser();
                if (!suspectUsers.contains(user)) {
                    List<DailyReport> reports = dailyReportMapper.selectList(Wrappers.<DailyReport>lambdaQuery()
                            .eq(DailyReport::getUserPhone, user.getUserPhone())
                            .between(DailyReport::getReportTime, pre15Time, lastTime)
                    );
                    if (reports.isEmpty()) {    // 近15天每日报告无数据，列为可疑人员
                        suspectUsers.add(access.getUser());
                    } else {
                        for (DailyReport dailyReport : reports) {
                            if (dailyReport.isSuspect()) {
                                suspectUsers.add(access.getUser());
                            }
                        }
                        // System.out.println(user.getUserName() + ": " + reports);
                    }
                }
            }
        }
        logger.info("getAllSuspect " + suspectUsers.size());
        return Result.success(suspectUsers);
    }

}
