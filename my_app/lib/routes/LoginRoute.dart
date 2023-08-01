import 'package:flutter/material.dart';
import 'package:my_app/models/index.dart';
import 'package:provider/provider.dart';

import '../common/Network.dart';
import '../common/Global.dart';
import '../common/funs.dart';
import '../l10n/localization_intl.dart';
import '../states/profile_change_notifier.dart';

class LoginRoute extends StatefulWidget {
  @override
  _LoginRouteState createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  final TextEditingController _unameController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  bool pwdShow = false;
  final GlobalKey _formKey = GlobalKey<FormState>();
  bool _nameAutoFocus = true;

  @override
  void initState() {
    // 自动填充上次登录的用户名，填充后将焦点定位到密码输入框
    _unameController.text = Global.profile.lastLogin ?? "";
    if (_unameController.text.isNotEmpty) {
      _nameAutoFocus = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var gm = GmLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(gm.login)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: <Widget>[
              TextFormField(
                autofocus: _nameAutoFocus,
                controller: _unameController,
                decoration: InputDecoration(
                  labelText: gm.phone,
                  hintText: gm.phone,
                  prefixIcon: Icon(Icons.person),
                ),
                // 校验用户名（不能为空）
                validator: (v) {
                  return v == null || v.trim().isNotEmpty ? null : gm.userNameRequired;
                },
              ),
              TextFormField(
                autofocus: !_nameAutoFocus,
                controller: _pwdController,
                decoration: InputDecoration(
                  labelText: gm.password,
                  hintText: gm.password,
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(pwdShow ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        pwdShow = !pwdShow;
                      });
                    },
                  ),
                ),
                obscureText: !pwdShow,
                //校验密码（不能为空）
                validator: (v) {
                  return v == null || v.trim().isNotEmpty ? null : gm.passwordRequired;
                },
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.topRight,
                margin: const EdgeInsets.only(top: 20, right: 10),
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pushNamed('register'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                  ),
                  child: Text(gm.registerMessage),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: ConstrainedBox(
                  constraints: BoxConstraints.expand(height: 55.0),
                  child: ElevatedButton(
                    onPressed: _onLogin,
                    child: Text(gm.login, style: TextStyle(fontSize: 18)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onLogin() async {
    if ((_formKey.currentState as FormState).validate()) {
      showLoading(context);
      ResultObject? result;
      try {
        result = await Network(context).login(_unameController.text, _pwdController.text);
        // showLog("LoginRoute", "result.json.data = ${result.json?.data}");
        if (result?.code == "-1") {
          // showToast(GmLocalizations.of(context).userPhoneOrPasswordWrong);
          showToast(GmLocalizations.of(context).userPhoneOrPasswordWrong);
          return;
        }
        User? user;
        if (result != null && result.data != null) user = User.fromJson(result.data!);
        // 因为登录页返回后，首页会build，所以传false，更新user后不触发更新
        Provider.of<UserModel>(context, listen: false).user = user;
      } on DioError catch (e) {
        // showToast(e.toString());
        showToast(e.toString(), time: 3);
      } finally {
        // 隐藏loading框
        Navigator.of(context).pop();
      }
      //登录成功则返回
      if (result != null) {
        Navigator.of(context).pop();
      }
    }
  }
}
