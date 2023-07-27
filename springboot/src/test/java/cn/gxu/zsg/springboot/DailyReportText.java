package cn.gxu.zsg.springboot;

import cn.gxu.zsg.springboot.entity.DailyReport;
import cn.gxu.zsg.springboot.mapper.DailyReportMapper;
import cn.gxu.zsg.springboot.mapper.UserMapper;
import com.apifan.common.random.RandomSource;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import org.apache.commons.lang3.RandomUtils;
import org.junit.Before;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import java.text.DecimalFormat;
import java.time.LocalDate;
import java.util.List;
import java.util.Random;

public class DailyReportText extends BaseSpringBootTest {

    private MockMvc mockMvc;

    @Autowired
    private DailyReportMapper dailyReportMapper;

    @Autowired
    private UserMapper userMapper;


    @Before
    public void setup() {
        mockMvc = MockMvcBuilders.standaloneSetup(dailyReportMapper).build();
    }

    @Test
    public void insertDailyReport() {
        List<String> userList = userMapper.selectUserPhone();

        DecimalFormat df = new DecimalFormat("0.0");
        Random random = new Random();
        LocalDate beginDate = LocalDate.of(2023, 1, 1);
        LocalDate endDate = LocalDate.of(2023, 4, 16);
        for (int i = 0; i < 1000; i++) {
            int userIndex = random.nextInt(userList.size());

            String date = RandomSource.dateTimeSource().randomDate(beginDate, endDate, "yyyy-MM-dd");
            int hour = RandomUtils.nextInt(0, 24);
            int minute = RandomUtils.nextInt(0, 60);
            String time = date + (hour < 10 ? " 0" : " ") + hour + (minute < 10 ? ":0" : ":")  + minute;

            DailyReport dailyReport = new DailyReport();
            dailyReport.setReportTime(time);
            dailyReport.setUserPhone(userList.get(userIndex));
            dailyReport.setCoughed(RandomUtils.nextInt(0, 50) >= 49 ? "1" : "0");
            dailyReport.setDiarrheaed(RandomUtils.nextInt(0, 50) >= 49 ? "1" : "0");
            dailyReport.setWeaked(RandomUtils.nextInt(0, 50) >= 49 ? "1" : "0");
            double temperature = RandomUtils.nextDouble(35.2, 36.6);
            dailyReport.setTemperature(Float.parseFloat(df.format(temperature)));

//            System.out.println(dailyReport);
            dailyReportMapper.insert(dailyReport);
        }
    }

    @Test
    public void editDailyReport() {
        DecimalFormat df = new DecimalFormat("0.0");
        List<DailyReport> list = dailyReportMapper.selectList(Wrappers.<DailyReport>lambdaQuery());
        for (DailyReport dailyReport : list) {
            String format = df.format(dailyReport.getTemperature());
            dailyReport.setTemperature(Float.parseFloat(format));
            dailyReportMapper.update(dailyReport,Wrappers.<DailyReport>lambdaQuery().eq(DailyReport::getId,dailyReport.getId()));
        }
    }

    public static void main(String[] args) {
    }
}
