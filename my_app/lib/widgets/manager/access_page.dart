import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_app/models/access.dart';

import '../../common/Network.dart';
import '../../common/funs.dart';
import '../../l10n/localization_intl.dart';
import '../common/date_time_picker.dart';
import 'UserInfoRoute.dart';

class AccessPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AccessPageState();
}

class AccessPageState extends State<AccessPage> with AutomaticKeepAliveClientMixin {
  bool _filterCheck = false;
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _communityController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  bool _yesOutProvince = false;
  bool _noOutProvince = false;
  var _tableKey;
  final GlobalKey _formKey = GlobalKey<FormState>();
  List<Access> _accessList = [];
  int _pageSize = 5;

  @override
  void initState() {
    super.initState();
    _getAccessList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var gm = GmLocalizations.of(context);
    var flag = MediaQuery.of(context).size.width < 730;

    return SingleChildScrollView(
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
              child: Wrap(
                alignment: WrapAlignment.spaceAround,
                children: [
                  Container(
                    width: 350,
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 320,
                          child: DateTimePicker(
                            key: UniqueKey(),
                            controller: _timeController,
                            type: DateTimePickerType.dateTimeSeparate,
                            dateMask: 'yyyy-MM-dd',
                            // initialValue: DateTime.now().toString(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                            icon: Icon(Icons.timelapse),
                            dateLabelText: '日期',
                            timeLabelText: '时间',
                            onChanged: (val) {
                              showLog('DailyPage DateTimePicker', 'time = $val');
                              setState(() {
                                // _timeController.text = val;
                              });
                            },
                            validator: (val) {
                              print('validator val=$val');
                              return null;
                            },
                            onSaved: (val) => setState(() {
                              print('onSaved val=$val');
                              _timeController.text = val ?? '';
                            }),
                          ),
                        ),
                        InkWell(
                          onTap: () => setState(() => _timeController.text = ''),
                          child: const Icon(Icons.cancel_outlined, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 350,
                    child: TextField(
                      controller: _userController,
                      decoration: const InputDecoration(
                        labelText: '用户姓名/手机号',
                        hintText: '用户姓名/手机号',
                        prefixIcon: Icon(Icons.account_balance_outlined),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 350,
                    child: TextField(
                      controller: _communityController,
                      decoration: const InputDecoration(
                        labelText: '社区编号/名字',
                        hintText: '社区编号/名字',
                        prefixIcon: Icon(Icons.account_balance_outlined),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 350,
                    child: TextField(
                      controller: _districtController,
                      decoration: InputDecoration(
                        labelText: '小区编号/名字',
                        hintText: '小区编号/名字',
                        prefixIcon: Image.asset("assets/images/district.png"),
                      ),
                    ),
                  ),
                  Container(
                    width: 350,
                    padding: EdgeInsets.only(top: 15, left: 5),
                    child: Row(children: [
                      Text("是否境外人员："),
                      Checkbox(
                          value: _noOutProvince,
                          onChanged: (value) {
                            setState(() => _noOutProvince = value!);
                          }),
                      Text("否"),
                      const SizedBox(width: 20),
                      Checkbox(
                          value: _yesOutProvince,
                          onChanged: (value) {
                            setState(() => _yesOutProvince = value!);
                          }),
                      Text("是"),
                    ]),
                  ),
                  Container(
                    width: 350,
                    padding: EdgeInsets.symmetric(horizontal: 100),
                    margin: const EdgeInsets.only(top: 20, bottom: 5),
                    child: FilledButton(
                      onPressed: _getAccessList,
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
                header: const Text('用户信息', style: TextStyle(fontWeight: FontWeight.bold)),
                actions: <Widget>[
                  IconButton(
                      icon: const Icon(Icons.refresh),
                      tooltip: '刷新页面',
                      onPressed: () {
                        _getAccessList();
                        showToast('刷新成功');
                      }),
                  IconButton(icon: Image.asset('assets/images/export.png'), tooltip: '导出数据', onPressed: () {}),
                ],
                onPageChanged: (int page) {
                  // _pageCurrent = (page + 1) ~/ 2;
                  // _getUserList();
                },
                rowsPerPage: _pageSize,
                availableRowsPerPage: const [5, 10, 20, 50, 100],
                onRowsPerPageChanged: (int? pageSize) {
                  setState(() {
                    _pageSize = pageSize!;
                  });
                },
                columns: const <DataColumn>[
                  DataColumn(label: _TableRowTitle('时间')),
                  DataColumn(label: _TableRowTitle('姓名')),
                  DataColumn(label: _TableRowTitle('是否省外人员')),
                  DataColumn(label: _TableRowTitle('地址')),
                  // DataColumn(label: _TableRowTitle('')),
                ],
                source: _UserDataTableSource(context, _accessList),
              ),
            ),
          ),

        ]),
      ),
    );
  }

  Future<void> _getAccessList() async {
    String outProvince = '';
    if (_noOutProvince) outProvince += '0';
    if (_yesOutProvince) outProvince += '1';

    List<Access>? list = await Network(context).getAccessList(
      _timeController.text.trim(),
      _userController.text.trim(),
      _communityController.text.trim(),
      _districtController.text.trim(),
      outProvince,
    );
    // print('-----list.size=${list?.length}');
    // print(jsonEncode(list?.first));
    setState(() {
      _tableKey = UniqueKey();
      _accessList = list ?? [];
    });
  }

  @override
  bool get wantKeepAlive => true;
}

class _UserDataTableSource extends DataTableSource {
  _UserDataTableSource(this.context, this.data);

  final BuildContext context;
  final List<Access> data;
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
        DataCell(Text(data[index].accessTime ?? "")),
        DataCell(
          TextButton(
            onPressed: () {
              if (data[index].user != null) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => UserInfoRoute(data[index].user!)));
              }
            },
            child: Text(data[index].user?.userName ?? ""),
          ),
        ),
        DataCell(Text(data[index].outProvince == '0' ? '否' : '是')),
        DataCell(Text("${data[index].district?.communityName ?? ''}${data[index].district?.districtName ?? ''}")),
      ],
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
