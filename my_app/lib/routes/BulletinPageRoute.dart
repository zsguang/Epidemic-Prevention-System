import 'package:flutter/material.dart';
import 'package:my_app/models/bulletin.dart';

class BulletinPageRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BulletinInfoState();
}

class BulletinInfoState extends State<BulletinPageRoute> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Bulletin bulletin = args['bulletin'];
    List<String> time = bulletin.noticeTime.split("-");

    return Scaffold(
      appBar: AppBar(title: Text('公告')),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: Column(
            children: [
              Text(
                textAlign: TextAlign.center,
                "${bulletin.noticeTitle}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _IndentedText(
                text: bulletin.noticeContent,
                style: const TextStyle(fontSize: 16),
                indentation: 8,
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                width: MediaQuery.of(context).size.width,
                child: Text(textAlign: TextAlign.right, bulletin.noticeAuthor),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Text(textAlign: TextAlign.right, '${time[0]}年${time[1]}月${time[2]}日'),
              ),

              // Text(
              //   DateFormat("yyyy-MM-dd HH:mm").format(
              //     DateTime.fromMillisecondsSinceEpoch(1599286522985),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
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
    // if (!paragraphs.isEmpty) paddedTextWidgets[0] = Text(paragraphs[0]);

    //返回该组件的根部件
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: paddedTextWidgets,
      ),
    );
  }
}
