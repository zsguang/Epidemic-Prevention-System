import 'package:json_annotation/json_annotation.dart';

part 'string_data.g.dart';

@JsonSerializable()
class StringData {
  StringData();

  late String data;
  
  factory StringData.fromJson(Map<String,dynamic> json) => _$StringDataFromJson(json);
  Map<String, dynamic> toJson() => _$StringDataToJson(this);
}
