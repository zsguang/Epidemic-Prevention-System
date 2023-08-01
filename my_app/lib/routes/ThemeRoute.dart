import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/Global.dart';
import '../l10n/localization_intl.dart';
import '../states/profile_change_notifier.dart';

class ThemeRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(GmLocalizations.of(context).theme),
      ),
      body: ThemePage(),
    );
  }
}

class ThemePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      //显示主题色块
      children: Global.themes.map<Widget>((e) {
        return GestureDetector(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
            child: Container(
              color: e,
              height: 40,
            ),
          ),
          onTap: () {
            //主题更新后，MaterialApp会重新build
            Provider.of<ThemeModel>(context, listen: false).theme = e;
          },
        );
      }).toList(),
    );
  }
}
