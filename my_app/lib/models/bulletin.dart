import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:my_app/models/user.dart';

part 'bulletin.g.dart';

@JsonSerializable()
class Bulletin {
  Bulletin();

  num? noticeId;
  late String noticeTitle;
  late String noticeContent;
  late String noticeTime;
  late String noticeAuthor;
  late String userPhone;
  User? user;

  bool selected = false;
  
  factory Bulletin.fromJson(Map<String,dynamic> json) => _$BulletinFromJson(json);
  Map<String, dynamic> toJson() => _$BulletinToJson(this);

  @override
  String toString() {
    final map = toJson();
    return jsonEncode(map);
  }
}
