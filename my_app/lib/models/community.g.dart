// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Community _$CommunityFromJson(Map<String, dynamic> json) => Community()
  ..communityId = json['communityId'] as String
  ..communityName = json['communityName'] as String
  ..communityAddress = json['communityAddress'] as String;

Map<String, dynamic> _$CommunityToJson(Community instance) => <String, dynamic>{
      'communityId': instance.communityId,
      'communityName': instance.communityName,
      'communityAddress': instance.communityAddress,
    };
