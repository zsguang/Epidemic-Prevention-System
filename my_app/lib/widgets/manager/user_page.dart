import 'package:flutter/material.dart';
import 'package:my_app/common/funs.dart';
import 'package:my_app/models/index.dart';
import 'package:my_app/widgets/manager/UserInfoRoute.dart';

import '../../common/Network.dart';
import '../../l10n/localization_intl.dart';
import '../../models/user.dart';

class UserPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UserPageState();
}

class UserPageState extends State<UserPage> with AutomaticKeepAliveClientMixin {
  bool _filterCheck = false;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idCardController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _managerYesCheck = false;
  bool _managerNoCheck = false;
  bool _oneCheck = false;
  bool _twoCheck = false;
  bool _threeCheck = false;
  List<User> _userList = [];
  int _pageSize = 5;

  @override
  void initState() {
    super.initState();
    _getUserList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var gm = GmLocalizations.of(context);
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
                child: Wrap(
                  alignment: WrapAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 250,
                      child: TextField(
                        maxLength: 11,
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: gm.phone,
                          hintText: gm.phone,
                          prefixIcon: Icon(Icons.phone),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 250,
                      child: TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: gm.name,
                          hintText: gm.name,
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 250,
                      child: TextField(
                        controller: _idCardController,
                        maxLength: 18,
                        decoration: InputDecoration(
                          labelText: gm.idCard,
                          hintText: gm.idCard,
                          prefixIcon: Icon(Icons.credit_card_sharp),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 250,
                      child: TextField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          labelText: '居住地址',
                          hintText: '居住地址',
                          prefixIcon: Image.asset('assets/images/address.png'),
                        ),
                      ),
                    ),
                    Container(
                        alignment: Alignment.center,
                        width: 250,
                        height: 70,
                        child: Wrap(
                          children: [
                            Text("风险等级:"),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                  value: _oneCheck,
                                  onChanged: (value) {
                                    setState(() => _oneCheck = value!);
                                  },
                                ),
                                Text("1级", style: TextStyle(color: Colors.green)),
                                SizedBox(width: 15),
                                Checkbox(
                                  value: _twoCheck,
                                  onChanged: (value) {
                                    setState(() => _twoCheck = value!);
                                  },
                                ),
                                Text("2级", style: TextStyle(color: Colors.orange)),
                                SizedBox(width: 15),
                                Checkbox(
                                  value: _threeCheck,
                                  onChanged: (value) {
                                    setState(() => _threeCheck = value!);
                                  },
                                ),
                                Text("3级", style: TextStyle(color: Colors.red)),
                              ],
                            )
                          ],
                        )),
                    Container(
                        alignment: flag ? Alignment.topLeft : Alignment.center,
                        width: 250,
                        height: 70,
                        child: Row(
                          children: [
                            Text("是否管理员："),
                            Checkbox(
                                value: _managerYesCheck,
                                onChanged: (value) {
                                  setState(() => _managerYesCheck = value!);
                                }),
                            Text("是"),
                            const SizedBox(width: 20),
                            Checkbox(
                                value: _managerNoCheck,
                                onChanged: (value) {
                                  setState(() => _managerNoCheck = value!);
                                }),
                            Text("否"),
                          ],
                        )),
                    Container(
                      width: 150,
                      margin: EdgeInsets.only(top: 20),
                      child: FilledButton(
                        onPressed: () {
                          _getUserList();
                        },
                        child: const Text("查  询", textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
                      ),
                    ),
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
                          _getUserList();
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
                    // _getUserList();
                  },
                  columns: const <DataColumn>[
                    DataColumn(label: _TableRowTitle('电话号码')),
                    DataColumn(label: _TableRowTitle('姓名')),
                    DataColumn(label: _TableRowTitle('性别')),
                    // DataColumn(label: _TableRowTitle('所属社区')),
                    DataColumn(label: _TableRowTitle('详细地址')),
                    DataColumn(label: _TableRowTitle('')),
                  ],
                  source: _UserDataTableSource(context, _userList),
                ),
              ),
            ),
          ],
        ),
      ),
      // ),
    );
  }

  @override
  bool get wantKeepAlive {
    return true;
  }

  void _getUserList() async {
    String health = '';
    if (_oneCheck) health += '0';
    if (_twoCheck) health += '1';
    if (_threeCheck) health += '2';
    String manager = '';
    if (_managerNoCheck) manager += '0';
    if (_managerYesCheck) manager += '1';
    List<User>? list = await Network(context).getAllUser(
      _phoneController.text.trim(),
      _nameController.text.trim(),
      _idCardController.text.trim(),
      _addressController.text.trim(),
      health,
      manager,
    );
    // List<User>? list = (list?.records)?.map((e) => User.fromJson(e as Map<String, dynamic>)).toList() ?? [];
    setState(() {
      _userList = list ?? [];
      // _total = list?.total ?? 0;
    });
  }
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
        DataCell(Text(data[index].userName.toString() ?? "")),
        DataCell(Text((data[index].userGender.toString() ?? "") == '0' ? '男' : '女')),
        // DataCell(_TableRow(data[index].userCommunity.toString() ?? "")),
        DataCell(Text(data[index].userAddress.toString() ?? "")),
        DataCell(
          TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => UserInfoRoute(data[index])));
              },
              child: Text("详细信息")),
        )
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

class _TableRow extends StatelessWidget {
  final String text;

  const _TableRow(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        text,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
