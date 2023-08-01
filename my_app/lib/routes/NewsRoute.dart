import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/common/funs.dart';
import 'package:my_app/models/index.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/localization_intl.dart';

class NewsRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var gm = GmLocalizations.of(context);
    return Scaffold(appBar: AppBar(title: Text('新闻')), body: NewsPage());
  }
}

class NewsPage extends StatelessWidget {
  // Widget rightPage = AccountPage();
  bool routeFlag = false;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final News news = args['news'];
    routeFlag = MediaQuery.of(context).size.width < 730;

    showLog('NewsPage', jsonEncode(news));

    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Column(
          children: [
            Text(
              textAlign: TextAlign.center,
              "${news.title}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              width: MediaQuery.of(context).size.width,
              child: Text(
                textAlign: TextAlign.right,
                DateFormat("yyyy-MM-dd HH:mm").format(
                  DateTime.fromMillisecondsSinceEpoch(int.parse("${news.pubDate}")),
                ),
              ),
            ),
            _IndentedText(
              text: '${news.summary}',
              style: const TextStyle(fontSize: 16),
              indentation: 8,
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('消息来源：'),
                  GestureDetector(
                    onTap: () => _launchUrl('${news.sourceUrl}'),
                    child: Text(
                      "${news.infoSource}",
                      style:
                          const TextStyle(fontSize: 16, color: Colors.blue, decoration: TextDecoration.underline),
                    ),
                  )
                ],
              ),
            ),
            // Text(
            //   DateFormat("yyyy-MM-dd HH:mm").format(
            //     DateTime.fromMillisecondsSinceEpoch(1599286522985),
            //   ),
            // ),
          ],
        ),
      ),
    );

    //   Row(children: [
    //   Container(
    //     margin: EdgeInsets.only(bottom: 10),
    //     width: routeFlag ? MediaQuery.of(context).size.width : 370,
    //     child: Column(),
    //   ),
    //   Container(
    //     width: routeFlag ? 0 : MediaQuery.of(context).size.width - 370,
    //     // child: rightPage,
    //   )
    // ]);
  }

  Future<void> _launchUrl(String urlString) async {
    Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      showToast("Could not launch $url");
    }
  }
}

class _IndentedText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final double indentation;

  _IndentedText({required this.text, required this.style, this.indentation = 10});

  @override
  Widget build(BuildContext context) {
    //转换文本为段落列表
    List<String> paragraphs = text.split("\n");

    //创建一个带有段落缩进的widget列表
    List<Widget> paddedTextWidgets = paragraphs.map<Widget>((paragraphText) {
      String paddedText = " " * (paragraphText.trim().isEmpty ? 0 : indentation.toInt()) + paragraphText.trim();
      return Text(paddedText, style: style);
    }).toList();

    List<Widget> columnChildren = [];
    int paddedTextWidgetsLength = paddedTextWidgets.length;
    for (int i = 0; i < paddedTextWidgetsLength; i++) {
      columnChildren.add(paddedTextWidgets[i]);
      // if (i < paddedTextWidgetsLength - 1) {
      //   columnChildren.add(Divider());
      // }
    }

    //返回该组件的根部件
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: columnChildren,
    );
  }
}
