package cn.gxu.zsg.springboot.controller;

import cn.gxu.zsg.springboot.common.Result;
import cn.gxu.zsg.springboot.entity.District;
import cn.gxu.zsg.springboot.mapper.DistrictMapper;
import cn.gxu.zsg.springboot.mapper.UserMapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.*;
import cn.gxu.zsg.springboot.entity.User;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@RestController
@RequestMapping("/user")
public class UserController {
    static Logger logger = LoggerFactory.getLogger(UserController.class);

    @Resource
    UserMapper userMapper;

    @Resource
    DistrictMapper districtMapper;


    @PostMapping("/login")
    public Result<?> login(@RequestBody User user) {
        logger.info("login post user" + user.toString());
        User res = userMapper.selectOne(Wrappers.<User>lambdaQuery().eq(User::getUserPhone, user.getUserPhone()).eq(User::getPassword, user.getPassword()));
        if (res == null) {
            return Result.error("-1", "用户名或密码错误");
        }
        District district = districtMapper.selectOne(Wrappers.<District>lambdaQuery().eq(District::getDistrictId, res.getDistrictId()));
        if (district != null) res.setDistrict(district);
        System.out.println("Login: " + res.getUserPhone());
        return Result.success(res);
    }

    @PostMapping({"/userInfo"})
    public Result<?> getUserInfo(@RequestBody User user) {
        User res = userMapper.selectOne(Wrappers.<User>lambdaQuery()
                .eq(User::getUserPhone, user.getUserPhone())
                .eq(User::getPassword, user.getPassword()));
//                .and(wrapper -> wrapper.eq(User::getPassword, user.getPassword())));
        if (res == null) {
            return Result.error("-1", "请重新登录");
        }
        District district = districtMapper.selectOne(Wrappers.<District>lambdaQuery().eq(District::getDistrictId, res.getDistrictId()));
        if (district != null) res.setDistrict(district);
        System.out.println("getUserInfo: " + res);
        return Result.success(res);
    }

    @PostMapping
    public Result<?> save(@RequestBody User user) {
        if (userMapper.exists(Wrappers.<User>lambdaQuery().eq(User::getUserPhone, user.getUserPhone()))) {
            return Result.error("-1", "该账号已存在！");
        }
        user.setManager("0");
        user.setHealth("0");
        user.setUserIdcard("");
        System.out.println("Insert: " + user);
//        if (user.getAvatar() == null) {
//            user.setAvatar("http://localhost:9090/image/defaultUser.png");
//        }
        int insert = userMapper.insert(user);
        if (insert != 1) return Result.error("-1", "账号创建失败");
        return Result.success();
    }

    @PutMapping
    public Result<?> update(@RequestBody User user) {
        System.out.println("Update: " + user);

        int update = userMapper.update(user, Wrappers.<User>lambdaQuery().eq(User::getUserPhone, user.getUserPhone()));
        if (update == 1) {
            District district = districtMapper.selectOne(Wrappers.<District>lambdaQuery().eq(District::getDistrictId, user.getDistrictId()));
            if (district != null) user.setDistrict(district);
            return Result.success(user);
        } else {
            return Result.error("-1", "修改失败");
        }
    }

    @PutMapping("/authenticate")
    public Result<?> authentic(@RequestBody User user) {
        logger.info("Authenticate: " + user);

        String idCard = user.getUserIdcard();
        Pattern pattern = Pattern.compile("^[1-9]\\d{5}(19|20)\\d{2}((0[1-9])|(1[0-2]))(([0-2][1-9])|10|20|30|31)\\d{3}[0-9Xx]$");
        Matcher matcher = pattern.matcher(idCard);
        if (!matcher.matches()) {
            return Result.error("-1", "身份证号格式错误");
        }
        try {
            user.setUserGender(idCard.charAt(16) % 2 == 1 ? "0" : "1");
            user.setUserBirthday(idCard.substring(6, 10) + "年" + idCard.substring(10, 12) + "月" + idCard.substring(12, 14) + "日");
        } catch (Exception e) {
            return Result.error("-1", "身份证解析错误，认证失败");
        }
        if (userMapper.exists(Wrappers.<User>lambdaQuery()
                .eq(User::getUserPhone, user.getUserPhone())
                .eq(User::getUserIdcard, user.getUserIdcard()))
        ) {
            return Result.error("-1", "身份证已绑定");
        }
        int update = userMapper.update(user, Wrappers.<User>lambdaQuery().eq(User::getUserPhone, user.getUserPhone()));

        if (update == 1) {
            return Result.success(user);
        } else {
            return Result.error("-1", "认证失败");
        }
    }

    @GetMapping("page")
    public Result<?> findPage(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(defaultValue = "") String userPhone,
            @RequestParam(defaultValue = "") String userName,
            @RequestParam(defaultValue = "") String userIdCard,
            @RequestParam(defaultValue = "") String districtId,
            @RequestParam(defaultValue = "") String health,
            @RequestParam(defaultValue = "") String manager
    ) {
        System.out.printf("pageNum=%s  pageSize=%s  userPhone=%s  userName=%s  userIdCard=%s  userCommunity=%s  health=%s  manager=%s\n",
                pageNum, pageSize, userPhone, userName, userIdCard, districtId, health, manager);

        List<String> healthValues = new ArrayList<>();
        if (health.contains("0")) healthValues.add("0");
        if (health.contains("1")) healthValues.add("1");
        if (health.contains("2")) healthValues.add("2");

        List<String> managerValues = new ArrayList<>();
        if (manager.contains("0")) managerValues.add("0");
        if (manager.contains("1")) managerValues.add("1");

        Page<User> userPage = userMapper.selectPage(
                new Page<>(pageNum, pageSize),
                Wrappers.<User>lambdaQuery()
                        .like(User::getUserPhone, userPhone)
                        .like(User::getUserName, userName)
                        .like(User::getUserIdcard, userIdCard)
                        .like(User::getDistrictId, districtId)
                        .in(!healthValues.isEmpty(), User::getHealth, healthValues)
                        .in(!managerValues.isEmpty(), User::getManager, managerValues)
        );
        logger.info("-------" + userPage.getRecords().size());
        return Result.success(userPage);
    }


    @GetMapping("/all")
    public Result<?> getAllUser(
            @RequestParam(defaultValue = "") String userPhone,
            @RequestParam(defaultValue = "") String userName,
            @RequestParam(defaultValue = "") String userIdCard,
            @RequestParam(defaultValue = "") String address,
            @RequestParam(defaultValue = "") String health,
            @RequestParam(defaultValue = "") String manager
    ) {
        System.out.printf("getAllUser: userPhone=%s  userName=%s  userIdCard=%s  userCommunity=%s  health=%s  manager=%s\n",
                userPhone, userName, userIdCard, address, health, manager);

        List<String> healthValues = new ArrayList<>();
        if (health.contains("0")) healthValues.add("0");
        if (health.contains("1")) healthValues.add("1");
        if (health.contains("2")) healthValues.add("2");

        List<String> managerValues = new ArrayList<>();
        if (manager.contains("0")) managerValues.add("0");
        if (manager.contains("1")) managerValues.add("1");

        List<User> userList = userMapper.selectList(Wrappers.<User>lambdaQuery()
                .like(User::getUserPhone, userPhone)
                .like(User::getUserName, userName)
                .like(User::getUserIdcard, userIdCard)
                .like(User::getUserAddress, address)
                .in(!healthValues.isEmpty(), User::getHealth, healthValues)
                .in(!managerValues.isEmpty(), User::getManager, managerValues)
        );

//        List<User> userList = userMapper.selectUserWithDistrict(userPhone, userName, userIdCard, community, healthValues, managerValues);

        logger.info("getAllUser------szie = " + userList.size());
        return Result.success(userList);
    }

//    private Wrapper<User> healthWrapper(String health) {
//        if (health.equals("")) {
//            return Wrappers.<User>lambdaQuery().isNull(User::getHealth);
//        }
//        Map<SFunction<User, ?>, Object> healthParams = new HashMap<>();
//        if (health.contains("0")) healthParams.put(User::getHealth, "0");
//        if (health.contains("1")) healthParams.put(User::getHealth, "1");
//        if (health.contains("2")) healthParams.put(User::getHealth, "2");
//        return Wrappers.<User>lambdaQuery().allEq(healthParams);
//    }

//    @GetMapping({"/userPass"})
//    public Result<?> getUserPass(@RequestParam("userPhone") String userPhone) {
//
//        String user = (String) userMapper.dynamicSql("select password from user where user_phone = '" + userPhone + "'");
//        if (user == null) {
//            return Result.error("-1", "请重新登录");
//        }
//        System.out.println("getUserInfo: " + user);
//        return Result.success(user);
//    }

}
