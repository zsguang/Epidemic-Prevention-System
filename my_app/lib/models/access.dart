import 'package:json_annotation/json_annotation.dart';
import 'package:my_app/models/index.dart';

part 'access.g.dart';

@JsonSerializable()
class Access {
  Access();

  int? id;
  late String accessTime;
  late String userPhone;
  late String districtId;
  String? outProvince;
  User? user;
  District? district;
  bool selected = false;

  factory Access.fromJson(Map<String, dynamic> json) => _$AccessFromJson(json);

  Map<String, dynamic> toJson() => _$AccessToJson(this);
}
