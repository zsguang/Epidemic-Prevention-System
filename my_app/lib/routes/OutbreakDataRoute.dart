import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mapofchina/map/china_map.dart';
import 'package:mapofchina/map/data.dart';
import 'package:my_app/common/Network.dart';
import 'package:my_app/models/index.dart';

import '../l10n/localization_intl.dart';
import '../models/province.dart';

class OutbreakDataRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OutbreakDataRouteState();
}

class _OutbreakDataRouteState extends State<OutbreakDataRoute> {
  bool progressVisibility = true;
  Map<String, Province>? _map;
  Widget? _mapWidget;
  Province? _provinceItem;
  var _listWidgetKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _mapWidget = MapWidget(
      defaultToast: "现有确诊病例 \n广西：35",
      cityItems: generatedCityItemsHelper((cityName) => CityItem(
            cityName: cityName,
            cityColor: const Color(0xFFd4d4d4),
          )),
      clickCallback: (cityName) {
        return "$cityName 确诊0";
      },
      background: const Color(0xFFF2F2F2),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_map == null) _loadData();
    GmLocalizations gm = GmLocalizations.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(gm.outbreakData),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  color: const Color(0xFFF2F2F2),
                  // width: MediaQuery.of(context).size.width.clamp(200, 390) ,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width.clamp(200, 390),
                    child: _mapWidget,
                  ),
                ),
                _ShowDataWidget(
                  key: _listWidgetKey,
                  province: _provinceItem,
                ),
              ],
            ),
          ),
        ));
  }

  /// 随机生成颜色
  Color _randomColor() {
    var index = Random().nextInt(3) % 3;
    if (index == 0) return Color(0xFFFFB1A3);
    if (index == 1) return Color(0xFFFF7b63);
    if (index == 2) return Color(0xFFFF3900);
    return middleColor;
  }

  Color _getProvinceColor(num count) {
    if (count >= 10000) return Color(0xFFFF3900);
    if (count >= 5000) return Color(0xFFFF7b63);
    if (count >= 1000) return Color(0xFFFFB1A3);
    if (count > 0) return Color(0xFFffdddd);
    return Color(0xFFd4d4d4);
    // return Color(0xFFFF3900);
  }

  void _loadData() async {
    _showProgressDialog();
    _map = await Network(context).getProvinceCount();
    // 生成新的 MapWidget
    Widget newMapWidget = MapWidget(
      key: UniqueKey(),
      defaultToast: "现有确诊病例 \n广西：35",
      cityItems: generatedCityItemsHelper((cityName) => CityItem(
            cityName: cityName,
            cityColor: _getProvinceColor(_map?[cityName]?.currentConfirmedCount ?? 0),
          )),
      clickCallback: (cityName) {
        setState(() {
          _listWidgetKey = UniqueKey();
          _provinceItem = _map?[cityName];
        });
        return "现有确诊病例\n$cityName：${_map?[cityName]?.currentConfirmedCount ?? 0}";
      },
      background: const Color(0xFFF2F2F2),
      selectedStorkeColor: const Color(0xFF8BFDF0),
    );
    Navigator.of(context).pop(); // 关闭对话框
    // 更新状态
    setState(() {
      _mapWidget = newMapWidget;
    });
  }

  // 显示等待对话框
  void _showProgressDialog() {
    Future.delayed(Duration.zero).then(
      (value) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}

class _ShowDataWidget extends StatefulWidget {
  Province? _province;

  _ShowDataWidget({super.key, Province? province}) : _province = province;

  @override
  State<StatefulWidget> createState() => _ShowDataWidgetState(province: _province);
}

class _ShowDataWidgetState extends State<_ShowDataWidget> {
  final Province? _province;
  List<City>? citys;

  _ShowDataWidgetState({Province? province}) : _province = province;

  @override
  void initState() {
    super.initState();
    citys = _province?.cities;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _province == null
          ? const Text("点击地图可查看数据", style: TextStyle(color: Colors.grey, fontSize: 16))
          : Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${_province?.provinceName}",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(
                            DateFormat("yyyy-MM-dd HH:mm")
                                .format(DateTime.fromMillisecondsSinceEpoch(_province!.updateTime!.toInt())),
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      Wrap(
                        // alignment: WrapAlignment.start,
                        spacing: 20,
                        children: [
                          Text("累计确诊：${_province?.confirmedCount}"),
                          Text("现有确诊：${_province?.currentConfirmedCount}"),
                          Text("疑似确诊：${_province?.suspectedCount}"),
                          Text("累计治愈：${_province?.curedCount}"),
                          Text("累计死亡：${_province?.deadCount}"),
                        ],
                      ),
                      // Container(
                      //   alignment: Alignment.topLeft,
                      //   margin: EdgeInsets.all(3),
                      //   child: Text("具体数据：",style: TextStyle(fontSize: 17),),
                      // )
                    ],
                  ),
                ),
                _province == null
                    ? Container()
                    : Container(
                        margin: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                        child: Table(
                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                          columnWidths: const {
                            0: FlexColumnWidth(2),
                            1: FlexColumnWidth(2),
                            2: FlexColumnWidth(2),
                            3: FlexColumnWidth(1.5),
                            4: FlexColumnWidth(1.5),
                          },
                          children: [
                            const TableRow(
                              decoration: BoxDecoration(color: Colors.black12),
                              children: [
                                Text('城市', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                Text('现有确诊', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                Text('累计确诊', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                Text('死亡', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                Text('治愈', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            ...citys!.map((City item) {
                              return TableRow(children: [
                                Text(item.cityName),
                                Text(item.currentConfirmedCount.toString()),
                                Text(item.confirmedCount.toString()),
                                Text(item.deadCount.toString()),
                                Text(item.curedCount.toString()),
                              ]);
                            }).toList()
                          ],
                        ),
                      )
              ],
            ),
    );
  }
}
