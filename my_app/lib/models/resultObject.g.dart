// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resultObject.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResultObject _$ResultObjectFromJson(Map<String, dynamic> json) => ResultObject()
  ..code = json['code'] as String
  ..msg = json['msg'] as String
  ..data = json['data'] as Map<String, dynamic>?;

Map<String, dynamic> _$ResultObjectToJson(ResultObject instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data,
    };
