import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/community.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../common/Network.dart';
import '../../common/funs.dart';
import '../../l10n/localization_intl.dart';
import '../../models/user.dart';

class CommunityPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CommunityPageState();
}

class CommunityPageState extends State<CommunityPage> with AutomaticKeepAliveClientMixin {
  bool _filterCheck = false;
  final TextEditingController _searchController = TextEditingController();
  var _tableKey;
  final GlobalKey _formKey = GlobalKey<FormState>();
  List<Community> _communityList = [];
  int _pageSize = 5;

  @override
  void initState() {
    super.initState();
    _tableKey = UniqueKey();
    _getCommunityList();
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 350,
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        labelText: '社区编号/社区名称/社区地址',
                        hintText: '社区编号/社区名称/社区地址',
                        prefixIcon: Icon(Icons.account_balance_outlined),
                      ),
                    ),
                  ),
                  Container(
                    width: 250,
                    margin: const EdgeInsets.only(top: 20, bottom: 5),
                    child: FilledButton(
                      onPressed: _getCommunityList,
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
                key: _tableKey,
                header: const Text('社区信息', style: TextStyle(fontWeight: FontWeight.bold)),
                actions: <Widget>[
                  IconButton(
                      icon: const Icon(Icons.refresh),
                      tooltip: '刷新页面',
                      onPressed: () {
                        _getCommunityList();
                        showToast('刷新成功');
                      }),
                  IconButton(icon: const Icon(Icons.add), tooltip: '添加社区', onPressed: showAddCommunityDialog),
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
                  DataColumn(label: _TableRowTitle('社区编号')),
                  DataColumn(label: _TableRowTitle('社区名称')),
                  DataColumn(label: _TableRowTitle('社区地址')),
                  // DataColumn(label: _TableRowTitle('二维码')),
                ],
                source: _CommunityDataTableSource(context, _communityList),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Future<void> _getCommunityList() async {
    List<Community>? list = await Network(context).getCommunityList(_searchController.text.trim());
    setState(() {
      _tableKey = UniqueKey();
      _communityList = list ?? [];
    });
  }

  void showAddCommunityDialog() {
    var mediaQuery = MediaQuery.of(context).size;
    var size = min(mediaQuery.width, mediaQuery.height) * 0.9;

    TextEditingController _idController = TextEditingController();
    TextEditingController _nameController = TextEditingController();
    TextEditingController _addressController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        content: Container(
          width: size,
          height: 350,
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                const Text("社区信息", style: TextStyle(fontSize: 18)),
                TextFormField(
                  controller: _idController,
                  decoration: InputDecoration(
                    labelText: '社区编号',
                    hintText: '社区编号',
                    prefixIcon: Image.asset('assets/images/numid.png'),
                  ),
                  validator: (v) {
                    return v == null || v.trim().isNotEmpty ? null : '社区编号不能为空';
                  },
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: '社区名字',
                    hintText: '社区名字',
                    prefixIcon: Icon(Icons.account_balance_outlined),
                  ),
                  validator: (v) {
                    return v == null || v.trim().isNotEmpty ? null : '社区名字不能为空';
                  },
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: '社区地址',
                    hintText: '社区地址',
                    prefixIcon: Image.asset('assets/images/address.png'),
                  ),
                  validator: (v) {
                    return v == null || v.trim().isNotEmpty ? null : '社区地址不能为空';
                  },
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30, bottom: 10),
                  width: 150,
                  child: FilledButton(
                    onPressed: () => addCommunity(
                      _idController.text.trim(),
                      _nameController.text.trim(),
                      _addressController.text.trim(),
                    ),
                    child: Text('确    认'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addCommunity(String id, String name, String address) async {
    if (!(_formKey.currentState as FormState).validate()) return;
    Community community = Community();
    community.communityId = id;
    community.communityName = name;
    community.communityAddress = address;
    bool result = await Network(context).addCommunity(community);
    if (result) Navigator.of(context).pop();
  }

  @override
  bool get wantKeepAlive => true;
}

class _CommunityDataTableSource extends DataTableSource {
  _CommunityDataTableSource(this.context, this.data);

  final BuildContext context;
  final List<Community> data;
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
        DataCell(Text(data[index].communityId.toString() ?? "")),
        DataCell(Text(data[index].communityName.toString() ?? "")),
        DataCell(Text(data[index].communityAddress.toString() ?? "")),
        // DataCell(
        //   TextButton(onPressed: () => _showQrCode(data[index]), child: const Icon(Icons.qr_code_2_rounded)),
        // ),
      ],
    );
  }

  void _showQrCode(Community community) async {
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
                data: community.toString(),
                errorStateBuilder: (context, object) => const Icon(Icons.qr_code_2_sharp),
              ),
              Text(community.communityName)
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
