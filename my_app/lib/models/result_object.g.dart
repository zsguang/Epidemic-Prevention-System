// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Result_object _$Result_objectFromJson(Map<String, dynamic> json) =>
    Result_object()
      ..code = json['code'] as String
      ..msg = json['msg'] as String
      ..data = json['data'] as Map<String, dynamic>?;

Map<String, dynamic> _$Result_objectToJson(Result_object instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data,
    };
