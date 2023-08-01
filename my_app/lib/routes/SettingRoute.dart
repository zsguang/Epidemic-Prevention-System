import 'package:flutter/material.dart';
import 'package:my_app/routes/AccountRoute.dart';
import 'package:my_app/routes/LanguageRoute.dart';
import 'package:my_app/routes/ThemeRoute.dart';
import 'package:provider/provider.dart';

import '../l10n/localization_intl.dart';
import '../states/profile_change_notifier.dart';

class SettingRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingRouteState();
}

class _SettingRouteState extends State<SettingRoute> {
  Widget rightPage = AccountPage();
  bool routeFlag = false;

  @override
  Widget build(BuildContext context) {
    var gm = GmLocalizations.of(context);
    routeFlag = MediaQuery.of(context).size.width < 730;

    return Scaffold(
      appBar: AppBar(title: Text(gm.setting)),
      body: Row(children: [
        Container(
          margin: EdgeInsets.only(bottom: 10),
          width: routeFlag ? MediaQuery.of(context).size.width : 370,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    _BarWidget(
                      text: gm.accountAndSecurity,
                      onPress: () => routeOrPage(routeFlag ? _accountRoute : _accountPage),
                    ),
                    _BarWidget(
                      text: gm.theme,
                      onPress: () => routeOrPage(routeFlag ? _themeRoute : _themePage),
                    ),
                    _BarWidget(
                      text: gm.language,
                      onPress: () => routeOrPage(routeFlag ? _languageRoute : _languagePage),
                    ),
                  ],
                ), // 其他的 widget
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: routeFlag ? MediaQuery.of(context).size.width / 2 : 370 / 2,
                  child: FilledButton(onPressed: _logout, child: Text(gm.logout, style: TextStyle(fontSize: 20))),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: routeFlag ? 0 : MediaQuery.of(context).size.width - 370,
          child: rightPage,
        )
      ]),
    );
  }

  static const _accountRoute = 1;
  static const _accountPage = 2;
  static const _themeRoute = 3;
  static const _themePage = 4;
  static const _languageRoute = 5;
  static const _languagePage = 6;

  void routeOrPage(int page) {
    switch (page) {
      case _accountRoute:
        Navigator.of(context).pushNamed("account");
        break;
      case _accountPage:
        setState(() {
          rightPage = AccountPage();
        });
        break;
      case _themeRoute:
        Navigator.of(context).pushNamed("themes");
        break;
      case _themePage:
        setState(() {
          rightPage = ThemePage();
        });
        break;
      case _languageRoute:
        Navigator.of(context).pushNamed("language");
        break;
      case _languagePage:
        setState(() {
          rightPage = LanguagePage();
        });
        break;
    }
  }

  void _logout() {
    Provider.of<UserModel>(context, listen: false).user = null;
    Navigator.of(context).pop();
  }
}

class _BarWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPress;

  const _BarWidget({super.key, required this.text, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        splashColor: Colors.grey.withOpacity(0.5),
        highlightColor: Colors.transparent,
        onTap: onPress,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          child: Row(children: [
            const SizedBox(width: 8),
            Text(text, style: TextStyle(fontSize: 18)),
            Expanded(child: Container()),
            const Icon(Icons.navigate_next, size: 30),
          ]),
        ),
      ),
    );
  }
}
