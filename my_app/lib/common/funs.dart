import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;


class MyToast {
  static int info = 0;
  static int success = 1;
  static int warning = 2;
  static int error = 3;
}

void showToast(String msg, {time = 2}) {
  var cancel = BotToast.showText(text: msg, duration: Duration(seconds: time));
  // cancel();
}

// void showToast1(
//   String text, {
//   gravity = ToastGravity.CENTER,
//   toastLength = Toast.LENGTH_SHORT,
// }) {
//   Fluttertoast.showToast(
//     msg: text,
//     toastLength: Toast.LENGTH_SHORT,
//     gravity: gravity,
//     backgroundColor: Colors.grey[600],
//     fontSize: 16.0,
//   );
// }

void showLoading(context, [String? text]) {
  String text1 = text ?? "Loading...";
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Center(
          child: Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(3.0), boxShadow: [
              //阴影
              BoxShadow(
                color: Colors.black12,
                //offset: Offset(2.0,2.0),
                blurRadius: 10.0,
              )
            ]),
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.all(16),
            constraints: BoxConstraints(minHeight: 120, minWidth: 180),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    text1,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

void showLog(String name, String message) {
  developer.log(message, name: name);
}
