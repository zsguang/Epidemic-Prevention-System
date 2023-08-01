// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

News _$NewsFromJson(Map<String, dynamic> json) => News()
  ..pubDate = json['pubDate'] as String?
  ..title = json['title'] as String?
  ..summary = json['summary'] as String?
  ..infoSource = json['infoSource'] as String?
  ..sourceUrl = json['sourceUrl'] as String?
  ..province = json['province'] as String?
  ..provinceId = json['provinceId'] as String?;

Map<String, dynamic> _$NewsToJson(News instance) => <String, dynamic>{
      'pubDate': instance.pubDate,
      'title': instance.title,
      'summary': instance.summary,
      'infoSource': instance.infoSource,
      'sourceUrl': instance.sourceUrl,
      'province': instance.province,
      'provinceId': instance.provinceId,
    };
