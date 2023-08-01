// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Country _$CountryFromJson(Map<String, dynamic> json) => Country()
  ..results = (json['results'] as List<dynamic>).map((e) => Province.fromJson(e as Map<String, dynamic>)).toList()
  ..success = json['success'] as bool;

Map<String, dynamic> _$CountryToJson(Country instance) => <String, dynamic>{
      'results': instance.results,
      'success': instance.success,
    };
