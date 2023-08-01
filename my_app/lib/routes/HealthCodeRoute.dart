import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_app/widgets/common/ClockWidget.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../l10n/localization_intl.dart';
import '../states/profile_change_notifier.dart';

class HealthCodeRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HealthCodeRouteState();
}

class HealthCodeRouteState extends State<HealthCodeRoute> {
  String time = '';

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var minSize = min(size.width, size.height);
    var gm = GmLocalizations.of(context);
    ThemeModel themeModel = Provider.of<ThemeModel>(context);
    return Scaffold(
      appBar: AppBar(title: Text(gm.healthCode)),
      body: Consumer<UserModel>(
        builder: (context, userModel, child) {
          var codeColor = _getColor(userModel);
          return Container(
            decoration: BoxDecoration(
              color: themeModel.theme.withOpacity(0.3),
            ),
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
                child: Container(
              width: size.width,
              child: Column(
                children: [
                  Card(
                    elevation: 8.0,
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    child: SizedBox(
                      width: minSize * 0.8,
                      height: minSize * 0.95,
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          ClockWidget(),
                          const SizedBox(height: 10),
                          Text(
                            _getCode(userModel, gm),
                            style: TextStyle(color: codeColor, fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          QrImage(
                            size: minSize * 0.7,
                            backgroundColor: Colors.white,
                            foregroundColor: codeColor,
                            data: userModel.user.toString(),
                            errorStateBuilder: (context, object) => const Icon(Icons.qr_code_2_sharp),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )),
          );
        },
      ),
    );
  }

  String _getCode(UserModel userModel, GmLocalizations gm) {
    switch (userModel.user?.health) {
      case '0':
        return gm.greenCode;
      case '1':
        return gm.yellowCode;
      case '2':
        return gm.redCode;
      default:
        return '';
    }
  }

  Color _getColor(UserModel userModel) {
    if (userModel.user?.health == '0') {
      return Colors.green;
    } else if (userModel.user?.health == '1') {
      return Colors.orange;
    } else if (userModel.user?.health == '2') {
      return Colors.red;
    } else {
      return Colors.black;
    }
  }
}
