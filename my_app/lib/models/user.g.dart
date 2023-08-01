// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User()
  ..userPhone = json['userPhone'] as String
  ..userIdcard = json['userIdcard'] as String?
  ..userName = json['userName'] as String?
  ..password = json['password'] as String?
  ..userGender = json['userGender'] as String?
  ..districtId = json['districtId'] as String?
  ..userAddress = json['userAddress'] as String?
  ..userBirthday = json['userBirthday'] as String?
  ..manager = json['manager'] as String?
  ..health = json['health'] as String?
  ..avatar = json['avatar'] as String?
  ..district = json['district'] == null ? null : District.fromJson(json['district']);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'userPhone': instance.userPhone,
      'userIdcard': instance.userIdcard,
      'userName': instance.userName,
      'password': instance.password,
      'userGender': instance.userGender,
      'districtId': instance.districtId,
      'userAddress': instance.userAddress,
      'userBirthday': instance.userBirthday,
      'manager': instance.manager,
      'health': instance.health,
      'avatar': instance.avatar,
      'district': instance.district == null ? null : instance.district,
    };
