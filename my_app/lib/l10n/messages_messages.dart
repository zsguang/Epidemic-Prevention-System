import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = MessageLookup();

typedef String MessageIfAbsent(String? messageStr, List<Object>? args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'messages';

  final messages = _notInlinedMessages(_notInlinedMessages);

  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "auto": MessageLookupByLibrary.simpleMessage("Auto"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "home": MessageLookupByLibrary.simpleMessage("Community Prevention System"),
        "language": MessageLookupByLibrary.simpleMessage("Language"),
        "login": MessageLookupByLibrary.simpleMessage("Login"),
        "register": MessageLookupByLibrary.simpleMessage("Register"),
        "registerMessage": MessageLookupByLibrary.simpleMessage("No account? Click to register"),
        "logout": MessageLookupByLibrary.simpleMessage("logout"),
        "logoutTip": MessageLookupByLibrary.simpleMessage("Are you sure you want to quit your current account?"),
        "noDescription": MessageLookupByLibrary.simpleMessage("No description yet !"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "passwordAgain": MessageLookupByLibrary.simpleMessage("Password Again"),
        "passwordRequired": MessageLookupByLibrary.simpleMessage("Password required!"),
        "title": MessageLookupByLibrary.simpleMessage("Flutter APP"),
        "userName": MessageLookupByLibrary.simpleMessage("User Name"),
        "userPhoneOrPasswordWrong": MessageLookupByLibrary.simpleMessage("User phone or password is not correct!"),
        "userNameRequired": MessageLookupByLibrary.simpleMessage("User name required!"),
        "yes": MessageLookupByLibrary.simpleMessage("Yes"),
        "networkError": MessageLookupByLibrary.simpleMessage("Network Error"),

        // 主页
        "bmNavigationHome": MessageLookupByLibrary.simpleMessage("Home"),
        "bmNavigationMine": MessageLookupByLibrary.simpleMessage("Mine"),
        "accessBySweeping": MessageLookupByLibrary.simpleMessage("Access By Sweeping"),
        "dailyReport.json": MessageLookupByLibrary.simpleMessage("Daily Report"),
        "healthCode": MessageLookupByLibrary.simpleMessage("Health Code"),
        "itinerary": MessageLookupByLibrary.simpleMessage("Itinerary"),
        "outbreakData": MessageLookupByLibrary.simpleMessage("Outbreak Data"),
        "outbreakNews": MessageLookupByLibrary.simpleMessage("Outbreak News"),
        "communityBulletin": MessageLookupByLibrary.simpleMessage("Community Bulletin"),
        "other": MessageLookupByLibrary.simpleMessage("Other"),
        "greenCode": MessageLookupByLibrary.simpleMessage("Green Code"),
        "yellowCode": MessageLookupByLibrary.simpleMessage("Yellow Code"),
        "redCode": MessageLookupByLibrary.simpleMessage("Red Code"),
        "loginRequest": MessageLookupByLibrary.simpleMessage("Please login to your account first"),

        // 我的
        "myInfo": MessageLookupByLibrary.simpleMessage("My Information"),
        "setting": MessageLookupByLibrary.simpleMessage("Setting"),
        "theme": MessageLookupByLibrary.simpleMessage("Theme"),
        "authentication": MessageLookupByLibrary.simpleMessage("Real-name authentication"),
        "unAuthentication": MessageLookupByLibrary.simpleMessage("unAuthentication"),
        "authenticate": MessageLookupByLibrary.simpleMessage("Authenticate"),
        // 个人信息
        "phone": MessageLookupByLibrary.simpleMessage("Phone"),
        "idCard": MessageLookupByLibrary.simpleMessage("IdCard"),
        "name": MessageLookupByLibrary.simpleMessage("Name"),
        "personInfo": MessageLookupByLibrary.simpleMessage("Personal Information"),
        "avatar": MessageLookupByLibrary.simpleMessage("Avatar"),
        "changeAvtar": MessageLookupByLibrary.simpleMessage("Change Avatar"),
        "QRCode": MessageLookupByLibrary.simpleMessage("QR Code"),
        "address": MessageLookupByLibrary.simpleMessage("Address of residence"),
        "shootPhone": MessageLookupByLibrary.simpleMessage("Shoot Phone"),
        "selectPhone": MessageLookupByLibrary.simpleMessage("Select From Albums"),
        "confirmReplacement": MessageLookupByLibrary.simpleMessage("Replace"),
        "noChoiceImage": MessageLookupByLibrary.simpleMessage("Please select a picture"),
        "failChangeAvtar": MessageLookupByLibrary.simpleMessage("Failed to change avatar"),
        "successChangeAvtar": MessageLookupByLibrary.simpleMessage("Succeed to change avatar"),
        "noProvince": MessageLookupByLibrary.simpleMessage("Province not selected"),
        "noCity": MessageLookupByLibrary.simpleMessage("City not selected"),
        "noArea": MessageLookupByLibrary.simpleMessage("Area not selected"),
        "province": MessageLookupByLibrary.simpleMessage("Province"),
        "city": MessageLookupByLibrary.simpleMessage("City"),
        "area": MessageLookupByLibrary.simpleMessage("Area"),
        "community": MessageLookupByLibrary.simpleMessage("Community"),
        "fullAddress": MessageLookupByLibrary.simpleMessage("Full Address"),
        "accountAndSecurity": MessageLookupByLibrary.simpleMessage("Account and Security"),

  };
}
