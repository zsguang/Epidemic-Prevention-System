import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class  ClockWidget extends StatefulWidget {
  @override
  _ClockWidgetState createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> {
  DateTime _dateTime = DateTime.now();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _dateTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      DateFormat('yyyy-MM-dd HH:mm:ss').format(_dateTime),
      style: TextStyle(fontSize: 20),
    );
  }
}
