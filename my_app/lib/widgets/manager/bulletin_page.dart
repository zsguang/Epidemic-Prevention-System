import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/models/access.dart';
import 'package:provider/provider.dart';

import '../../common/Network.dart';
import '../../common/funs.dart';
import '../../models/bulletin.dart';
import '../../states/profile_change_notifier.dart';
import '../common/date_time_picker.dart';
import 'UserInfoRoute.dart';

class BulletinPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BulletinPageState();
}

class BulletinPageState extends State<BulletinPage> with AutomaticKeepAliveClientMixin {
  bool _filterCheck = false;
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _userController = TextEditingController();
  var _tableKey;
  final GlobalKey _formKey = GlobalKey<FormState>();
  late _UserDataTableSource _dateSource;
  List<Bulletin> _bulletinList = [];
  int _pageSize = 5;

  @override
  void initState() {
    super.initState();
    _getBulletinList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var flag = MediaQuery.of(context).size.width < 730;

    _dateSource = _UserDataTableSource(context, _bulletinList);

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
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: '标题',
                          hintText: '标题',
                          prefixIcon: Icon(Icons.title),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 250,
                      child: TextField(
                        controller: _authorController,
                        decoration: const InputDecoration(
                          labelText: '署名',
                          hintText: '署名',
                          prefixIcon: Icon(Icons.title),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 250,
                      child: TextField(
                        controller: _userController,
                        decoration: const InputDecoration(
                          labelText: '发布者',
                          hintText: '发布者',
                          prefixIcon: Icon(Icons.account_circle_outlined),
                        ),
                      ),
                    ),
                    Container(
                      width: 250,
                      margin: const EdgeInsets.only(top: 20, bottom: 5),
                      child: FilledButton(
                        onPressed: _getBulletinList,
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
                  header: const Text('公告信息', style: TextStyle(fontWeight: FontWeight.bold)),
                  actions: <Widget>[
                    IconButton(
                        icon: const Icon(Icons.refresh),
                        tooltip: '刷新页面',
                        onPressed: () {
                          _getBulletinList();
                          showToast('刷新成功');
                        }),
                    IconButton(icon: const Icon(Icons.add), tooltip: '发布公告', onPressed: showAddBulletinDialog),
                    IconButton(icon: Icon(Icons.delete_forever), tooltip: '删除公告', onPressed: showDeleteAlertDialog),
                    IconButton(icon: Image.asset('assets/images/export.png'), tooltip: '导出数据', onPressed: () {}),
                  ],
                  onPageChanged: (int page) {},
                  rowsPerPage: _pageSize,
                  availableRowsPerPage: const [5, 10, 20, 50, 100],
                  onRowsPerPageChanged: (int? pageSize) {
                    setState(() {
                      _pageSize = pageSize!;
                    });
                  },
                  columns: const <DataColumn>[
                    DataColumn(label: _TableRowTitle('发布时间')),
                    DataColumn(label: _TableRowTitle('标题')),
                    DataColumn(label: _TableRowTitle('署名')),
                    DataColumn(label: _TableRowTitle('发布者')),
                    DataColumn(label: _TableRowTitle('')),
                  ],
                  source: _dateSource,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getBulletinList() async {
    List<Bulletin>? list = await Network(context).getBulletinList(_timeController.text.trim(),
        _titleController.text.trim(), _authorController.text.trim(), _userController.text.trim());
    setState(() {
      _tableKey = UniqueKey();
      _bulletinList = list ?? [];
    });
  }

  Future<void> showAddBulletinDialog() async {
    var mediaQuery = MediaQuery.of(context).size;
    // var size = min(mediaQuery.width, mediaQuery.height) * 0.9;

    TextEditingController titleController = TextEditingController();
    TextEditingController authorController = TextEditingController();
    TextEditingController contentController = TextEditingController();

    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            width: mediaQuery.width * 0.9,
            height: 500,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(children: <Widget>[
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: '标题',
                      hintText: '标题',
                    ),
                    validator: (v) {
                      return v == null || v.trim().isNotEmpty ? null : '公告标题不能为空';
                    },
                  ),
                  TextFormField(
                    controller: authorController,
                    decoration: const InputDecoration(
                      labelText: '署名',
                      hintText: '署名',
                    ),
                    validator: (v) {
                      return v == null || v.trim().isNotEmpty ? null : '公告署名不能为空';
                    },
                  ),
                  TextFormField(
                    controller: contentController,
                    maxLines: null,
                    minLines: 10,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      labelText: '正文',
                      hintText: '正文',
                    ),
                    validator: (v) {
                      return v == null || v.trim().isNotEmpty ? null : '公告正文不能为空';
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 5),
                    width: 150,
                    child: FilledButton(
                      onPressed: () => addBulletin(
                        titleController.text.trim(),
                        authorController.text.trim(),
                        contentController.text,
                      ),
                      child: const Text('确    认'),
                    ),
                  )
                ]),
              ),
            ),
          );
        }),
      ),
    );
  }

  Future<void> addBulletin(String title, String author, String content) async {
    if (!(_formKey.currentState as FormState).validate()) return;

    Bulletin bulletin = Bulletin();
    bulletin.noticeTitle = title;
    bulletin.noticeTime = DateFormat('yyyy-MM-dd').format(DateTime.now());
    bulletin.noticeAuthor = author;
    bulletin.noticeContent = content;
    bulletin.userPhone = Provider.of<UserModel>(context, listen: false).user!.userPhone;

    bool result = await Network(context).addBulletin(bulletin);
    if (result) {
      showToast('发布成功');
      Navigator.of(context).pop();
      setState(() {});
    } else {
      showToast('发布失败');
    }
  }

  void showDeleteAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text("您确定删除公告吗？"),
          actions: [
            FilledButton(
              child: const Text("取消"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FilledButton(
              onPressed: deleteBulletins,
              child: const Text("确定"),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteBulletins() async {
    List<Bulletin> list = _dateSource.getSelectList();
    if(list.isEmpty){
      showToast('未选择删除公告');
      Navigator.of(context).pop();
      return;
    }
    bool result = await Network(context).deleteBulletin(list);
    if (result) {
      showToast('删除成功');
    } else {
      showToast('删除失败');
    }
    Navigator.of(context).pop();
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;
}

class _UserDataTableSource extends DataTableSource {
  _UserDataTableSource(this.context, this.data);

  final BuildContext context;
  final List<Bulletin> data;

  // int pageSize = 0;
  // int total = 0;

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
        DataCell(Text(data[index].noticeTime ?? "")),
        DataCell(
          TextButton(
            onPressed: () => Navigator.of(context).pushNamed("bulletinInfo", arguments: {'bulletin': data[index]}),
            child: Text(data[index].noticeTitle ?? ""),
          ),
        ),
        DataCell(Text(data[index].noticeAuthor ?? "")),
        DataCell(
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => UserInfoRoute(data[index].user!)));
            },
            child: Text(data[index].user?.userName ?? ""),
          ),
        ),
        DataCell(
          TextButton(
            onPressed: () => showEditBulletinDialog(data[index]),
            child: Text("修改"),
          ),
        ),
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

  List<Bulletin> getSelectList() {
    List<Bulletin> list = [];
    for (int i = 0; i < data.length; i++) {
      if (data[i].selected) list.add(data[i]);
    }
    return list;
  }

  final GlobalKey formKey = GlobalKey<FormState>();

  Future<void> showEditBulletinDialog(Bulletin bulletin) async {
    var mediaQuery = MediaQuery.of(context).size;

    TextEditingController titleController = TextEditingController();
    titleController.text = bulletin.noticeTitle;
    TextEditingController authorController = TextEditingController();
    authorController.text = bulletin.noticeAuthor;
    TextEditingController contentController = TextEditingController();
    contentController.text = bulletin.noticeContent;

    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            width: mediaQuery.width * 0.9,
            height: 500,
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(children: <Widget>[
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: '标题',
                      hintText: '标题',
                    ),
                    validator: (v) {
                      return v == null || v.trim().isNotEmpty ? null : '公告标题不能为空';
                    },
                  ),
                  TextFormField(
                    controller: authorController,
                    decoration: const InputDecoration(
                      labelText: '署名',
                      hintText: '署名',
                    ),
                    validator: (v) {
                      return v == null || v.trim().isNotEmpty ? null : '公告署名不能为空';
                    },
                  ),
                  TextFormField(
                    controller: contentController,
                    maxLines: null,
                    minLines: 10,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      labelText: '正文',
                      hintText: '正文',
                    ),
                    validator: (v) {
                      return v == null || v.trim().isNotEmpty ? null : '公告正文不能为空';
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 5),
                    width: 150,
                    child: FilledButton(
                      onPressed: () {
                        if (!(formKey.currentState as FormState).validate()) return;
                        bulletin.noticeTitle = titleController.text;
                        bulletin.noticeAuthor = authorController.text;
                        bulletin.noticeContent = contentController.text;
                        editBulletin(bulletin);
                      },
                      child: const Text('修    改'),
                    ),
                  )
                ]),
              ),
            ),
          );
        }),
      ),
    );
  }

  Future<void> editBulletin(Bulletin bulletin) async {
    bool result = await Network(context).editBulletin(bulletin);
    if (result) {
      showToast('修改成功');
      Navigator.of(context).pop();
    } else {
      showToast('修改失败');
    }
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
