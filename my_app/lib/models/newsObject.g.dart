// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'newsObject.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsObject _$NewsObjectFromJson(Map<String, dynamic> json) => NewsObject()
  ..results = (json['results'] as List<dynamic>).map((e) => News.fromJson(e as Map<String, dynamic>)).toList()
  ..success = json['success'] as bool;

Map<String, dynamic> _$NewsObjectToJson(NewsObject instance) =>
    <String, dynamic>{
      'results': instance.results,
      'success': instance.success,
    };
