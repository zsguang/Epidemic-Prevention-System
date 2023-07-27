package cn.gxu.zsg.springboot.RandomData;

import cn.gxu.zsg.springboot.entity.Community;
import cn.gxu.zsg.springboot.entity.District;
import com.apifan.common.random.RandomSource;

import java.util.List;
import java.util.Random;

public class RandomCommunity {
    // https://www.wenjiangs.com/api/v2/xzqh?code=450107000000 西乡塘区 街道
    // https://www.wenjiangs.com/api/v2/xzqh?code=450107001000 西乡塘街道 社区

    private static final String Province = "广西壮族自治区";
    private static final String City = "南宁市";
    public static final String[] Streets = {"西乡塘区", "上尧街道", "新阳街道", "华强街道", "北湖街道", "衡阳街道", "石埠街道", "安吉街道", "安宁街道", "心圩街道", "金陵镇", "双定镇"};
    public static final String[][] Communities = {
            {"北大北路社区", "五里亭社区", "火炬路社区", "秀灵北社区", "位子渌社区", "大学东路社区", "瑞士花园社区", "大学西路社区", "科园大道社区", "西乡塘社区", "广西大学社区", "平新村"},
            {"大学南社区", "相思湖社区", "鲁班社区", "南罐社区", "上尧村", "陈东村", "陈西村"},
            {"新阳上社区", "新阳下社区", "龙腾社区", "边阳上社区", "边阳下社区", "永和社区", "新阳南社区", "北大南社区", "中兴社区", "百会社区", "壮锦社区", "万力社区", "南机社区", "永和村", "雅里村"},
            {"华强社区", "龙胜社区", "南伦社区", "永宁社区", "大同社区"},
            {"唐山路社区", "北湖南路社区", "衡阳东路社区", "望州北二里社区", "明秀社区", "明秀东社区", "明秀二区社区", "北湖中社区", "北湖东社区", "南棉社区", "秀湖社区", "秀厢路社区", "明湖社区", "明秀南社区", "友爱南社区", "秀灵村", "万秀村"},
            {"衡阳南社区", "衡阳北社区", "南铁北一区社区", "南铁北二区社区", "南铁北中区社区", "南铁北三区社区", "南铁北四区社区", "中华中社区", "友爱北社区", "友爱中社区", "秀灵南社区", "明秀中社区", "新秀社区", "秀厢村", "友爱村"},
            {"安村", "老口村", "乐洲村", "上灵村", "下灵村", "石埠村", "西明村", "兴贤村", "永安村", "忠良村", "石西村"},
            {"北湖北社区", "吉秀社区", "安吉路社区", "新世纪社区", "北湖安居社区", "秀安社区", "大塘村", "苏卢村", "屯渌村", "屯里村"},
            {"林科院社区", "皂角村", "北湖村", "连畴村", "西津村", "永宁村", "路西村", "北湖园艺场"},
            {"罗赖村", "振兴村", "和德村", "明华村", "心圩村", "大岭村", "四联村", "新村"},
            {"金陵村", "陆平村", "南岸村", "三联村", "东南村", "龙达村", "双义村", "广道村", "刚德村", "乐勇村", "居联村", "业仁村", "邓圩村", "金城社区"},
            {"兴平村", "义平村", "秀山村", "英龙村", "和强村", "武陵村"}
    };
    public static final String[][] extras = {
            {"梦泽园", "锦洋公馆", "钱江阁"},
            {"世贸西城", "富达花园", "恒通公寓"},
            {"嘉州华都", "洋浦星", "金满花园"},
            {"高新苑", "广西物资大学", "翰林雅筑"},
            {"长城小区", "龙腾苑", "翠湖花园"},
            {"科苑小区", "广西农业职业技术大学"},
            {"金龙公寓", "天龙小区", "新天地"},
            {"康达花园", "翰林御景", "光明街小区"},
            {"玉泉小区", "农业科学院"},
            {"丽园小区", "西城"},
            {"东校园", "西校园"},
            {"银达花园", "科德国际"}
    };

    public static void main(String[] args) {

    }

    public static String getRandomCommunity(List<Community> communities) {
        Random random = new Random();
        int index = random.nextInt(communities.size());
        return communities.get(index).getCommunityId();
    }

    public static String getRandomAddress(List<District> districts, int index) {
        Random random = new Random();
        String address = districts.get(index).getDistrictAddress() + districts.get(index).getDistrictName();
        int building = random.nextInt(10) + 1;
        address += building + "栋" + getRandomRoom() + "房";
        return address;
    }

    private static String getRandomRoom() {
        Random random = new Random();
        int a = random.nextInt(9) + 1;
        int b = random.nextInt(2);
        int c = random.nextInt(9) + 1;
        return "" + a + b + c;
    }

    public String getRandomChineseAddress() {
        return RandomSource.areaSource().randomAddress();
    }

//    private static String getRandomChineseAddress() {
////        Area area = new Area();
////        area.setProvince("广西壮族自治区");
////        area.setCity("南宁市");
////        area.setCounty("西乡塘区");
////        area.setZipCode("530000");
//
//        String address;
//        try {
//            Method method = RandomSource.areaSource().getClass().getDeclaredMethod("randomAddress", Area.class);
//            method.setAccessible(true);
//            address = (String) method.invoke(RandomSource.areaSource(), area);
//        } catch (Exception e) {
//            e.printStackTrace();
//            address = null;
//        }
//        return address;
//    }


}
