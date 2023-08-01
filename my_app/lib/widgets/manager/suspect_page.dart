import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/Network.dart';
import '../../common/funs.dart';
import '../../l10n/localization_intl.dart';
import '../../models/user.dart';
import 'UserInfoRoute.dart';

class SuspectPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SuspectPageState();
}

class SuspectPageState extends State<SuspectPage> with AutomaticKeepAliveClientMixin {
  bool _filterCheck = false;
  final TextEditingController _userController = TextEditingController();
  List<User> _userList = [];
  int _pageSize = 5;

  @override
  void initState() {
    super.initState();
    _getPredictList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                child: Wrap(alignment: WrapAlignment.spaceAround, children: [
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _userController,
                      decoration: const InputDecoration(
                        labelText: '指定搜查人员',
                        hintText: '指定搜查人员',
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                  ),
                  Container(
                    width: 150,
                    margin: EdgeInsets.only(top: 20),
                    child: FilledButton(
                      onPressed: () {
                        _getPredictList();
                      },
                      child: const Text("查  询", textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ]),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width > 900 ? MediaQuery.of(context).size.width - 140 : 900,
              // height: 500,
              margin: const EdgeInsets.all(5),
              child: SingleChildScrollView(
                child: PaginatedDataTable(
                  header: const Text('密接人员筛查', style: TextStyle(fontWeight: FontWeight.bold)),
                  actions: <Widget>[
                    IconButton(
                        icon: const Icon(Icons.refresh),
                        tooltip: '刷新页面',
                        onPressed: () {
                          _getPredictList();
                          showToast('刷新成功');
                        }),
                    IconButton(icon: Image.asset('assets/images/export.png'), tooltip: '导出数据', onPressed: () {}),
                  ],
                  onPageChanged: (int page) {},
                  rowsPerPage: _pageSize,
                  availableRowsPerPage: const [5, 10, 20, 50, 100],
                  onRowsPerPageChanged: (int? pageSize) {
                    setState(() => _pageSize = pageSize!);
                  },
                  columns: const <DataColumn>[
                    DataColumn(label: _TableRowTitle('电话号码')),
                    DataColumn(label: _TableRowTitle('姓名')),
                    DataColumn(label: _TableRowTitle('性别')),
                    // DataColumn(label: _TableRowTitle('所属社区')),
                    // DataColumn(label: _TableRowTitle('详细地址')),
                    // DataColumn(label: _TableRowTitle('')),
                  ],
                  source: _UserDataTableSource(context, _userList),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _getPredictList() async {
    List<User>? list = await Network(context).getAllPredict(
      _userController.text.trim(),
    );
    setState(() {
      _userList = list ?? [];
    });
  }

  @override
  bool get wantKeepAlive => true;
}

class _UserDataTableSource extends DataTableSource {
  _UserDataTableSource(this.context, this.data);

  final BuildContext context;
  final List<User> data;
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
        DataCell(Text(data[index].userPhone.toString() ?? "")),
        DataCell(
          TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => UserInfoRoute(data[index])));
              },
              child: Text(data[index].userName.toString() ?? "")),
        ),
        DataCell(Text((data[index].userGender.toString() ?? "") == '0' ? '男' : '女')),
        // DataCell(Text(data[index].userName.toString() ?? "")),
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
