import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'messages_all.dart';

class GmLocalizations {
  static Future<GmLocalizations> load(Locale locale) {
    final String name = (locale.countryCode ?? "").isEmpty == true ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((b) {
      Intl.defaultLocale = localeName;
      return new GmLocalizations();
    });
  }

  static GmLocalizations of(BuildContext context) {
    return Localizations.of<GmLocalizations>(context, GmLocalizations)!;
  }

  String get title {
    return Intl.message(
      'Flutter APP',
      name: 'title',
      desc: 'Title for the Demo application',
    );
  }

  String get home => Intl.message('Community Prevention System', name: 'home');

  String get language => Intl.message('Language', name: 'language');

  String get login => Intl.message('Login', name: 'login');

  String get register => Intl.message('Register', name: 'register');

  String get registerMessage => Intl.message('No account? Click to register', name: 'registerMessage');

  String get auto => Intl.message('Auto', name: 'auto');

  String get setting => Intl.message('Setting', name: 'setting');

  String get theme => Intl.message('Theme', name: 'theme');

  String get noDescription => Intl.message('No description yet !', name: 'noDescription');

  String get userName => Intl.message('User Name', name: 'userName');

  String get userNameRequired => Intl.message("User name required!", name: 'userNameRequired');

  String get password => Intl.message('Password', name: 'password');

  String get passwordAgain => Intl.message('Password Again', name: 'passwordAgain');

  String get passwordRequired => Intl.message('Password required!', name: 'passwordRequired');

  String get userPhoneOrPasswordWrong =>
      Intl.message('User phone or password is not correct!', name: 'userPhoneOrPasswordWrong');

  String get logout => Intl.message('logout', name: 'logout');

  String get logoutTip => Intl.message('Are you sure you want to quit your current account?', name: 'logoutTip');

  String get yes => Intl.message('Yes', name: 'yes');

  String get networkError => Intl.message('Network Error', name: 'networkError');

  String get cancel => Intl.message('Cancel', name: 'cancel');

  // 主页
  String get bmNavigationHome => Intl.message('Home', name: 'bmNavigationHome');

  String get bmNavigationMine => Intl.message('Mine', name: 'bmNavigationMine');

  String get bmNavigationManager => Intl.message('Manager', name: 'bmNavigationManager');

  String get accessBySweeping => Intl.message('Access By Sweeping', name: 'accessBySweeping');

  String get dailyReport => Intl.message('Daily Report', name: 'dailyReport.json');

  String get healthCode => Intl.message('Health Code', name: 'healthCode');

  String get itinerary => Intl.message('Itinerary', name: 'itinerary');

  String get outbreakData => Intl.message('Outbreak Data', name: 'outbreakData');

  String get outbreakNews => Intl.message('Outbreak News', name: 'outbreakNews');

  String get communityBulletin => Intl.message('Community Bulletin', name: 'communityBulletin');

  String get other => Intl.message('Other', name: 'other');

  String get greenCode => Intl.message('Green Code', name: 'greenCode');

  String get yellowCode => Intl.message('Yellow Code', name: 'yellowCode');

  String get redCode => Intl.message('Red Code', name: 'redCode');

  String get loginRequest => Intl.message('Please login to your account first', name: 'loginRequest');

  // 我的
  String get myInfo => Intl.message('My Information', name: 'myInfo');

  String get authentication => Intl.message('Real-name authentication', name: 'authentication');

  String get unAuthentication => Intl.message('unAuthentication', name: 'unAuthentication');

  //个人信息
  String get phone => Intl.message('Phone', name: 'phone');

  String get idCard => Intl.message('IdCard', name: 'idCard');

  String get name => Intl.message('Name', name: 'name');

  String get authenticate => Intl.message('Authenticate', name: 'authenticate');

  String get personInfo => Intl.message('Personal Information', name: 'personInfo');

  String get avatar => Intl.message('Personal Information', name: 'avatar');

  String get changeAvtar => Intl.message('Change Avatar', name: 'changeAvtar');

  String get QRCode => Intl.message('QR Code', name: 'QRCode');

  String get address => Intl.message('Address of residence', name: 'address');

  String get shootPhone => Intl.message('Shoot Phone', name: 'shootPhone');

  String get selectPhone => Intl.message('Select From Albums', name: 'selectPhone');

  String get confirmReplacement => Intl.message('Replace', name: 'confirmReplacement');

  String get noChoiceImage => Intl.message('Please select a picture', name: 'noChoiceImage');

  String get failChangeAvtar => Intl.message('Failed to change avatar', name: 'failChangeAvtar');

  String get successChangeAvtar => Intl.message('Succeed to change avatar', name: 'successChangeAvtar');

  String get noProvince => Intl.message('Province not selected', name: 'noProvince');

  String get noCity => Intl.message('City not selected', name: 'noCity');

  String get noArea => Intl.message('Area not selected', name: 'noArea');

  String get province => Intl.message('Province', name: 'province');

  String get city => Intl.message('City', name: 'city');

  String get area => Intl.message('Area', name: 'area');

  String get community => Intl.message('Community', name: 'community');

  String get fullAddress => Intl.message('Full Address', name: 'fullAddress');

  String get accountAndSecurity => Intl.message('Account and Security', name: 'accountAndSecurity');
}

//Locale代理类
class GmLocalizationsDelegate extends LocalizationsDelegate<GmLocalizations> {
  const GmLocalizationsDelegate();

  //是否支持某个Local
  @override
  bool isSupported(Locale locale) => ['en', 'zh'].contains(locale.languageCode);

  // Flutter会调用此类加载相应的Locale资源类
  @override
  Future<GmLocalizations> load(Locale locale) {
    //3
    return GmLocalizations.load(locale);
  }

  // 当Localizations Widget重新build时，是否调用load重新加载Locale资源.
  @override
  bool shouldReload(GmLocalizationsDelegate old) => false;
}
