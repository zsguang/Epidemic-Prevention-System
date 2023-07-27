package cn.gxu.zsg.springboot.RandomData;

import cn.gxu.zsg.springboot.entity.User;
import com.apifan.common.random.constant.Province;
import com.apifan.common.random.source.PersonInfoSource;

import java.util.Random;


public class RandomUser {
    private static final int MALE = 0;
    private static final int FEMALE = 1;


    /**
     * @param gender MALE:男; FEMALE:女
     * @return String 随机姓名
     */
    private  static String randomName(int gender) {
        String name;
        if (gender == MALE) name = PersonInfoSource.getInstance().randomMaleChineseName();
        else if (gender == FEMALE) name = PersonInfoSource.getInstance().randomFemaleChineseName();
        else throw new IllegalArgumentException("The param of gender can only use MALE|FEMALE!");
        return name;
    }

    private  static String randomIdCard(int gender, int age) {
        String idCard;
        if (gender == MALE) {
            idCard = PersonInfoSource.getInstance().randomMaleIdCard(Province.GX, age);
        } else {
            idCard = PersonInfoSource.getInstance().randomFemaleIdCard(Province.GX, age);
        }
        return idCard;
    }

    public static User getRandomUser() {
        User user = new User();

        Random random = new Random();
        int gender = random.nextInt(2); // 随机性别
        int age = random.nextInt(58) + 12;  // 随机年龄 [12-70)
        String idCard = randomIdCard(gender, age);
        user.setUserPhone(PersonInfoSource.getInstance().randomChineseMobile());
        user.setUserIdcard(idCard);
        user.setPassword(user.getUserPhone());
        user.setUserName(randomName(gender));
        user.setUserGender(String.valueOf(gender));
        user.setUserBirthday(idCard.substring(6, 10) + "年" + idCard.substring(10, 12) + "月" + idCard.substring(12, 14) + "日");//45212 22000 0126 1516
        user.setManager("0");
        user.setHealth("0");
        return user;
    }

    public static void main(String[] args) {
        //randomAddress(Area area)
//        Area area = new Area();
//        area.setProvince("广西壮族自治区");
//        area.setCity("南宁市");
//        area.setProvince("西乡塘");
//        area.setZipCode("530000");
//        String community = RandomCommunity.getRandomCommunity();

        System.out.println(getRandomUser());
    }


}

