import 'package:json_annotation/json_annotation.dart';

part 'result_object.g.dart';

@JsonSerializable()
class Result_object {
  Result_object();

  late String code;
  late String msg;
  Map<String,dynamic>? data;
  
  factory Result_object.fromJson(Map<String,dynamic> json) => _$Result_objectFromJson(json);
  Map<String, dynamic> toJson() => _$Result_objectToJson(this);
}
