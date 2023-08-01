// import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';
import 'package:my_app/models/user.dart';

part 'dailyReport.g.dart';

@JsonSerializable()
class DailyReport {
  DailyReport();

  int? id;
  String? reportTime;
  double? temperature;
  String? coughed;
  String? diarrheaed;
  String? weaked;
  String? userPhone;
  User? user;

  bool selected = false;

  factory DailyReport.fromJson(Map<String,dynamic> json) => _$DailyReportFromJson(json);
  Map<String, dynamic> toJson() => _$DailyReportToJson(this);
}
