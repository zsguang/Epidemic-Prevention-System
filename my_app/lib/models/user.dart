import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:my_app/models/index.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  User();

  late String userPhone;
  String? userIdcard;
  String? userName;
  String? password;
  String? userGender;
  String? districtId;
  String? userAddress;
  String? userBirthday;
  String? manager;
  String? health;
  String? avatar;

  District? district;
  bool selected = false;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  String toString() {
    final map = toJson();
    map.remove('password');
    return jsonEncode(map);
  }

  static User? fromString(String? jsonString) {
    if (jsonString == null) return null;
    final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
    return User.fromJson(jsonData);
  }
}
