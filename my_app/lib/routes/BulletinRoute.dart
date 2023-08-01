import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/models/bulletin.dart';

import '../common/Network.dart';
import '../common/funs.dart';
import '../l10n/localization_intl.dart';
import '../models/news.dart';

class BulletinRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BulletinRouteState();
}

class _BulletinRouteState extends State<BulletinRoute> {
  List<Bulletin> _newsList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    GmLocalizations gm = GmLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(gm.communityBulletin)),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: _newsList.isEmpty
            ? Container(
                child: Text("数据加载中..."),
              )
            : ListView(
                children: <Widget>[
                  ..._newsList.map((b) => _BulletinWidget(bulletin: b)).toList(),
                  // TextButton(
                  //   onPressed: () {
                  //     // _page++;
                  //     _loadData();
                  //   },
                  //   child: const Text('查看更多', style: TextStyle(fontSize: 18)),
                  // )
                ],
              ),
      ),
    );
  }

  void _loadData() async {
    _showProgressDialog();
    List<Bulletin>? list = await Network(context).getBulletinList('', '', '', '');
    if (list == null || list.isEmpty) {
      showToast("没有更多公告了");
    } else {
      _newsList = list;
    }
    Navigator.of(context).pop();
    setState(() {});
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

class _BulletinWidget extends StatelessWidget {
  final Bulletin bulletin;
  final Function? onPress;

  const _BulletinWidget({super.key, required this.bulletin, this.onPress});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Text("∎ ", style: TextStyle(fontSize: 16, color: Colors.red)),
            Text(bulletin.noticeTime, style: const TextStyle(fontSize: 16)),
          ]),
          const SizedBox(height: 4),
          Material(
            color: Color(0xFFEFEFEF),
            child: InkWell(
              onTap: () => Navigator.of(context).pushNamed("bulletinInfo", arguments: {'bulletin': bulletin}),
              child: Container(
                padding: EdgeInsets.all(6),
                alignment: Alignment.topLeft,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bulletin.noticeTitle,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    const SizedBox(height: 6),
                    Text('来源：${bulletin.noticeAuthor}', style: const TextStyle(fontSize: 14, color: Colors.grey))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
