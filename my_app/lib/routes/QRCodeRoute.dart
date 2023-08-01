import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/common/Network.dart';
import 'package:my_app/models/user.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../l10n/localization_intl.dart';
import '../states/profile_change_notifier.dart';

class QRCodeRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var gm = GmLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(gm.QRCode)),
      body: QRCodePage(),
    );
  }
}

class QRCodePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GmLocalizations gm = GmLocalizations.of(context);
    UserModel userModel = Provider.of<UserModel>(context);
    var size = MediaQuery.of(context).size;

    // print(userModel.user.toString());
    // print(User.fromString(userModel.user.toString()).toString());

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.center,
          child: QrImage(
            data: userModel.user.toString(),
            size: min(size.width, size.height) * 0.75,
            embeddedImage: NetworkImage("${Network.baseUrl}${userModel.user?.avatar}"),
          ),
        )
      ],
    );
  }
}
