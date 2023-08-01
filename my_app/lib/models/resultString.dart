import 'package:json_annotation/json_annotation.dart';

part 'resultString.g.dart';

@JsonSerializable()
class ResultString {
  ResultString();

  late String code;
  late String msg;
  String? data;
  
  factory ResultString.fromJson(Map<String,dynamic> json) => _$ResultStringFromJson(json);
  Map<String, dynamic> toJson() => _$ResultStringToJson(this);
}
