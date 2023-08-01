import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/common/Network.dart';
import 'package:my_app/common/funs.dart';
import 'package:my_app/models/access.dart';
import 'package:my_app/models/district.dart';
import 'package:provider/provider.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';

import '../l10n/localization_intl.dart';
import '../models/bulletin.dart';
import '../states/profile_change_notifier.dart';

class HomeWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  late GmLocalizations gm;
  late UserModel _userModel;
  late List<Widget> _imageButtons;
  Bulletin? _latestBulletin;

  @override
  void initState() {
    super.initState();
    _userModel = Provider.of<UserModel>(context, listen: false);
    _getLatestBulletin();
  }

  @override
  Widget build(BuildContext context) {
    _initData(context, _userModel);
    Size size = MediaQuery.of(context).size;
    showLog('home_widget', '${size.width / 2}');
    return SingleChildScrollView(
      child: size.width > 760
          ? Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: size.width / 2,
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/notice.png',
                            fit: BoxFit.cover,
                            width: size.width / 2,
                          ),
                          InkWell(
                            onTap: () => Navigator.of(context)
                                .pushNamed("bulletinInfo", arguments: {'bulletin': _latestBulletin}),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              height: 45,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.amberAccent,
                              child: Text("公告:《${_latestBulletin?.noticeTitle ?? ''}》",
                                  style: const TextStyle(fontSize: 18)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: size.width / 2,
                      padding: EdgeInsets.all(5),
                      child: Column(
                        children: [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                            _ImageButtonX(
                              text: gm.accessBySweeping,
                              width: size.width / 2.0,
                              image: Icons.qr_code_scanner,
                              onPressed: () {
                                if (_userModel.user == null) {
                                  showToast("请先登录账号");
                                  return;
                                }
                                _scanQrcode();
                              },
                            ),
                            _ImageButtonX(
                              text: gm.dailyReport,
                              width: size.width / 2.0,
                              image: Icons.report,
                              onPressed: () {
                                if (_userModel.user == null) {
                                  showToast("请先登录账号");
                                  return;
                                }
                                Navigator.of(context).pushNamed("dailyReport");
                              },
                            ),
                            // ElevatedButton(
                          ]),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            width: MediaQuery.of(context).size.width,
                            color: Colors.white,
                            child: size.width / 2 > 380
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: _imageButtons.sublist(0, 3),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: _imageButtons.sublist(3, 6),
                                      ),
                                    ],
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: _imageButtons.sublist(0, 2),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: _imageButtons.sublist(2, 4),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: _imageButtons.sublist(4, 6),
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Image.asset(
                  'assets/images/image2.png',
                  fit: BoxFit.fitWidth,
                  width: MediaQuery.of(context).size.width,
                )
              ],
            )
          : Container(
              width: MediaQuery.of(context).size.width,
              color: const Color.fromARGB(15, 134, 134, 134),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    'assets/images/notice.png',
                    fit: BoxFit.cover,
                    width: 500,
                  ),
                  InkWell(
                    onTap: () =>
                        Navigator.of(context).pushNamed("bulletinInfo", arguments: {'bulletin': _latestBulletin}),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      height: 45,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.amberAccent,
                      child:
                          Text("公告:《${_latestBulletin?.noticeTitle ?? ''}》", style: const TextStyle(fontSize: 18)),
                    ),
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                    _ImageButtonX(
                      text: gm.accessBySweeping,
                      width: size.width,
                      image: Icons.qr_code_scanner,
                      onPressed: () {
                        if (_userModel.user == null) {
                          showToast("请先登录账号");
                          return;
                        }
                        _scanQrcode();
                      },
                    ),
                    _ImageButtonX(
                      text: gm.dailyReport,
                      width: size.width,
                      image: Icons.report,
                      onPressed: () {
                        if (_userModel.user == null) {
                          showToast("请先登录账号");
                          return;
                        }
                        Navigator.of(context).pushNamed("dailyReport");
                      },
                    ),
                    // ElevatedButton(
                  ]),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: MediaQuery.of(context).size.width > 600
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: _imageButtons,
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: _imageButtons.sublist(0, 3),
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: _imageButtons.sublist(3, 6)),
                            ],
                          ),
                  ),
                  Image.asset(
                    'assets/images/image2.png',
                    fit: BoxFit.fitWidth,
                    width: MediaQuery.of(context).size.width,
                  )
                ],
              ),
            ),
    );
  }

  void _initData(BuildContext context, UserModel userModel) {
    gm = GmLocalizations.of(context);
    _imageButtons = <Widget>[
      _ImageButton(
          image: Icons.account_box_outlined,
          text: gm.healthCode,
          onPressed: () {
            if (userModel.user == null) {
              showToast(gm.loginRequest);
              return;
            }
            Navigator.of(context).pushNamed("healthCode");
          }),
      _ImageButton(
          image: Icons.sd_card_outlined,
          text: gm.itinerary, //行程
          onPressed: () {
            if (userModel.user == null) {
              showToast(gm.loginRequest);
              return;
            }
            Navigator.of(context).pushNamed("itinerary");
          }),
      _ImageButton(
          image: Icons.dataset_outlined,
          text: gm.outbreakData,
          onPressed: () => Navigator.of(context).pushNamed("outbreakData")),
      _ImageButton(
          image: Icons.newspaper,
          text: gm.outbreakNews,
          onPressed: () => Navigator.of(context).pushNamed("outbreakNews")),
      _ImageButton(
          image: Icons.format_list_bulleted,
          text: gm.communityBulletin,
          onPressed: () => Navigator.of(context).pushNamed("bulletin")),
      _ImageButton(image: Icons.add_box_outlined, text: gm.other, onPressed: () {}),
    ];
  }

  void _scanQrcode() async {
    final scanner = QrBarCodeScannerDialog();
    scanner.getScannedQrBarCode(
      context: context,
      onCode: (String? code) async {
        showLog("home_widget", "QrCode = $code");

        District? district;
        try {
          district = District.fromString(code);
        } catch (e) {
          showToast('二维码错误');
        }
        String time = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

        Access access = Access();
        access.accessTime = time;
        access.outProvince = '0';
        access.userPhone = _userModel.user!.userPhone;
        access.districtId = district!.districtId!;
        bool result = await Network(context).addAccess(access);
        showResultDialog(result);
      },
    );
  }

  void showResultDialog(bool? flag) {
    bool result = flag != null && flag;
    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.only(top: 15, bottom: 2),
          content: Container(
            height: 250,
            width: 250,
            child: Column(
              children: [
                result
                    ? Image.asset('assets/images/success.png', height: 150)
                    : Image.asset('assets/images/failure.png'),
                const SizedBox(height: 10),
                Text(result ? '信息已记录' : '信息录入失败'),
                Expanded(child: Container()),
                SizedBox(
                  width: 245,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("确  定", style: TextStyle(fontSize: 18)),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _getLatestBulletin() async {
    Bulletin? bulletin = await Network(context).getLatestBulletin();
    if (bulletin != null) {
      setState(() {
        _latestBulletin = bulletin;
      });
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    _getLatestBulletin();
  }
}

class _ImageButton extends StatelessWidget {
  final IconData image;
  final String text;
  final Function onPressed;

  _ImageButton({super.key, required this.image, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: width > 600 ? width / 6.2 : width / 3.2,
        height: 100,
        child: Material(
          color: Colors.white,
          child: InkWell(
            onTap: () => onPressed(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(image, size: 55),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ImageButtonX extends StatelessWidget {
  final IconData image;
  final String text;
  final Function onPressed;
  final double width;

  const _ImageButtonX(
      {super.key, required this.image, required this.text, required this.onPressed, required this.width});

  @override
  Widget build(BuildContext context) {
    ThemeModel themeModel = Provider.of<ThemeModel>(context);
    // var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {},
      child: Material(
        color: Colors.white,
        child: InkWell(
          splashColor: Colors.grey.withOpacity(0.5),
          highlightColor: Colors.transparent,
          onTap: () => onPressed(),
          child: Container(
            // width: width < 730 ? width * 0.45 : width * 0.23,
            width: width * 0.45,
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(image, size: 60, color: themeModel.theme),
                SizedBox(
                  width: 110,
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
