import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/localization_intl.dart';
import '../states/profile_change_notifier.dart';

class LanguageRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var gm = GmLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(gm.language),
      ),
      body: LanguagePage(),
    );
  }
}

class LanguagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).primaryColor;
    var localeModel = Provider.of<LocaleModel>(context);
    var gm = GmLocalizations.of(context);
    Widget _buildLanguageItem(String lan, value) {
      return ListTile(
        title: Text(
          lan,
          style: TextStyle(color: localeModel.locale == value ? color : null),
        ),
        trailing: localeModel.locale == value ? Icon(Icons.done, color: color) : null,
        onTap: () {
          // 通知MaterialApp重新build
          localeModel.locale = value;
        },
      );
    }

    return ListView(
      children: <Widget>[
        _buildLanguageItem("中文简体", "zh_CN"),
        _buildLanguageItem("English", "en_US"),
        _buildLanguageItem(gm.auto, null),
      ],
    );
  }
}
