import 'package:json_annotation/json_annotation.dart';

part 'pageObject.g.dart';

@JsonSerializable()
class PageObject {
  PageObject();

  List? records;
  num? total;
  num? size;
  num? current;
  List? orders;
  bool? optimizeCountSql;
  bool? searchCount;
  String? countId;
  String? maxLimit;
  num? pages;
  
  factory PageObject.fromJson(Map<String,dynamic> json) => _$PageObjectFromJson(json);
  Map<String, dynamic> toJson() => _$PageObjectToJson(this);
}
