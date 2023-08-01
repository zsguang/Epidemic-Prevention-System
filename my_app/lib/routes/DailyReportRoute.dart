import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/models/dailyReport.dart';
import 'package:provider/provider.dart';

import '../common/Network.dart';
import '../l10n/localization_intl.dart';
import '../states/profile_change_notifier.dart';

class DailyReportRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DailyReportRouteState();
}

class DailyReportRouteState extends State<DailyReportRoute> {
  bool _btnSave = true;
  int _saveFlag = 0;

  final TextEditingController _tempController = TextEditingController();
  final List<DropdownMenuItem> _tempList = [];
  var _tempValue = '35.0';
  int _coughed = 0;
  int _diarrheaed = 0;
  int _weaked = 0;

  @override
  void initState() {
    super.initState();
    for (var i = 35.0; i <= 40.5; i += 0.1) {
      _tempList.add(DropdownMenuItem(value: i.toStringAsFixed(1), child: Text('    ${i.toStringAsFixed(1)}    ')));
    }
  }

  @override
  Widget build(BuildContext context) {
    GmLocalizations gm = GmLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(gm.dailyReport),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 240,
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text('体温(℃)：', style: TextStyle(fontSize: 16)),
                    DropdownButton(
                      value: _tempValue,
                      items: _tempList,
                      onChanged: (value) => setState(() => _tempValue = value!.toString()),
                    ),
                  ],
                ),
                Row(children: [
                  const Text('是否咳嗽：', style: TextStyle(fontSize: 16)),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio(value: 0, groupValue: _coughed, onChanged: (v) => setState(() => _coughed = v!)),
                      Text("否")
                    ],
                  ),
                  const SizedBox(width: 10),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio(value: 1, groupValue: _coughed, onChanged: (v) => setState(() => _coughed = v!)),
                      Text("是")
                    ],
                  ),
                ]),
                Row(children: [
                  const Text('是否腹泻：', style: TextStyle(fontSize: 16)),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio(value: 0, groupValue: _diarrheaed, onChanged: (v) => setState(() => _diarrheaed = v!)),
                      Text("否")
                    ],
                  ),
                  const SizedBox(width: 10),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio(value: 1, groupValue: _diarrheaed, onChanged: (v) => setState(() => _diarrheaed = v!)),
                      Text("是")
                    ],
                  ),
                ]),
                Row(children: [
                  const Text('是否乏力：', style: TextStyle(fontSize: 16)),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio(value: 0, groupValue: _weaked, onChanged: (v) => setState(() => _weaked = v!)),
                      Text("否")
                    ],
                  ),
                  const SizedBox(width: 10),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio(value: 1, groupValue: _weaked, onChanged: (v) => setState(() => _weaked = v!)),
                      Text("是")
                    ],
                  ),
                ]),
                Container(
                  width: 150,
                  child: FilledButton(
                    onPressed: _btnSave ? addDailyReport : null,
                    child: const Text('提  交', style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 20),
                Visibility(
                  visible: _saveFlag != 0,
                  child: _saveFlag == 1
                      ? const Text('提交成功', style: TextStyle(fontSize: 20, color: Colors.green))
                      : const Text('提交失败', style: TextStyle(fontSize: 20, color: Colors.red)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addDailyReport() async {
    DailyReport dailyReport = DailyReport();
    dailyReport.reportTime = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
    dailyReport.temperature = double.parse(_tempValue);
    dailyReport.coughed = '$_coughed';
    dailyReport.diarrheaed = '$_diarrheaed';
    dailyReport.weaked = '$_weaked';
    dailyReport.userPhone = Provider.of<UserModel>(context, listen: false).user?.userPhone;

    bool result = await Network(context).addDailyReport(dailyReport);
    if (result) {
      _btnSave = false;
      _saveFlag = 1;
    } else {
      _saveFlag = 2;
    }
    setState(() {});
  }
}
