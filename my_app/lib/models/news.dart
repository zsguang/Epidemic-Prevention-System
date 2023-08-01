import 'package:json_annotation/json_annotation.dart';

part 'news.g.dart';

@JsonSerializable()
class News {
  News();

  String? pubDate;
  String? title;
  String? summary;
  String? infoSource;
  String? sourceUrl;
  String? province;
  String? provinceId;
  
  factory News.fromJson(Map<String,dynamic> json) => _$NewsFromJson(json);
  Map<String, dynamic> toJson() => _$NewsToJson(this);
}
