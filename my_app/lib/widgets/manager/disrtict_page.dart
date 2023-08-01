import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_app/models/community.dart';
import 'package:my_app/models/district.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../common/Network.dart';
import '../../common/funs.dart';
import '../../l10n/localization_intl.dart';
import 'ScannerUserRoute.dart';

class DistrictPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DistrictPageState();
}

class DistrictPageState extends State<DistrictPage> with AutomaticKeepAliveClientMixin {
  bool _filterCheck = false;
  final TextEditingController _searchController = TextEditingController();
  List<District> _districtList = [];
  int _pageSize = 5;
  final GlobalKey _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _getDistrictList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var gm = GmLocalizations.of(context);
    var flag = MediaQuery.of(context).size.width < 730;

    return SingleChildScrollView(
      child: Container(
        child: Container(
          alignment: Alignment.topLeft,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              alignment: Alignment.centerLeft,
              height: 50,
              width: 180,
              child: CheckboxListTile(
                title: Text("条件查询"),
                controlAffinity: ListTileControlAffinity.leading,
                value: _filterCheck,
                onChanged: (bool? value) {
                  setState(() {
                    _filterCheck = value!;
                  });
                },
              ),
            ),
            Visibility(
              visible: _filterCheck,
              maintainSize: false,
              child: Container(
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width - (flag ? 30 : 140),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 350,
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          labelText: '小区编号/小区名称/小区地址',
                          hintText: '小区编号/小区名称/小区地址',
                          prefixIcon: Image.asset('assets/images/district.png'),
                        ),
                      ),
                    ),
                    Container(
                      width: 250,
                      margin: const EdgeInsets.only(top: 20, bottom: 5),
                      child: FilledButton(
                        onPressed: _getDistrictList,
                        child: const Text("查       询"),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width > 900 ? MediaQuery.of(context).size.width - 140 : 900,
              // height: 500,
              margin: const EdgeInsets.all(5),
              child: SingleChildScrollView(
                child: PaginatedDataTable(
                  key: UniqueKey(),
                  header: const Text('小区信息', style: TextStyle(fontWeight: FontWeight.bold)),
                  actions: <Widget>[
                    IconButton(
                        icon: const Icon(Icons.refresh),
                        tooltip: '刷新页面',
                        onPressed: () {
                          _getDistrictList();
                          showToast('刷新成功');
                        }),
                    IconButton(
                      icon: Image.asset('assets/images/scanner.png'),
                      tooltip: '扫码',
                      onPressed: () =>
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ScannerUserRoute())),
                    ),
                    IconButton(icon: const Icon(Icons.add), tooltip: '添加小区', onPressed: showAddDistrictDialog),
                    IconButton(icon: Image.asset('assets/images/export.png'), tooltip: '导出数据', onPressed: () {}),
                  ],
                  onPageChanged: (int page) {},
                  rowsPerPage: _pageSize,
                  availableRowsPerPage: const [5, 10, 20, 50, 100],
                  onRowsPerPageChanged: (int? pageSize) {
                    setState(() {
                      _pageSize = pageSize!;
                    });
                    // _getUserList();
                  },
                  columns: const <DataColumn>[
                    DataColumn(label: _TableRowTitle('小区编号')),
                    DataColumn(label: _TableRowTitle('小区名称')),
                    DataColumn(label: _TableRowTitle('小区地址')),
                    DataColumn(label: _TableRowTitle('二维码')),
                  ],
                  source: _DistrictDataTableSource(context, _districtList),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Future<void> _getDistrictList() async {
    List<District>? list = await Network(context).getDistrictList(_searchController.text.trim());
    // print("-----list.len = ${list?.length}");
    setState(() {
      _districtList = list ?? [];
    });
  }

  Future<void> showAddDistrictDialog() async {
    var mediaQuery = MediaQuery.of(context).size;
    var size = min(mediaQuery.width, mediaQuery.height) * 0.9;

    TextEditingController _nameController = TextEditingController();
    TextEditingController _addressController = TextEditingController();
    List<Community> communityList = await Network(context).getCommunityList('') ?? [];
    var communityIndex = 0;

    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          return SingleChildScrollView(
            child: Container(
              width: size,
              height: 320,
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: <Widget>[
                    const Text("小区信息", style: TextStyle(fontSize: 18)),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: '小区名字',
                        hintText: '小区名字',
                        prefixIcon: Image.asset('assets/images/district.png'),
                      ),
                      validator: (v) {
                        return v == null || v.trim().isNotEmpty ? null : '小区名字不能为空';
                      },
                    ),
                    Row(
                      children: [
                        const SizedBox(width: 10, height: 80),
                        Icon(Icons.account_balance_outlined),
                        const SizedBox(width: 10),
                        Text("所属社区："),
                        DropdownButton(
                          // key: UniqueKey(),
                          value: communityIndex,
                          items: communityList.map((Community community) {
                            return DropdownMenuItem(
                              value: communityList.indexOf(community),
                              child: Text(community.communityName),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              communityIndex = value!;
                              _addressController.text =
                                  communityList[value].communityAddress + communityList[value].communityName;
                            });
                          },
                        ),
                      ],
                    ),
                    TextFormField(
                      enabled: false,
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: '小区地址',
                        hintText: '小区地址',
                        prefixIcon: Image.asset('assets/images/address.png'),
                      ),
                    ),
                    Expanded(child: Container()),
                    Container(
                      width: 150,
                      child: FilledButton(
                        onPressed: () => addDistrict(_nameController.text.trim(), communityList[communityIndex]),
                        child: Text('确    认'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Future<void> addDistrict(String districtName, Community community) async {
    if (!(_formKey.currentState as FormState).validate()) return;
    // showLoading(context);
    District district = District();
    district.districtId = '';
    district.districtName = districtName;
    district.districtAddress = community.communityAddress + community.communityName;
    district.communityId = community.communityId;
    bool result = await Network(context).addDistrict(district);
    if (result) Navigator.of(context).pop();
  }

  @override
  bool get wantKeepAlive => true;
}

class _DistrictDataTableSource extends DataTableSource {
  _DistrictDataTableSource(this.context, this.data);

  final BuildContext context;
  final List<District> data;
  int pageSize = 0;
  int total = 0;

  @override
  DataRow getRow(int index) {
    return DataRow.byIndex(
      index: index,
      selected: data[index].selected,
      onSelectChanged: (selected) {
        data[index].selected = selected!;
        notifyListeners();
      },
      cells: [
        DataCell(Text(data[index].districtId.toString() ?? "")),
        DataCell(Text(data[index].districtName.toString() ?? "")),
        DataCell(Text(data[index].districtAddress.toString() ?? "")),
        DataCell(
          TextButton(onPressed: () => _showQrCode(data[index]), child: const Icon(Icons.qr_code_2_rounded)),
        ),
      ],
    );
  }

  void _showQrCode(District district) async {
    var mediaQuery = MediaQuery.of(context).size;
    var size = min(mediaQuery.width, mediaQuery.height) * 0.618;
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        content: Container(
          width: size,
          height: size + 25,
          child: Column(
            children: [
              QrImage(
                data: district.toString(),
                errorStateBuilder: (context, object) => const Icon(Icons.qr_code_2_sharp),
              ),
              Text(district.districtName)
            ],
          ),
        ),
      ),
    );
  }

  @override
  int get selectedRowCount {
    return 0;
  }

  @override
  bool get isRowCountApproximate {
    return false;
  }

  @override
  int get rowCount {
    return data.length;
  }
}

class _TableRowTitle extends StatelessWidget {
  final String text;

  const _TableRowTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
