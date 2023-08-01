import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_app/common/Network.dart';
import 'package:my_app/l10n/localization_intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../states/profile_change_notifier.dart';

class MineWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MineWidgetState();
}

class _MineWidgetState extends State<MineWidget> {
  late UserModel _userModel;

  @override
  void initState() {
    super.initState();
    _userModel = Provider.of<UserModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    GmLocalizations gm = GmLocalizations.of(context);
    // _userModel = Provider.of<UserModel>(context);
    return _userModel.user == null
        ? Center(
            child: TextButton(
              onPressed: () => Navigator.of(context).pushNamed("login"),
              child: Text(gm.login, style: const TextStyle(fontSize: 20)),
            ),
          )
        : SingleChildScrollView(
            child: Consumer<UserModel>(
              builder: (context, userModel, child) {
                _userModel = userModel;
                return Container(
                  padding: EdgeInsets.all(5),
                  width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height,
                  // color: const Color.fromARGB(15, 138, 138, 138),
                  // color: Colors.white,
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(4),
                          child: CircleAvatar(
                            radius: 45,
                            foregroundColor: Colors.transparent,
                            foregroundImage: NetworkImage("${Network.baseUrl}${userModel.user?.avatar}"),
                            onForegroundImageError: (object, stasckTrace) {
                              // showLog("mine_widget", " 头像加载失败");
                            },
                            child: Image.asset('assets/images/defaultUser.png'),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: _InfoWidget(),
                        ),
                        Expanded(child: Container()),
                        InkWell(
                          onTap: () {
                            var pingSize = MediaQuery.of(context).size;
                            var size = min(pingSize.width, pingSize.height) * 0.618;
                            showDialog(
                              context: context,
                              builder: (BuildContext dialogContext) => AlertDialog(
                                content: SizedBox(
                                  width: size,
                                  height: size,
                                  child: QrImage(
                                    data: userModel.user.toString(),
                                    // size: 200.0,
                                    embeddedImage: NetworkImage("${Network.baseUrl}${userModel.user?.avatar}"),
                                    errorStateBuilder: (context, object) => const Icon(Icons.qr_code_2_sharp),
                                  ),
                                ),
                              ),
                            );
                          },
                          child: const Icon(Icons.qr_code_2_sharp, size: 70),
                        ),
                      ],
                    ),
                    _BarWidget(
                      image: Icons.account_circle_outlined,
                      text: gm.personInfo,
                      onPress: () => Navigator.of(context).pushNamed("information"),
                    ),
                    // const Divider(height: 1, color: Colors.black12),
                    _BarWidget(
                      image: Icons.credit_card,
                      text: gm.authentication,
                      onPress: () => Navigator.of(context).pushNamed("authenticate"),
                    ),
                    _BarWidget(
                      image: Icons.settings,
                      text: gm.setting,
                      onPress: () => Navigator.of(context).pushNamed("setting"),
                    ),
                  ]),
                );
              },
            ),
          );
  }

}

class _InfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GmLocalizations gm = GmLocalizations.of(context);
    UserModel userModel = Provider.of<UserModel>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${userModel.user?.userPhone}",
          style: const TextStyle(fontSize: 23),
        ),
        SizedBox(height: 10.0),
        (userModel.user == null || userModel.user!.userName == null || userModel.user!.userName == "")
            ? Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.red,
                  ),
                  borderRadius: BorderRadius.circular(2.0),
                ),
                child: Text(
                  gm.unAuthentication,
                  style: TextStyle(color: Colors.red),
                ))
            : Text(
                "${userModel.user?.userName}",
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 23),
              ),
      ],
    );
  }
}

class _BarWidget extends StatelessWidget {
  final IconData image;
  final String text;
  final VoidCallback onPress;

  const _BarWidget({super.key, required this.image, required this.text, required this.onPress});

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
          height: 70,
          child: Row(children: [
            Icon(image, size: 30),
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
