//省份数据模型
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_app/common/funs.dart';

import '../../l10n/localization_intl.dart';

class ProvinceModel {
  String name;
  List<CityModel> cities;

  ProvinceModel({required this.name, required this.cities});
}

//城市数据模型
class CityModel {
  String name;
  List<AreaModel> areas;

  CityModel({required this.name, required this.areas});
}

//县区数据模型
class AreaModel {
  String name;

  AreaModel({required this.name});
}

//城市数据源
final List<ProvinceModel> cityData = [
  ProvinceModel(
    name: "广西壮族自治区",
    cities: [
      CityModel(
        name: "南宁市",
        areas: [
          AreaModel(name: "西乡塘区"),
          AreaModel(name: "青秀区"),
          AreaModel(name: "兴宁区"),
          AreaModel(name: "江南区"),
          AreaModel(name: "武鸣区"),
          AreaModel(name: "横州市"),
          AreaModel(name: "隆安县"),
          AreaModel(name: "马山县"),
          AreaModel(name: "上林县"),
          AreaModel(name: "宾阳县"),
          AreaModel(name: "邕宁区"),
        ],
      ),
      CityModel(
        name: "柳州市",
        areas: [
          AreaModel(name: "柳江县"),
          AreaModel(name: "柳城县"),
          AreaModel(name: "鹿寨县"),
        ],
      ),
      CityModel(
        name: "梧州市",
        areas: [
          AreaModel(name: "万秀区"),
          AreaModel(name: "长洲区"),
          AreaModel(name: "龙圩区"),
        ],
      ),
      CityModel(
        name: "贵港市",
        areas: [
          AreaModel(name: "桂平市"),
          AreaModel(name: "港北区"),
          AreaModel(name: "港南区"),
          AreaModel(name: "覃塘区"),
          AreaModel(name: "平南县"),
        ],
      ),
      CityModel(
        name: "桂林市",
        areas: [
          AreaModel(name: "桂平市"),
          AreaModel(name: "港北区"),
          AreaModel(name: "港南区"),
          AreaModel(name: "覃塘区"),
          AreaModel(name: "平南县"),
        ],
      ),
      CityModel(
        name: "北海市",
        areas: [
          AreaModel(name: "桂平市"),
          AreaModel(name: "港北区"),
          AreaModel(name: "港南区"),
          AreaModel(name: "覃塘区"),
          AreaModel(name: "平南县"),
        ],
      ),
      CityModel(
        name: "防城港市",
        areas: [
          AreaModel(name: "桂平市"),
          AreaModel(name: "港北区"),
          AreaModel(name: "港南区"),
          AreaModel(name: "覃塘区"),
          AreaModel(name: "平南县"),
        ],
      ),
      CityModel(
        name: "钦州市",
        areas: [
          AreaModel(name: "桂平市"),
          AreaModel(name: "港北区"),
          AreaModel(name: "港南区"),
          AreaModel(name: "覃塘区"),
          AreaModel(name: "平南县"),
        ],
      ),
      CityModel(
        name: "玉林市",
        areas: [
          AreaModel(name: "桂平市"),
          AreaModel(name: "港北区"),
          AreaModel(name: "港南区"),
          AreaModel(name: "覃塘区"),
          AreaModel(name: "平南县"),
        ],
      ),
      CityModel(
        name: "百色市",
        areas: [
          AreaModel(name: "桂平市"),
          AreaModel(name: "港北区"),
          AreaModel(name: "港南区"),
          AreaModel(name: "覃塘区"),
          AreaModel(name: "平南县"),
        ],
      ),
      CityModel(
        name: "贺州市",
        areas: [
          AreaModel(name: "桂平市"),
          AreaModel(name: "港北区"),
          AreaModel(name: "港南区"),
          AreaModel(name: "覃塘区"),
          AreaModel(name: "平南县"),
        ],
      ),
      CityModel(
        name: "河池市",
        areas: [
          AreaModel(name: "桂平市"),
          AreaModel(name: "港北区"),
          AreaModel(name: "港南区"),
          AreaModel(name: "覃塘区"),
          AreaModel(name: "平南县"),
        ],
      ),
      CityModel(
        name: "来宾市",
        areas: [
          AreaModel(name: "桂平市"),
          AreaModel(name: "港北区"),
          AreaModel(name: "港南区"), 
          AreaModel(name: "覃塘区"),
          AreaModel(name: "平南县"),
        ],
      ),
      CityModel(
        name: "崇左市",
        areas: [
          AreaModel(name: "桂平市"),
          AreaModel(name: "港北区"),
          AreaModel(name: "港南区"),
          AreaModel(name: "覃塘区"),
          AreaModel(name: "平南县"),
        ],
      ),
    ],
  ),
  ProvinceModel(
    name: "广东省",
    cities: [
      CityModel(
        name: "广州市",
        areas: [
          AreaModel(name: "越秀区"),
          AreaModel(name: "海珠区"),
          AreaModel(name: "荔湾区"),
          AreaModel(name: "天河区"),
        ],
      ),
      CityModel(
        name: "深圳市",
        areas: [
          AreaModel(name: "南山区"),
          AreaModel(name: "盐田区"),
          AreaModel(name: "罗湖区"),
          AreaModel(name: "福田区"),
          AreaModel(name: "宝安区"),
        ],
      ),
      CityModel(
        name: "佛山市",
        areas: [
          AreaModel(name: "顺德区"),
          AreaModel(name: "禅城区"),
          AreaModel(name: "南海区"),
          AreaModel(name: "三水区"),
        ],
      ),
    ],
  ),
  ProvinceModel(
    name: "江苏省",
    cities: [
      CityModel(
        name: "常州市",
        areas: [
          AreaModel(name: "金坛区"),
          AreaModel(name: "武进区"),
          AreaModel(name: "新北区"),
          AreaModel(name: "天宁区"),
        ],
      ),
      CityModel(
        name: "南京市",
        areas: [
          AreaModel(name: "玄武区"),
          AreaModel(name: "鼓楼区"),
          AreaModel(name: "建邺区"),
          AreaModel(name: "秦淮区"),
        ],
      ),
    ],
  ),
  ProvinceModel(
    name: "湖南省",
    cities: [
      CityModel(
        name: "长沙市",
        areas: [
          AreaModel(name: "芙蓉区"),
          AreaModel(name: "天心区"),
          AreaModel(name: "开福区"),
          AreaModel(name: "雨花区"),
        ],
      ),
      CityModel(
        name: "岳阳市",
        areas: [
          AreaModel(name: "君山区"),
          AreaModel(name: "云溪区"),
          AreaModel(name: "湘阴县"),
        ],
      ),
    ],
  ),
  ProvinceModel(
    name: "山西省",
    cities: [
      CityModel(
        name: "长沙市",
        areas: [
          AreaModel(name: "芙蓉区"),
          AreaModel(name: "天心区"),
          AreaModel(name: "开福区"),
          AreaModel(name: "雨花区"),
        ],
      ),
      CityModel(
        name: "岳阳市",
        areas: [
          AreaModel(name: "君山区"),
          AreaModel(name: "云溪区"),
          AreaModel(name: "湘阴县"),
        ],
      ),
    ],
  ),
  ProvinceModel(
    name: "河北省",
    cities: [
      CityModel(
        name: "长沙市",
        areas: [
          AreaModel(name: "芙蓉区"),
          AreaModel(name: "天心区"),
          AreaModel(name: "开福区"),
          AreaModel(name: "雨花区"),
        ],
      ),
      CityModel(
        name: "岳阳市",
        areas: [
          AreaModel(name: "君山区"),
          AreaModel(name: "云溪区"),
          AreaModel(name: "湘阴县"),
        ],
      ),
    ],
  ),
  ProvinceModel(
    name: "辽宁省",
    cities: [
      CityModel(
        name: "长沙市",
        areas: [
          AreaModel(name: "芙蓉区"),
          AreaModel(name: "天心区"),
          AreaModel(name: "开福区"),
          AreaModel(name: "雨花区"),
        ],
      ),
      CityModel(
        name: "岳阳市",
        areas: [
          AreaModel(name: "君山区"),
          AreaModel(name: "云溪区"),
          AreaModel(name: "湘阴县"),
        ],
      ),
    ],
  ),
  ProvinceModel(
    name: "吉林省",
    cities: [
      CityModel(
        name: "长沙市",
        areas: [
          AreaModel(name: "芙蓉区"),
          AreaModel(name: "天心区"),
          AreaModel(name: "开福区"),
          AreaModel(name: "雨花区"),
        ],
      ),
      CityModel(
        name: "岳阳市",
        areas: [
          AreaModel(name: "君山区"),
          AreaModel(name: "云溪区"),
          AreaModel(name: "湘阴县"),
        ],
      ),
    ],
  ),
  ProvinceModel(
    name: "黑龙江省",
    cities: [
      CityModel(
        name: "长沙市",
        areas: [
          AreaModel(name: "芙蓉区"),
          AreaModel(name: "天心区"),
          AreaModel(name: "开福区"),
          AreaModel(name: "雨花区"),
        ],
      ),
      CityModel(
        name: "岳阳市",
        areas: [
          AreaModel(name: "君山区"),
          AreaModel(name: "云溪区"),
          AreaModel(name: "湘阴县"),
        ],
      ),
    ],
  ),
  ProvinceModel(
    name: "浙江省",
    cities: [
      CityModel(
        name: "长沙市",
        areas: [
          AreaModel(name: "芙蓉区"),
          AreaModel(name: "天心区"),
          AreaModel(name: "开福区"),
          AreaModel(name: "雨花区"),
        ],
      ),
      CityModel(
        name: "岳阳市",
        areas: [
          AreaModel(name: "君山区"),
          AreaModel(name: "云溪区"),
          AreaModel(name: "湘阴县"),
        ],
      ),
    ],
  ),
];

//城市选择器界面组件
class CityPicker extends StatefulWidget {
  final String province;
  final String city;
  final String area;
  final Function updata;

  CityPicker({
    super.key,
    required this.province,
    required this.city,
    required this.area,
    required this.updata,
  });

  @override
  _CityPickerState createState() => _CityPickerState(province, city, area, updata);
}

class _CityPickerState extends State<CityPicker> {
  String _selectedProvince;
  String _selectedCity;
  String _selectedArea;
  Function _updata;

  _CityPickerState(this._selectedProvince, this._selectedCity, this._selectedArea, this._updata);

  @override
  Widget build(BuildContext context) {
    GmLocalizations gm = GmLocalizations.of(context);
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Text("213",style: TextStyle(fontSize: 16),),
          Container(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(gm.cancel, style: TextStyle(fontSize: 18)),
                ),
                TextButton(
                  onPressed: () {
                    if (_selectedProvince == '') {
                      showToast(gm.noProvince);
                      return;
                    }
                    if (_selectedCity == '') {
                      showToast(gm.noCity);
                      return;
                    }
                    if (_selectedArea == '') {
                      showToast(gm.noArea);
                      return;
                    }
                    _updata(_selectedProvince, _selectedCity, _selectedArea);
                    Navigator.pop(context, "$_selectedProvince $_selectedCity $_selectedArea");
                  },
                  child: Text(gm.yes, style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 2 - 40,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(width: 2),
                Expanded(
                  flex: 1,
                  child: ListView(children: _buildProvinceList()),
                ),
                const SizedBox(width: 2),
                Expanded(
                  flex: 1,
                  child: ListView(children: _buildCityList()),
                ),
                const SizedBox(width: 2),
                Expanded(
                  flex: 1,
                  child: ListView(children: _buildAreaList()),
                ),
                const SizedBox(width: 2),
              ],
            ),
          )
        ],
      ),
    );
  }

  // 省份列表
  List<Widget> _buildProvinceList() {
    List<Widget> widgets = [];
    for (var i = 0; i < cityData.length; i++) {
      widgets.add(
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedProvince = cityData[i].name;
              _selectedCity = '';
              _selectedArea = '';
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1.0,
                  color: _selectedProvince == cityData[i].name ? Colors.blue : Colors.black54,
                ),
              ),
            ),
            child: Text(
              cityData[i].name,
              textAlign: TextAlign.center, // 居中对齐
              style: TextStyle(
                fontSize: 16.0,
                color: _selectedProvince == cityData[i].name ? Colors.blue : null,
              ),
            ),
          ),
        ),
      );
    }
    return widgets;
  }

  //城市列表
  List<Widget> _buildCityList() {
    List<Widget> widgets = [];
    var provinceIndex = cityData.indexWhere((province) => province.name == _selectedProvince);
    if (provinceIndex == -1) provinceIndex = 0;
    for (var i = 0; i < cityData[provinceIndex].cities.length; i++) {
      widgets.add(
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedCity = cityData[provinceIndex].cities[i].name;
              _selectedArea = '';
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1.0,
                  color: _selectedCity == cityData[provinceIndex].cities[i].name ? Colors.blue : Colors.black54,
                ),
              ),
            ),
            child: Text(
              cityData[provinceIndex].cities[i].name,
              textAlign: TextAlign.center, // 居中对齐
              style: TextStyle(
                fontSize: 16.0,
                color: _selectedCity == cityData[provinceIndex].cities[i].name ? Colors.blue : null,
              ),
            ),
          ),
        ),
      );
    }
    return widgets;
  }

  //区县列表
  List<Widget> _buildAreaList() {
    List<Widget> widgets = [];
    var provinceIndex = cityData.indexWhere((province) => province.name == _selectedProvince);
    if (provinceIndex == -1) provinceIndex = 0;
    var cityIndex = cityData[provinceIndex].cities.indexWhere((city) => city.name == _selectedCity);
    if (cityIndex == -1) cityIndex = 0;
    for (var i = 0; i < cityData[provinceIndex].cities[cityIndex].areas.length; i++) {
      widgets.add(
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedArea = cityData[provinceIndex].cities[cityIndex].areas[i].name;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1.0,
                  color: _selectedArea == cityData[provinceIndex].cities[cityIndex].areas[i].name
                      ? Colors.blue
                      : Colors.black54,
                ),
              ),
            ),
            child: Text(
              cityData[provinceIndex].cities[cityIndex].areas[i].name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
                color:
                    _selectedArea == cityData[provinceIndex].cities[cityIndex].areas[i].name ? Colors.blue : null,
              ),
            ),
          ),
        ),
      );
    }
    return widgets;
  }
}
