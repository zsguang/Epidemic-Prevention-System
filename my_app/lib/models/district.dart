import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'district.g.dart';

@JsonSerializable()
class District {
  District();

  late String? districtId;
  late String districtName;
  late String districtAddress;
  late String communityId;
  late String communityName;
  bool selected = false;

  factory District.fromJson(Map<String, dynamic> json) => _$DistrictFromJson(json);

  Map<String, dynamic> toJson() => _$DistrictToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  static District? fromString(String? jsonString) {
    if(jsonString == null)  return null;
    final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
    return District.fromJson(jsonData);
  }
}
