// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

City _$CityFromJson(Map<String, dynamic> json) => City()
  ..cityName = json['cityName'] as String
  ..currentConfirmedCount = json['currentConfirmedCount'] as int?
  ..confirmedCount = json['confirmedCount'] as int?
  ..suspectedCount = json['suspectedCount'] as int?
  ..curedCount = json['curedCount'] as int?
  ..deadCount = json['deadCount'] as int?
  ..highDangerCount = json['highDangerCount'] as int?
  ..midDangerCount = json['midDangerCount'] as int?
  ..locationId = json['locationId'] as int?
  ..currentConfirmedCountStr = json['currentConfirmedCountStr'] as String?
  ..cityEnglishName = json['cityEnglishName'] as String?;

Map<String, dynamic> _$CityToJson(City instance) => <String, dynamic>{
      'cityName': instance.cityName,
      'currentConfirmedCount': instance.currentConfirmedCount,
      'confirmedCount': instance.confirmedCount,
      'suspectedCount': instance.suspectedCount,
      'curedCount': instance.curedCount,
      'deadCount': instance.deadCount,
      'highDangerCount': instance.highDangerCount,
      'midDangerCount': instance.midDangerCount,
      'locationId': instance.locationId,
      'currentConfirmedCountStr': instance.currentConfirmedCountStr,
      'cityEnglishName': instance.cityEnglishName,
    };
