// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Result _$ResultFromJson(Map<String, dynamic> json) => Result()
  ..code = json['code'] as String
  ..msg = json['msg'] as String
  ..data = json['data'];

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data,
    };
