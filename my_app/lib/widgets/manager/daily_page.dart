import 'package:flutter/material.dart';
import 'package:my_app/common/funs.dart';
import 'package:my_app/models/dailyReport.dart';

import '../../common/Network.dart';
import '../../l10n/localization_intl.dart';
import '../common/date_time_picker.dart';
import 'UserInfoRoute.dart';

class DailyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DailyPageState();
}

class DailyPageState extends State<DailyPage> with AutomaticKeepAliveClientMixin {
  bool _filterCheck = false;
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _temperatureController = TextEditingController();
  bool _coughed = false;
  bool _diarrheaed = false;
  bool _weaked = false;
  List<DailyReport> _dailyReportList = [];
  int _pageSize = 5;

  @override
  void initState() {
    super.initState();
    _getDailyReport();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    GmLocalizations gm = GmLocalizations.of(context);
    var flag = MediaQuery.of(context).size.width < 730;
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              height: 50,
              width: 180,
              child: CheckboxListTile(
                title: const Text("条件查询"),
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
                      width: 250,
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 220,
                            child: DateTimePicker(
                              controller: _timeController,
                              type: DateTimePickerType.date,
                              dateMask: 'yyyy-MM-dd',
                              // initialValue: DateTime.now().toString(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                              icon: Icon(Icons.timelapse),
                              dateLabelText: '日期',
                              // timeLabelText: '时间',
                              onChanged: (val) {
                                showLog('DailyPage DateTimePicker', 'time = $val');
                                setState(() {
                                  _timeController.text = val;
                                });
                              },
                              validator: (val) {
                                print('validator val=$val');
                                return null;
                              },
                              // onSaved: (val) => print("---val=$val"),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _timeController.text = '';
                              });
                            },
                            child: const Icon(
                              Icons.cancel_outlined,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 250,
                      child: TextField(
                        controller: _userController,
                        decoration: const InputDecoration(
                          labelText: "用户姓名/手机号码",
                          hintText: "用户姓名/手机号码",
                          prefixIcon: Icon(Icons.account_circle_outlined),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 250,
                      child: TextField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          labelText: '小区/社区地址',
                          hintText: '小区/社区地址',
                          prefixIcon: Image.asset('assets/images/address.png'),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 250,
                      child: TextField(
                        controller: _temperatureController,
                        decoration: InputDecoration(
                          labelText: '体温',
                          hintText: '体温',
                          prefixIcon: Image.asset('assets/images/temperature.png'),
                        ),
                      ),
                    ),
                    Container(
                      width: 110,
                      height: 70,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(value: _coughed, onChanged: (value) => setState(() => _coughed = value!)),
                          Text("是否咳嗽")
                        ],
                      ),
                    ),
                    Container(
                      width: 110,
                      height: 70,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(value: _diarrheaed, onChanged: (value) => setState(() => _diarrheaed = value!)),
                          Text("是否腹泻")
                        ],
                      ),
                    ),
                    Container(
                      width: 110,
                      height: 70,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(value: _weaked, onChanged: (value) => setState(() => _weaked = value!)),
                          Text("是否乏力")
                        ],
                      ),
                    ),
                    Container(
                      width: 150,
                      margin: const EdgeInsets.only(top: 20, bottom: 5),
                      child: FilledButton(
                        onPressed: () {
                          _getDailyReport();
                        },
                        child: const Text("查  询", textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
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
                  header: const Text('每日健康信息', style: TextStyle(fontWeight: FontWeight.bold)),
                  actions: <Widget>[
                    IconButton(
                        icon: const Icon(Icons.refresh),
                        tooltip: '刷新页面',
                        onPressed: () {
                          _getDailyReport();
                          showToast('刷新成功');
                        }),
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
                    DataColumn(label: _TableRowTitle('上报时间')),
                    DataColumn(label: _TableRowTitle('姓名')),
                    // DataColumn(label: _TableRowTitle('小区/社区地址')),
                    DataColumn(label: _TableRowTitle('体温')),
                    DataColumn(label: _TableRowTitle('是否咳嗽')),
                    DataColumn(label: _TableRowTitle('是否腹泻')),
                    DataColumn(label: _TableRowTitle('是否乏力')),
                  ],
                  source: _UserDataTableSource(context, _dailyReportList),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _getDailyReport() async {
    List<DailyReport>? list = await Network(context).getDailyReportList(
      _timeController.text.trim(),
      _userController.text.trim(),
      _addressController.text.trim(),
      _temperatureController.text.trim(),
      _coughed ? '1' : '0',
      _diarrheaed ? '1' : '0',
      _weaked ? '1' : '0',
    );
    // print("list.size = ${list?.length}");
    setState(() {
      _dailyReportList = list ?? [];
    });
  }

  @override
  bool get wantKeepAlive => true;
}

class _UserDataTableSource extends DataTableSource {
  _UserDataTableSource(this.context, this.data);

  final BuildContext context;
  final List<DailyReport> data;
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
        DataCell(Text(data[index].reportTime.toString() ?? "")),
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
        DataCell(Text(data[index].temperature.toString() ?? "")),
        DataCell(Text((data[index].coughed ?? "") == '0' ? '否' : '是')),
        DataCell(Text((data[index].diarrheaed ?? "") == '0' ? '否' : '是')),
        DataCell(Text((data[index].weaked ?? "") == '0' ? '否' : '是')),
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
