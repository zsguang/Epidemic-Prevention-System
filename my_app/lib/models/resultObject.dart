import 'package:json_annotation/json_annotation.dart';

part 'resultObject.g.dart';

@JsonSerializable()
class ResultObject {
  ResultObject();

  late String code;
  late String msg;
  Map<String,dynamic>? data;
  
  factory ResultObject.fromJson(Map<String,dynamic> json) => _$ResultObjectFromJson(json);
  Map<String, dynamic> toJson() => _$ResultObjectToJson(this);
}
