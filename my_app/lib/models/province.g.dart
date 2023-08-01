// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'province.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Province _$ProvinceFromJson(Map<String, dynamic> json) => Province()
  ..locationId = json['locationId'] as num?
  ..continentName = json['continentName'] as String?
  ..continentEnglishName = json['continentEnglishName'] as String?
  ..countryName = json['countryName'] as String?
  ..countryEnglishName = json['countryEnglishName'] as String?
  ..countryFullName = json['countryFullName'] as String?
  ..provinceName = json['provinceName'] as String?
  ..provinceEnglishName = json['provinceEnglishName'] as String?
  ..provinceShortName = json['provinceShortName'] as String?
  ..currentConfirmedCount = json['currentConfirmedCount'] as num?
  ..confirmedCount = json['confirmedCount'] as num?
  ..suspectedCount = json['suspectedCount'] as num?
  ..curedCount = json['curedCount'] as num?
  ..deadCount = json['deadCount'] as num?
  ..comment = json['comment'] as String?
  ..cities = (json['cities'] as List<dynamic>?)?.map((e) => City.fromJson(e as Map<String, dynamic>)).toList()
  ..updateTime = json['updateTime'] as num?;

Map<String, dynamic> _$ProvinceToJson(Province instance) => <String, dynamic>{
      'locationId': instance.locationId,
      'continentName': instance.continentName,
      'continentEnglishName': instance.continentEnglishName,
      'countryName': instance.countryName,
      'countryEnglishName': instance.countryEnglishName,
      'countryFullName': instance.countryFullName,
      'provinceName': instance.provinceName,
      'provinceEnglishName': instance.provinceEnglishName,
      'provinceShortName': instance.provinceShortName,
      'currentConfirmedCount': instance.currentConfirmedCount,
      'confirmedCount': instance.confirmedCount,
      'suspectedCount': instance.suspectedCount,
      'curedCount': instance.curedCount,
      'deadCount': instance.deadCount,
      'comment': instance.comment,
      'cities': instance.cities,
      'updateTime': instance.updateTime,
    };
