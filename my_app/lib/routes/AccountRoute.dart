import 'package:flutter/material.dart';

import '../l10n/localization_intl.dart';

class AccountRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var gm = GmLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(gm.accountAndSecurity)),
      body: AccountPage(),
    );
  }
}

class AccountPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _BarWidget(
        text: '修改密码',
        onPress: (){},
      ),
      _BarWidget(
        text: '注销账号',
        onPress: (){},
      ),
    ]);
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
