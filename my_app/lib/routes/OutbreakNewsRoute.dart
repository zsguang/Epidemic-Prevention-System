import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/common/funs.dart';
import 'package:my_app/models/index.dart';

import '../common/Network.dart';
import '../l10n/localization_intl.dart';

class OutbreakNewsRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OutbreakNewsRouteState();
}

class _OutbreakNewsRouteState extends State<OutbreakNewsRoute> {
  List<News> _newsList = [];
  int _page = 2;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    GmLocalizations gm = GmLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(gm.outbreakNews),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: _newsList.isEmpty
            ? Container(
                child: Text("数据加载中..."),
              )
            : ListView(
                children: <Widget>[
                  ..._newsList.map((e) => _NewsWidget(news: e)).toList(),
                  TextButton(
                    onPressed: () {
                      _page++;
                      _loadData();
                    },
                    child: const Text('查看更多', style: TextStyle(fontSize: 18)),
                  )
                ],
              ),
      ),
    );
  }

  void _loadData() async {
    _showProgressDialog();
    List<News>? list = await Network(context).getNews(_page);
    if (list == null || list.isEmpty) {
      showToast("没有更多新闻了");
    } else {
      _newsList.addAll(list);
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

class _NewsWidget extends StatelessWidget {
  final News news;
  final Function? onPress;

  const _NewsWidget({super.key, required this.news, this.onPress});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Text("∎ ", style: TextStyle(fontSize: 16, color: Colors.red)),
            Text(
              DateFormat("yyyy-MM-dd HH:mm")
                  .format(DateTime.fromMillisecondsSinceEpoch(int.parse("${news.pubDate}"))),
              style: const TextStyle(fontSize: 16),
            ),
          ]),
          const SizedBox(height: 4),
          Material(
            color: Color(0xFFEFEFEF),
            child: InkWell(
              onTap: () => Navigator.of(context).pushNamed("news", arguments: {'news': news}),
              child: Container(
                padding: EdgeInsets.all(6),
                alignment: Alignment.topLeft,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${news.title}",
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    SizedBox(height: 6),
                    Text('消息来源：${news.infoSource}', style: const TextStyle(fontSize: 14, color: Colors.grey))
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
