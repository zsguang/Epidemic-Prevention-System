// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resultString.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResultString _$ResultStringFromJson(Map<String, dynamic> json) => ResultString()
  ..code = json['code'] as String
  ..msg = json['msg'] as String
  ..data = json['data'] as String?;

Map<String, dynamic> _$ResultStringToJson(ResultString instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data,
    };
