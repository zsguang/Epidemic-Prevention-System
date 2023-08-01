// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pageObject.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PageObject _$PageObjectFromJson(Map<String, dynamic> json) => PageObject()
  ..records = json['records'] as List<dynamic>?
  ..total = json['total'] as num?
  ..size = json['size'] as num?
  ..current = json['current'] as num?
  ..orders = json['orders'] as List<dynamic>?
  ..optimizeCountSql = json['optimizeCountSql'] as bool?
  ..searchCount = json['searchCount'] as bool?
  ..countId = json['countId'] as String?
  ..maxLimit = json['maxLimit'] as String?
  ..pages = json['pages'] as num?;

Map<String, dynamic> _$PageObjectToJson(PageObject instance) =>
    <String, dynamic>{
      'records': instance.records,
      'total': instance.total,
      'size': instance.size,
      'current': instance.current,
      'orders': instance.orders,
      'optimizeCountSql': instance.optimizeCountSql,
      'searchCount': instance.searchCount,
      'countId': instance.countId,
      'maxLimit': instance.maxLimit,
      'pages': instance.pages,
    };
