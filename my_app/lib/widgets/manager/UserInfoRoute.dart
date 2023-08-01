import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/common/funs.dart';
import 'package:my_app/models/index.dart';
import 'package:provider/provider.dart';

import '../../common/Network.dart';
import '../../l10n/localization_intl.dart';
import '../../states/profile_change_notifier.dart';

class UserInfoRoute extends StatefulWidget {
  const UserInfoRoute(this.user, {super.key});

  final User user;

  @override
  State<StatefulWidget> createState() => UserInfoRouteState();
}

class UserInfoRouteState extends State<UserInfoRoute> {
  var _userModel;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idCardController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  var _avtar = '';
  var _gender = 0;
  var _manager = 0;
  var _health = 0;

  @override
  void initState() {
    super.initState();
    _userModel = Provider.of<UserModel>(context, listen: false);
    _avtar = widget.user.avatar ?? '';
    _phoneController.text = widget.user.userPhone;
    _nameController.text = widget.user.userName ?? '';
    _gender = int.parse(widget.user.userGender ?? '0');
    String idCard = widget.user.userIdcard ?? '';
    _idCardController.text = idCard;
    _ageController.text =
        idCard == '' ? '' : "${idCard.substring(6, 10)}年${idCard.substring(10, 12)}月${idCard.substring(12, 14)}日";
    _addressController.text = widget.user.userAddress ?? '';
    _manager = int.parse(widget.user.manager ?? '0');
    _health = int.parse(widget.user.health ?? '0');

    print("_health=$_health");
  }

  @override
  Widget build(BuildContext context) {
    var gm = GmLocalizations.of(context);
    var flag = MediaQuery.of(context).size.width < 730;

    return Scaffold(
      appBar: AppBar(title: Text("详细信息")),
      body: Container(
        alignment: Alignment.topCenter,
        margin: EdgeInsets.all(10),
        // width: MediaQuery.of(context).size.width > 730 ? 370 : MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    Icon(Icons.account_circle_outlined, size: 25),
                    const SizedBox(width: 15),
                    Text("头像"),
                    const SizedBox(width: 20),
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
                              child: Image.network("${Network.baseUrl}$_avtar",
                                  errorBuilder: (buildContext, object, stackTrace) {
                                return Image.asset('assets/images/defaultUser.png', scale: 0.5);
                              }),
                            ),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 30,
                        foregroundColor: Colors.transparent,
                        foregroundImage: NetworkImage("${Network.baseUrl}$_avtar"),
                        onForegroundImageError: (object, stasckTrace) {
                          // showLog("mine_widget", " 头像加载失败");
                        },
                        child: Image.asset('assets/images/defaultUser.png'),
                      ),
                    ),
                  ],
                ),
              ),
              TextFormField(
                  enabled: false,
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: gm.phone,
                    hintText: gm.phone,
                    prefixIcon: Icon(Icons.phone),
                  ),
                  validator: (v) {
                    return v == null || v.trim().isNotEmpty ? null : gm.userNameRequired;
                  }),
              TextFormField(
                // enabled: false,
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: gm.name,
                  hintText: gm.name,
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (v) {
                  return v == null || v.trim().isNotEmpty ? null : gm.userNameRequired;
                },
              ),
              TextFormField(
                  controller: _idCardController,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: gm.idCard,
                    hintText: gm.idCard,
                    prefixIcon: Image.asset('assets/images/idcard.png'),
                  ),
                  validator: (v) {
                    return v == null || v.trim().isNotEmpty ? null : gm.userNameRequired;
                  }),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    Image.asset('assets/images/gender.png', width: 18),
                    const SizedBox(width: 20),
                    const Text("性别"),
                    const SizedBox(width: 10),
                    DropdownButton(
                      value: _gender,
                      items: const [
                        DropdownMenuItem(value: 0, child: Text(' 男 ')),
                        DropdownMenuItem(value: 1, child: Text(' 女 ')),
                      ],
                      // onChanged: (value) => setState(() => _gender = value!),
                      onChanged: null,
                    ),
                  ],
                ),
              ),
              TextFormField(
                controller: _ageController,
                enabled: false,
                decoration: InputDecoration(
                  labelText: '年龄',
                  hintText: '年龄',
                  prefixIcon: Image.asset('assets/images/age.png'),
                ),
                validator: (v) {
                  return v == null || v.trim().isNotEmpty ? null : gm.userNameRequired;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: gm.address,
                  hintText: gm.address,
                  prefixIcon: Icon(Icons.account_balance_outlined),
                ),
                validator: (v) {
                  return v == null || v.trim().isNotEmpty ? null : gm.userNameRequired;
                },
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 15),
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    Image.asset('assets/images/manager.png', width: 18),
                    const SizedBox(width: 10),
                    Text("社区管理员"),
                    const SizedBox(width: 20),
                    Row(children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio(value: 1, groupValue: _manager, onChanged: (v) => setState(() => _manager = v!)),
                          Text("是")
                        ],
                      ),
                      const SizedBox(width: 10),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio(value: 0, groupValue: _manager, onChanged: (v) => setState(() => _manager = v!)),
                          Text("否")
                        ],
                      ),
                    ]),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 15),
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    Image.asset('assets/images/level.png', width: 18),
                    const SizedBox(width: 10),
                    Text("风险等级"),
                    const SizedBox(width: 20),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio(value: 0, groupValue: _health, onChanged: (v) => setState(() => _health = v!)),
                        Text("一级", style: TextStyle(color: Colors.green))
                      ],
                    ),
                    const SizedBox(width: 10),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio(value: 1, groupValue: _health, onChanged: (v) => setState(() => _health = v!)),
                        Text("二级", style: TextStyle(color: Colors.orange))
                      ],
                    ),
                    const SizedBox(width: 10),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio(value: 2, groupValue: _health, onChanged: (v) => setState(() => _health = v!)),
                        Text("三级", style: TextStyle(color: Colors.red))
                      ],
                    ),
                  ],
                ),
              ),
              Center(
                child: FilledButton(
                  onPressed: _updateUser,
                  child: Text('      修   改      '),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _updateUser() async {
    if (_userModel.user?.userPhone == _phoneController.text.trim()) {
      showToast('管理员禁止修改自己信息！');
      return;
    }
    User user = widget.user;
    user.userAddress = _addressController.text.trim();
    user.manager = '$_manager';
    user.health = '$_health';
    // print(user);
    User? result = await Network(context).updateUser(user);
    if (result != null) {
      showToast('修改成功');
    } else {
      showToast('修改失败');
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
