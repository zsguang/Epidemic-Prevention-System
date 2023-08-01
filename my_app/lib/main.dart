import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_app/models/index.dart';
import 'package:my_app/routes/AccountRoute.dart';
import 'package:my_app/routes/AddressRoute.dart';
import 'package:my_app/routes/AuthenticateRoute.dart';
import 'package:my_app/routes/AvtarRoute.dart';
import 'package:my_app/routes/BulletinPageRoute.dart';
import 'package:my_app/routes/BulletinRoute.dart';
import 'package:my_app/routes/DailyReportRoute.dart';
import 'package:my_app/routes/HealthCodeRoute.dart';
import 'package:my_app/routes/InfoRoute.dart';
import 'package:my_app/routes/ItineraryRoute.dart';
import 'package:my_app/routes/LanguageRoute.dart';
import 'package:my_app/routes/LoginRoute.dart';
import 'package:my_app/routes/NewsRoute.dart';
import 'package:my_app/routes/OutbreakDataRoute.dart';
import 'package:my_app/routes/OutbreakNewsRoute.dart';
import 'package:my_app/routes/QRCodeRoute.dart';
import 'package:my_app/routes/RegisterRoute.dart';
import 'package:my_app/routes/SettingRoute.dart';
import 'package:my_app/routes/ThemeRoute.dart';
import 'package:my_app/home_page.dart';
import 'package:my_app/states/profile_change_notifier.dart';
import 'package:provider/provider.dart';

import 'common/Global.dart';
import 'l10n/localization_intl.dart';

void main() async {
  Global.init().then((e) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeModel()),
        ChangeNotifierProvider(create: (_) => UserModel()),
        ChangeNotifierProvider(create: (_) => LocaleModel()),
      ],
      child: Consumer3<ThemeModel, LocaleModel,UserModel>(
        builder: (BuildContext context, themeModel, localeModel, userModel, child) {
          return MaterialApp(
            theme: ThemeData(
              primarySwatch: themeModel.theme,
            ),
            onGenerateTitle: (context) {
              return GmLocalizations.of(context).title;
            },
            builder: BotToastInit(),
            home: HomeRoute(),
            locale: localeModel.getLocale(),
            //只支持英语和中文简体
            supportedLocales: const [
              Locale('zh', 'CN'), // 中文简体
              Locale('en', 'US'), // 英语
              //其他Locales
            ],
            localizationsDelegates: const [
              // 本地化的代理类
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GmLocalizationsDelegate()
            ],
            localeResolutionCallback: (_locale, supportedLocales) {
              if (localeModel.getLocale() != null) {
                //如果已经选定语言，则不跟随系统
                return localeModel.getLocale();
              } else {
                //跟随系统
                Locale locale;
                if (supportedLocales.contains(_locale)) {
                  locale = _locale!;
                } else {
                  //如果系统语言不是中文简体或美国英语，则默认使用中文简体
                  locale = Locale('zh', 'CN');
                }
                return locale;
              }
            },
            // 注册路由表
            routes: <String, WidgetBuilder>{
              "login": (context) => LoginRoute(),
              "register": (context) => RegisterRoute(),
              "themes": (context) => ThemeRoute(),
              "language": (context) => LanguageRoute(),
              "dailyReport": (context) => DailyReportRoute(),
              "information": (context) => InfoRoute(),
              "authenticate": (context) => AuthenticateRoute(),
              "setting": (context) => SettingRoute(),
              "avtar": (context) => AvtarRoute(),
              "QRCode": (context) => QRCodeRoute(),
              "address": (context) => AddressRoute(),
              "account": (context) => AccountRoute(),
              "healthCode": (context) => HealthCodeRoute(),
              "itinerary": (context) => ItineraryRoute(),
              "outbreakData": (context) => OutbreakDataRoute(),
              "outbreakNews": (context) => OutbreakNewsRoute(),
              "bulletin": (context) => BulletinRoute(),
              "bulletinInfo": (context) => BulletinPageRoute(),
              "news": (context) => NewsRoute(),
            },
          );
        },
      ),
    );
  }
}
