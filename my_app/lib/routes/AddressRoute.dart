import 'package:flutter/material.dart';
import 'package:my_app/common/funs.dart';
import 'package:my_app/states/index.dart';
import 'package:my_app/widgets/common/city_picker.dart';
import 'package:provider/provider.dart';

import '../common/Network.dart';
import '../l10n/localization_intl.dart';
import '../models/community.dart';
import '../models/district.dart';
import '../models/user.dart';

class AddressRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(GmLocalizations.of(context).address)), body: AddressPage());
  }
}

class AddressPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  late UserModel userModel;
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _provinceController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _communityController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _fullAddressController = TextEditingController();

  List<Community> _communityList = [];
  List<District> _districtList = [];
  District? _selectDistrict;

  @override
  void initState() {
    super.initState();
    userModel = Provider.of<UserModel>(context, listen: false);

    // showLog('AddressPage', userModel.user.toString());

    try {
      int proIndex = 0, cityIndex = 0, areaIndex = 0, comIndex = 0;
      String? address = userModel.user?.userAddress;
      if (address == null || address == '') return;

      proIndex = address.indexOf('省');
      if (proIndex == -1) proIndex = address.indexOf('区');
      if (proIndex != -1) _provinceController.text = address.substring(0, proIndex + 1);

      cityIndex = address.indexOf('市');
      if (cityIndex != -1) _cityController.text = address.substring(proIndex + 1, cityIndex + 1);

      // areaIndex = address.indexOf('县');
      // if (areaIndex == -1) areaIndex = address.indexOf('区', cityIndex);
      // if (areaIndex != -1) {
      //   _areaController.text = address.substring(cityIndex + 1, areaIndex + 1);
      // } else {
      //   areaIndex = address.indexOf('街道');
      //   if (areaIndex != -1) _areaController.text = address.substring(cityIndex + 1, ++areaIndex + 1);
      // }

      // int districtAddressLength = userModel.user?.district?.districtAddress.length ?? 0;
      // int communityNameLength = userModel.user?.district?.communityName.length ?? 0;
      // _areaController.text = userModel.user?.district?.districtAddress
      //         .substring(cityIndex + 1, districtAddressLength - communityNameLength) ??
      //     '';

      _areaController.text = '西乡塘区';

      _communityController.text = userModel.user?.district?.communityName ?? '';
      _districtController.text = userModel.user?.district?.districtName ?? '';
      _fullAddressController.text = userModel.user?.userAddress?.substring(
              "${userModel.user?.district?.districtAddress ?? ''}${userModel.user?.district?.districtName ?? ''}"
                      .length -
                  1) ??
          '';
      // _fullAddressController.text = userModel.user?.userAddress ?? '';
      // _fullAddressController.text =
      //     userModel.user?.userAddress?.substring(userModel.user?.district?.districtAddress.length ?? 0) ?? '';

      _addressController.text = _provinceController.text + _cityController.text + _areaController.text;

      // print("proIndex = $proIndex, cityIndex = $cityIndex, areaIndex = $areaIndex, comIndex = $comIndex");
    } catch (e) {
      showLog("AddressRoute initState", "地址解析出错：${e.toString()}");
    }

    _getCommunityList();
    _getDistrictList();
  }

  @override
  Widget build(BuildContext context) {
    GmLocalizations gm = GmLocalizations.of(context);
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Material(
              child: InkWell(
                splashColor: Colors.grey.withOpacity(0.5),
                highlightColor: Colors.transparent,
                onTap: showCityPicker,
                child: TextFormField(
                  enabled: false,
                  controller: _addressController,
                  decoration: InputDecoration(
                    prefixIcon: Image.asset('assets/images/address.png'),
                    suffixIcon: const Icon(Icons.arrow_drop_down_outlined),
                    labelText: '居住地区',
                    hintText: '居住地区',
                  ),
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
            ),
            Container(
              margin: const EdgeInsets.only(top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    onPressed: editAddress,
                    child: Text("修改地址", style: TextStyle(fontSize: 18)),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void editAddress() async {
    if (_addressController.text.isEmpty) {
      showToast('居住地区不能为空');
      return;
    }
    if (_communityController.text.isEmpty) {
      showToast('社区不能为空');
      return;
    }
    if (_districtController.text.isEmpty) {
      showToast('小区不能为空');
      return;
    }
    if (_fullAddressController.text.isEmpty) {
      showToast('详细地址不能为空');
      return;
    }
    // User user = User.fromString(userModel.user.toString())!;

    userModel.user!.districtId = _selectDistrict?.districtId;
    userModel.user!.userAddress = _addressController.text +
        _communityController.text +
        _districtController.text +
        _fullAddressController.text;
    // print(user.toString());
    User? result = await Network(context).updateUser(userModel.user);
    if (result != null) {
      showToast('修改成功');
      Provider.of<UserModel>(context, listen: false).user = result;
      userModel.user?.district = result.district;
      setState(() {});
    } else {
      showToast('修改失败');
    }
  }

  void showCityPicker() {
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
                          _getDistrictList();
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

  Future<void> _getCommunityList() async {
    List<Community>? list = await Network(context).getCommunityList('');
    setState(() {
      _communityList = list ?? [];
    });
  }

  Future<void> _getDistrictList() async {
    List<District>? list = await Network(context).getDistrictList(_communityController.text);
    _districtList = list ?? [];
  }
}
