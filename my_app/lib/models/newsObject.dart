import 'package:json_annotation/json_annotation.dart';
import 'package:my_app/models/news.dart';

part 'newsObject.g.dart';

@JsonSerializable()
class NewsObject {
  NewsObject();

  List<News>? results;
  late bool success;
  
  factory NewsObject.fromJson(Map<String,dynamic> json) => _$NewsObjectFromJson(json);
  Map<String, dynamic> toJson() => _$NewsObjectToJson(this);
}
