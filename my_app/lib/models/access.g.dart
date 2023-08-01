// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Access _$AccessFromJson(Map<String, dynamic> json) => Access()
  ..id = json['id'] as int?
  ..accessTime = json['accessTime'] as String
  ..userPhone = json['userPhone'] as String
  ..districtId = json['districtId'] as String
  ..outProvince = json['outProvince'] as String?
  ..user = User.fromJson(json['user'])
  ..district = District.fromJson(json['district']);

Map<String, dynamic> _$AccessToJson(Access instance) {
  final Map<String, dynamic> json = <String, dynamic>{};
  if (instance.id != null) json['id'] = instance.id;
  json['accessTime'] = instance.accessTime;
  json['userPhone'] = instance.userPhone;
  json['districtId'] = instance.districtId;
  json['outProvince'] = instance.outProvince;
  if (instance.user != null) json['user'] = instance.user!.toJson();
  if (instance.district != null) json['district'] = instance.district!.toJson();
  return json;
}

// Map<String, dynamic> _$AccessToJson(Access instance) => <String, dynamic>{
//       'id': instance.id,
//       'accessTime': instance.accessTime,
//       'userPhone': instance.userPhone,
//       'districtId': instance.districtId,
//       'outProvince': instance.outProvince,
//       'user': instance.user,
//       'district': instance.district,
//     };
