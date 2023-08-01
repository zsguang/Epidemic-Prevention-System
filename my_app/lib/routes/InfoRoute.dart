import 'package:flutter/material.dart';
import 'package:my_app/common/Network.dart';
import 'package:my_app/common/funs.dart';
import 'package:my_app/routes/AvtarRoute.dart';
import 'package:my_app/routes/QRCodeRoute.dart';
import 'package:provider/provider.dart';

import '../l10n/localization_intl.dart';
import '../states/profile_change_notifier.dart';
import 'AddressRoute.dart';

class InfoRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _InfoRouteRouteState();
}

class _InfoRouteRouteState extends State<InfoRoute> {
  Widget rightPage = AvtarPage();
  String community = "";
  bool flag = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var gm = GmLocalizations.of(context);
    // var userModel = Provider.of<UserModel>(context);
    flag = MediaQuery.of(context).size.width < 730;

    return ChangeNotifierProvider(
      create: (context) => UserModel(),
      child: Consumer<UserModel>(builder: (context, userModel, child) {
        // getCommunity(userModel);
        return Scaffold(
          appBar: AppBar(title: Text(gm.personInfo)),
          body: Row(
            children: [
              Container(
                alignment: Alignment.topCenter,
                width: MediaQuery.of(context).size.width > 730 ? 370 : MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _BarWidget(
                        text: gm.avatar,
                        onPress: () => routeOrPage(flag ? _avtarRoute : _avtarPage),
                        widget: CircleAvatar(
                          radius: 30,
                          foregroundColor: Colors.transparent,
                          foregroundImage: NetworkImage("${Network.baseUrl}${userModel.user?.avatar}"),
                          onForegroundImageError: (object, stasckTrace) {
                            // showLog("mine_widget", " 头像加载失败");
                          },
                          child: Image.asset('assets/images/defaultUser.png'),
                        ),
                      ),
                      const Divider(height: 1, color: Color.fromARGB(30, 175, 175, 175)),
                      _BarWidget(
                        text: gm.QRCode,
                        onPress: () => routeOrPage(flag ? _qrCodeRoute : _qrCodePage),
                        widget: const Icon(Icons.qr_code_2, size: 30),
                      ),
                      const Divider(height: 1, color: Color.fromARGB(30, 175, 175, 175)),
                      _BarWidget(
                        text: gm.name,
                        onPress: null,
                        widget: Text("${userModel.user?.userName}", style: TextStyle(fontSize: 18)),
                      ),
                      const Divider(height: 1, color: Color.fromARGB(30, 175, 175, 175)),
                      _BarWidget(
                        text: gm.phone,
                        onPress: null,
                        widget: Text(
                          // "${userModel.user?.userPhone.substring(0, 3)}******${userModel.user?.userPhone.substring(9, 11)}",
                          "${userModel.user?.userPhone}",
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      const Divider(height: 1, color: Color.fromARGB(30, 175, 175, 175)),
                      _BarWidget(
                        text: gm.idCard,
                        onPress: null,
                        widget: Text(
                          userModel.user?.userIdcard == null || userModel.user?.userIdcard == ''
                              ? ""
                              : "${userModel.user?.userIdcard?.substring(0, 4)}************${userModel.user?.userIdcard?.substring(16, 18)}",
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      const Divider(height: 1, color: Color.fromARGB(30, 175, 175, 175)),
                      _BarWidget(
                        text: gm.address,
                        onPress: () => routeOrPage(flag ? _addressRoute : _addressPage),
                        widget: Text(
                          // userModel.user?.userAddress?.substring(30) ?? '',
                          '',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topCenter,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width > 730 ? MediaQuery.of(context).size.width - 370 : 0,
                child: rightPage,
              )
            ],
          ),
        );
      }),
    );
  }

  Future<void> getAvtarImage(UserModel userModel) async {
    Future(() {
      setState(() {
        // avtarImage = NetworkImage("${Network.baseUrl}${userModel.user?.avatar}");
      });
    });
  }

  // Future<void> getCommunity(UserModel userModel) async {
  //   // String? communityName = await Network(context).getCommunityName("${userModel.user!.userCommunity}");
  //   String communityName = userModel.user!.district?.communityName ?? '';
  //   // showLog("Network", "communityName = ${communityName}");
  //   if (communityName != null) {
  //     setState(() {
  //       community = communityName;
  //     });
  //   }
  // }

  static const _avtarRoute = 0;
  static const _qrCodeRoute = 1;
  static const _addressRoute = 2;
  static const _avtarPage = 3;
  static const _qrCodePage = 4;
  static const _addressPage = 5;

  void routeOrPage(int page) {
    switch (page) {
      case _avtarRoute:
        Navigator.of(context).pushNamed("avtar");
        break;
      case _avtarPage:
        setState(() {
          rightPage = AvtarPage();
        });
        break;
      case _qrCodeRoute:
        Navigator.of(context).pushNamed("QRCode");
        break;
      case _qrCodePage:
        setState(() {
          rightPage = QRCodePage();
        });
        break;
      case _addressRoute:
        Navigator.of(context).pushNamed("address");
        break;
      case _addressPage:
        setState(() {
          rightPage = AddressPage();
        });
        break;
    }
  }
}

class _BarWidget extends StatelessWidget {
  final String text;
  final Widget? widget;
  final VoidCallback? onPress;

  const _BarWidget({super.key, required this.text, required this.onPress, this.widget});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        splashColor: Colors.grey.withOpacity(0.5),
        highlightColor: Colors.transparent,
        onTap: onPress,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          width: MediaQuery.of(context).size.width,
          child: Row(children: [
            Text(text, style: TextStyle(fontSize: 18)),
            Expanded(child: Container(height: 50)),
            widget ?? SizedBox(),
            onPress == null ? const SizedBox(width: 30) : const Icon(Icons.navigate_next, size: 30),
          ]),
        ),
      ),
    );
  }
}
