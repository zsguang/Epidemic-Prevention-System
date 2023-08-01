import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = MessageLookup();

typedef String MessageIfAbsent(String? messageStr, List<Object>? args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'zh_CN';

  final messages = _notInlinedMessages(_notInlinedMessages);

  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "auto": MessageLookupByLibrary.simpleMessage("跟随系统"),
        "cancel": MessageLookupByLibrary.simpleMessage("取消"),
        "home": MessageLookupByLibrary.simpleMessage("社区疫情防控系统"),
        "language": MessageLookupByLibrary.simpleMessage("语言"),
        "login": MessageLookupByLibrary.simpleMessage("登录"),
        "register": MessageLookupByLibrary.simpleMessage("注册"),
        "registerMessage": MessageLookupByLibrary.simpleMessage("没有账号？点击注册"),
        "logoutTip": MessageLookupByLibrary.simpleMessage("确定要退出当前账号吗?"),
        "noDescription": MessageLookupByLibrary.simpleMessage("暂无描述!"),
        "password": MessageLookupByLibrary.simpleMessage("密码"),
        "passwordAgain": MessageLookupByLibrary.simpleMessage("再次输入"),
        "passwordRequired": MessageLookupByLibrary.simpleMessage("密码不能为空"),
        "title": MessageLookupByLibrary.simpleMessage("社区疫情防控系统"),
        "userName": MessageLookupByLibrary.simpleMessage("用户名"),
        "userPhoneOrPasswordWrong": MessageLookupByLibrary.simpleMessage("手机号或密码不正确"),
        "userNameRequired": MessageLookupByLibrary.simpleMessage("用户名不能为空"),
        "yes": MessageLookupByLibrary.simpleMessage("确定"),
        "networkError": MessageLookupByLibrary.simpleMessage("网路错误"),

        // 主页
        "bmNavigationHome": MessageLookupByLibrary.simpleMessage("主页"),
        "bmNavigationMine": MessageLookupByLibrary.simpleMessage("我的"),
        "bmNavigationManager": MessageLookupByLibrary.simpleMessage("管理"),
        "accessBySweeping": MessageLookupByLibrary.simpleMessage("扫码通行"),
        "dailyReport.json": MessageLookupByLibrary.simpleMessage("每日健康"),
        "healthCode": MessageLookupByLibrary.simpleMessage("健康码"),
        "itinerary": MessageLookupByLibrary.simpleMessage("我的行程"),
        "outbreakData": MessageLookupByLibrary.simpleMessage("疫情数据"),
        "outbreakNews": MessageLookupByLibrary.simpleMessage("疫情新闻"),
        "communityBulletin": MessageLookupByLibrary.simpleMessage("社区公告"),
        "other": MessageLookupByLibrary.simpleMessage("其他"),
        "greenCode": MessageLookupByLibrary.simpleMessage("绿码"),
        "yellowCode": MessageLookupByLibrary.simpleMessage("黄码"),
        "redCode": MessageLookupByLibrary.simpleMessage("红码"),
        "loginRequest": MessageLookupByLibrary.simpleMessage("请先登录账号"),

        // 我的
        "myInfo": MessageLookupByLibrary.simpleMessage("我的信息"),
        "setting": MessageLookupByLibrary.simpleMessage("设置"),
        "theme": MessageLookupByLibrary.simpleMessage("主题"),
        "authentication": MessageLookupByLibrary.simpleMessage("实名认证"),
        "unAuthentication": MessageLookupByLibrary.simpleMessage("未实名"),
        "authenticate": MessageLookupByLibrary.simpleMessage("认证"),
        // "logout": MessageLookupByLibrary.simpleMessage("注销"),
        "logout": MessageLookupByLibrary.simpleMessage("退出登录"),
        // 个人信息
        "personInfo": MessageLookupByLibrary.simpleMessage("个人信息"),
        "phone": MessageLookupByLibrary.simpleMessage("手机号码"),
        "idCard": MessageLookupByLibrary.simpleMessage("证件号码"),
        "name": MessageLookupByLibrary.simpleMessage("姓名"),
        "avatar": MessageLookupByLibrary.simpleMessage("头像"),
        "changeAvtar": MessageLookupByLibrary.simpleMessage("更换头像"),
        "QRCode": MessageLookupByLibrary.simpleMessage("二维码"),
        "address": MessageLookupByLibrary.simpleMessage("居住地址"),
        "shootPhone": MessageLookupByLibrary.simpleMessage("拍照"),
        "selectPhone": MessageLookupByLibrary.simpleMessage("从相册选择"),
        "confirmReplacement": MessageLookupByLibrary.simpleMessage("确认更换"),
        "noChoiceImage": MessageLookupByLibrary.simpleMessage("请选择图片"),
        "failChangeAvtar": MessageLookupByLibrary.simpleMessage("更换头像失败"),
        "successChangeAvtar": MessageLookupByLibrary.simpleMessage("更换头像成功"),
        "noProvince": MessageLookupByLibrary.simpleMessage("未选择省份"),
        "noCity": MessageLookupByLibrary.simpleMessage("未选择城市"),
        "noArea": MessageLookupByLibrary.simpleMessage("未选择地区"),
        "province": MessageLookupByLibrary.simpleMessage("省份"),
        "city": MessageLookupByLibrary.simpleMessage("城市"),
        "area": MessageLookupByLibrary.simpleMessage("县区"),
        "community": MessageLookupByLibrary.simpleMessage("社区"),
        "fullAddress": MessageLookupByLibrary.simpleMessage("详细地址"),
        "accountAndSecurity": MessageLookupByLibrary.simpleMessage("账号与安全"),
      };
}
