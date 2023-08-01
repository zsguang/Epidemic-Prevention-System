import 'package:flutter/material.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:intl/intl.dart';

import '../../common/Network.dart';
import '../../common/funs.dart';
import '../../models/access.dart';
import '../../models/community.dart';
import '../../models/district.dart';
import '../../models/user.dart';

class ScannerUserRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ScannerUserRouteState();
}

class ScannerUserRouteState extends State<ScannerUserRoute> {
  List<Community> _communityList = [];
  int _communityIndex = 0;
  List<District> _districtList = [];
  int _districtIndex = 0;
  final List<_InsertUser> _insertList = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("扫码进入")),
      body: Container(
        alignment: Alignment.topCenter,
        margin: const EdgeInsets.all(10),
        // width: MediaQuery.of(context).size.width > 730 ? 370 : MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.account_balance_outlined),
                  const SizedBox(width: 10),
                  const Text("社区：", style: TextStyle(fontSize: 16)),
                  DropdownButton(
                    // key: UniqueKey(),
                    value: _communityIndex,
                    items: _communityList.map((Community community) {
                      return DropdownMenuItem(
                        value: _communityList.indexOf(community),
                        child: Text(community.communityName),
                      );
                    }).toList(),
                    onChanged: (int? value) async {
                      if (_communityIndex != value!) _districtIndex = 0;
                      _communityIndex = value;
                      _districtList =
                          await Network(context).getDistrictList(_communityList[_communityIndex].communityId) ??
                              [];
                      setState(() {});
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/images/district.png',
                    width: 24,
                  ),
                  const SizedBox(width: 10),
                  const Text("小区：", style: TextStyle(fontSize: 16)),
                  DropdownButton(
                    // key: UniqueKey(),
                    value: _districtIndex,
                    items: _districtList.map((District district) {
                      return DropdownMenuItem(
                        value: _districtList.indexOf(district),
                        child: Text(district.districtName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _districtIndex = value!;
                      });
                    },
                  )
                ],
              ),
              SizedBox(
                width: 150,
                child: FilledButton(
                  onPressed: _beginScanner,
                  child: const Text("开 始 扫 码", style: TextStyle(fontSize: 16)),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                height: MediaQuery.of(context).size.height - 260,
                child: ListView(
                  padding: EdgeInsets.all(0),
                  children: _insertList.map((_InsertUser item) {
                    return Text(
                      "${item.time}   ${item.user.userName}   ${item.user.userPhone.replaceRange(3, null, '*********')}",
                      style: TextStyle(fontSize: 16),
                    );
                  }).toList(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loadData() async {
    _communityList = await Network(context).getCommunityList('') ?? [];
    _districtList = await Network(context).getDistrictList(_communityList[_communityIndex].communityId) ?? [];
    setState(() {});
  }

  Future<void> _beginScanner() async {
    if (_communityList.isEmpty || _districtList.isEmpty) {
      showToast('未选择小区');
    }
    _scanQrcode();
  }

  void _scanQrcode() async {
    final scanner = QrBarCodeScannerDialog();
    scanner.getScannedQrBarCode(
      context: context,
      onCode: (String? code) async {
        showLog("home_widget", "QrCode = $code");

        User? user;
        try {
          user = User.fromString(code);
        } catch (e) {
          showToast('二维码错误');
        }
        String time = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

        Access access = Access();
        access.accessTime = time;
        access.outProvince = '0';
        access.userPhone = user!.userPhone;
        access.districtId = _districtList[_districtIndex].districtId!;

        bool result = await Network(context).addAccess(access);
        if (result) _insertList.insert(0, _InsertUser(user, time.substring(5, 16)));
        showResultDialog(result);
        await Future.delayed(const Duration(seconds: 1), () {
          Navigator.of(context).pop();
        });
        setState(() {});
        _scanQrcode();
      },
    );
  }

  void showResultDialog(bool result) {
    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.only(top: 15, bottom: 2),
          content: Container(
            height: 200,
            width: 100,
            child: Column(
              children: [
                result
                    ? Image.asset('assets/images/success.png', height: 100)
                    : Image.asset('assets/images/failure.png', height: 100),
                const SizedBox(height: 20),
                Text(result ? '信息已记录' : '信息录入失败'),
                // Expanded(child: Container()),
                // SizedBox(
                //   width: 245,
                //   child: TextButton(
                //     onPressed: () => Navigator.of(context).pop(),
                //     child: Text("确  定", style: TextStyle(fontSize: 18)),
                //   ),
                // )
              ],
            ),
          ),
        );
      },
    );
  }
}

class _InsertUser {
  final User user;
  final String time;

  _InsertUser(this.user, this.time);
}
