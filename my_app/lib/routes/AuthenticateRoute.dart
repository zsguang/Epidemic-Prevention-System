import 'package:flutter/material.dart';
import 'package:my_app/common/funs.dart';
import 'package:provider/provider.dart';

import '../common/Network.dart';
import '../l10n/localization_intl.dart';
import '../states/profile_change_notifier.dart';

class AuthenticateRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AuthenticateRouteState();
}

class _AuthenticateRouteState extends State<AuthenticateRoute> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idCardController = TextEditingController();
  late UserModel userModel;
  final GlobalKey _formKey = GlobalKey<FormState>();
  var _isAuthentic = false;

  void _initData() {
    _phoneController.text = userModel.user?.userPhone ?? "";
    _nameController.text = userModel.user?.userName ?? "";

    if (userModel.user?.userIdcard != null && userModel.user!.userIdcard != '') {
      _idCardController.text =
      "${userModel.user?.userIdcard!.substring(0, 4) ?? ''}************${userModel.user!.userIdcard?.substring(
          16, 18) ?? ''}";
    }
    _isAuthentic = _idCardController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    userModel = Provider.of<UserModel>(context);
    _initData();
    var gm = GmLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(gm.authentication)),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(children: <Widget>[
            TextFormField(
                enabled: false,
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: gm.phone,
                  hintText: gm.phone,
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (v) {
                  return v == null || v
                      .trim()
                      .isNotEmpty ? null : gm.userNameRequired;
                }),
            TextFormField(
              enabled: !_isAuthentic,
              controller: _idCardController,
              decoration: InputDecoration(
                labelText: gm.idCard,
                hintText: gm.idCard,
                prefixIcon: Icon(Icons.credit_card_sharp),
              ),
              validator: (v) {
                RegExp regExp =
                RegExp(r'^[1-9]\d{5}(19|20)\d{2}((0[1-9])|(1[0-2]))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$');
                if (v == null || v
                    .trim()
                    .isEmpty) {
                  return gm.userNameRequired;
                } else if (!regExp.hasMatch(v)) {
                  return '身份证号不合法';
                }
                return null;
              },
            ),
            TextFormField(
                enabled: !_isAuthentic,
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: gm.userName,
                  hintText: gm.userName,
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (v) {
                  return v == null || v
                      .trim()
                      .isNotEmpty ? null : gm.userNameRequired;
                }),
            Container(
              margin: EdgeInsets.only(top: 30),
              height: 40,
              width: MediaQuery
                  .of(context)
                  .size
                  .width / 4,
              child: ElevatedButton(
                onPressed: _isAuthentic ? null : _onConfirm,
                child: Text(
                  gm.authenticate,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  void _onConfirm() async {
    if (!(_formKey.currentState as FormState).validate()) return;
    userModel.user!.userIdcard = _idCardController.text;
    userModel.user!.userName = _nameController.text;
    // print(userModel.user.toString());
    bool result = await Network(context).authentic(userModel.user!);
    if (result) {
      showToast('认证成功');
      setState(() {
        _isAuthentic = true;
      });
    }
  }
}
