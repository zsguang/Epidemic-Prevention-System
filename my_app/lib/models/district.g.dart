// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'district.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

District _$DistrictFromJson(Map<String, dynamic> json) => District()
  ..districtId = json['districtId'] as String?
  ..districtName = json['districtName'] as String
  ..districtAddress = json['districtAddress'] as String
  ..communityId = json['communityId'] as String
  ..communityName = json['communityName'] as String;

Map<String, dynamic> _$DistrictToJson(District instance) => <String, dynamic>{
      'districtId': instance.districtId,
      'districtName': instance.districtName,
      'districtAddress': instance.districtAddress,
      'communityId': instance.communityId,
      'communityName': instance.communityName,
    };
