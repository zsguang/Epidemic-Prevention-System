// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:my_app/common/Network.dart';
import 'package:my_app/common/funs.dart';
import 'package:my_app/models/index.dart';

import '../l10n/localization_intl.dart';
import '../widgets/common/city_picker.dart';

class RegisterRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterRouteState();
}

class _RegisterRouteState extends State<RegisterRoute> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pwd1Controller = TextEditingController();
  final TextEditingController _pwd2Controller = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _communityController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _fullAddressController = TextEditingController();

  List<Community> _communityList = [];
  List<District> _districtList = [];
  District? _selectDistrict;

  bool pwdShow = false;
  final GlobalKey _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _getCommunityList();
  }

  @override
  Widget build(BuildContext context) {
    var gm = GmLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(gm.register)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(children: <Widget>[
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: gm.phone,
                  hintText: gm.phone,
                  prefixIcon: const Icon(Icons.phone_android),
                ),
                // 校验用户名（不能为空）
                validator: (String? v) {
                  if (v == null || v.trim().isEmpty) return '手机号不能为空';
                  if (!RegExp(r'^1\d{10}$').hasMatch(v)) return '手机号码无效';
                  if (v.length != 11) return '手机号必须为11位';
                  return null;
                },
              ),
              TextFormField(
                controller: _pwd1Controller,
                decoration: InputDecoration(
                  labelText: gm.password,
                  hintText: gm.password,
                  prefixIcon: const Icon(Icons.lock),
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
                validator: (v) {
                  return v == null || v.trim().isNotEmpty ? null : gm.passwordRequired;
                },
              ),
              TextFormField(
                controller: _pwd2Controller,
                decoration: InputDecoration(
                  labelText: gm.passwordAgain,
                  hintText: gm.passwordAgain,
                  prefixIcon: const Icon(Icons.lock),
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
                validator: (v) {
                  return v == null || v.trim().isNotEmpty ? null : gm.passwordRequired;
                },
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: gm.name,
                  hintText: gm.name,
                  prefixIcon: const Icon(Icons.account_circle_outlined),
                ),
                validator: (v) {
                  return v == null || v.trim().isNotEmpty ? null : '姓名不能为空';
                },
              ),
              Material(
                child: InkWell(
                  splashColor: Colors.grey.withOpacity(0.5),
                  highlightColor: Colors.transparent,
                  onTap: _showCityPicker,
                  child: TextFormField(
                    enabled: false,
                    controller: _addressController,
                    decoration: InputDecoration(
                      prefixIcon: Image.asset('assets/images/address.png'),
                      suffixIcon: const Icon(Icons.arrow_drop_down_outlined),
                      labelText: '居住地区',
                      hintText: '居住地区',
                    ),
                    validator: (v) {
                      return v == null || v.trim().isNotEmpty ? null : '地区不能为空';
                    },
                  ),
                ),
              ),
              Material(
                child: InkWell(
                  splashColor: Colors.grey.withOpacity(0.5),
                  highlightColor: Colors.transparent,
                  onTap: _showCommunity,
                  child: TextFormField(
                    enabled: false,
                    controller: _communityController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.account_balance),
                      suffixIcon: Icon(Icons.arrow_drop_down_outlined),
                      labelText: gm.community,
                      hintText: gm.community,
                    ),
                    validator: (v) {
                      return v == null || v.trim().isNotEmpty ? null : '社区不能为空';
                    },
                  ),
                ),
              ),
              Material(
                child: InkWell(
                  splashColor: Colors.grey.withOpacity(0.5),
                  highlightColor: Colors.transparent,
                  onTap: _showDistrict,
                  child: TextFormField(
                    enabled: false,
                    controller: _districtController,
                    decoration: InputDecoration(
                      prefixIcon: Image.asset('assets/images/district.png'),
                      suffixIcon: Icon(Icons.arrow_drop_down_outlined),
                      labelText: '小区',
                      hintText: '小区',
                    ),
                    validator: (v) {
                      return v == null || v.trim().isNotEmpty ? null : '小区地址不能为空';
                    },
                  ),
                ),
              ),
              TextFormField(
                controller: _fullAddressController,
                decoration: const InputDecoration(
                  labelText: '详细地址',
                  hintText: '详细地址',
                  prefixIcon: Icon(Icons.home_outlined),
                ),
                validator: (v) {
                  if (_addressController.text.isEmpty) return '地区不能为空';
                  if (_communityController.text.isEmpty) return '社区不能为空';
                  if (_districtController.text.isEmpty) return '小区不能为空';
                  return v == null || v.trim().isNotEmpty ? null : '详细地址不能为空';
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: ConstrainedBox(
                  constraints: const BoxConstraints.expand(height: 55.0),
                  child: ElevatedButton(
                    onPressed: _register,
                    child: Text(gm.register, style: const TextStyle(fontSize: 18)),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Future<void> _register() async {
    if (!(_formKey.currentState as FormState).validate()) return;
    if (_pwd1Controller.text != _pwd2Controller.text) {
      showToast('两次密码输入不一致');
      _pwd1Controller.text = '';
      _pwd2Controller.text = '';
      return;
    }
    User user = User();
    user.userPhone = _phoneController.text.trim();
    user.password = _pwd1Controller.text;
    user.userName = _nameController.text;
    user.userAddress = _addressController.text +
        _communityController.text +
        _districtController.text +
        _fullAddressController.text;
    user.districtId = _selectDistrict?.districtId ?? '';
    // showLog('RegisterRoute _register', user.toString());
    bool res = await Network(context).addUser(user);
    if (res) {
      showToast('注册成功');
      Navigator.pop(context);
    }
  }

  final TextEditingController _provinceController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();

  void _showCityPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return CityPicker(
          province: _provinceController.text,
          city: _cityController.text,
          area: _areaController.text,
          updata: (String province, String city, String area) {
            _provinceController.text = province;
            _cityController.text = city;
            _areaController.text = area;
            setState(() {
              _addressController.text = province + city + area;
              _communityController.text = '';
              _districtController.text = '';
            });
          },
        );
      },
    );
  }

  Future<void> _getCommunityList() async {
    List<Community>? list = await Network(context).getCommunityList('');
    setState(() {
      _communityList = list ?? [];
    });
  }

  Future<void> getDistrictList() async {
    List<District>? list = await Network(context).getDistrictList(_communityController.text);
    _districtList = list ?? [];
  }

  void _showCommunity() {
    if (_addressController.text.isEmpty) {
      showToast('请先选择地区');
      return;
    }
    if (_addressController.text != '广西壮族自治区南宁市西乡塘区') {
      showToast('该地区暂无社区数据');
      return;
    }
    if (_communityList.isEmpty) {
      showToast('社区数据加载失败');
      return;
    }
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          return ListView(
              children: _communityList
                  .map(
                    (Community community) => GestureDetector(
                      onTap: () {
                        setState(() {
                          _communityController.text = community.communityName;
                          getDistrictList();
                          _districtController.text = '';
                          _selectDistrict = null;
                          Navigator.of(context).pop();
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 16.0),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 1.0,
                              color: _communityController.text == community.communityName
                                  ? Colors.blue
                                  : Colors.black54,
                            ),
                          ),
                        ),
                        child: Text(
                          community.communityName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: _communityController.text == community.communityName ? Colors.blue : null,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList());
        });
      },
    );
  }

  void _showDistrict() {
    if (_communityController.text.isEmpty) {
      showToast('请先选择社区');
      return;
    }
    if (_districtList.isEmpty) {
      showToast('小区数据加载失败');
      return;
    }
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          return ListView(
              children: _districtList
                  .map(
                    (District district) => GestureDetector(
                      onTap: () {
                        setState(() {
                          _districtController.text = district.districtName;
                          _selectDistrict = district;
                          Navigator.of(context).pop();
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 16.0),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 1.0,
                              color:
                                  _districtController.text == district.districtName ? Colors.blue : Colors.black54,
                            ),
                          ),
                        ),
                        child: Text(
                          district.districtName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: _districtController.text == district.districtName ? Colors.blue : null,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList());
        });
      },
    );
  }
}
