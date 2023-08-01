// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dailyReport.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyReport _$DailyReportFromJson(Map<String, dynamic> json) => DailyReport()
  ..id = json['id'] as int
  ..reportTime = json['reportTime'] as String?
  ..temperature = json['temperature'] as double?
  ..coughed = json['coughed'] as String?
  ..diarrheaed = json['diarrheaed'] as String?
  ..weaked = json['weaked'] as String?
  ..userPhone = json['userPhone'] as String?
  ..user = json['user'] == null ? null : User.fromJson(json['user']);

Map<String, dynamic> _$DailyReportToJson(DailyReport instance) {
  final Map<String, dynamic> json = <String, dynamic>{};
  if (instance.id != null) json['id'] = instance.id;
  json['reportTime'] = instance.reportTime;
  json['temperature'] = instance.temperature;
  json['coughed'] = instance.coughed;
  json['diarrheaed'] = instance.diarrheaed;
  json['weaked'] = instance.weaked;
  json['userPhone'] = instance.userPhone;
  return json;
}
