import 'package:json_annotation/json_annotation.dart';

part 'result.g.dart';

@JsonSerializable()
class Result {
  Result();

  late String code;
  late String msg;
  dynamic? data;
  
  factory Result.fromJson(Map<String,dynamic> json) => _$ResultFromJson(json);
  Map<String, dynamic> toJson() => _$ResultToJson(this);
}
