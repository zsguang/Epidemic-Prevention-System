part of 'bulletin.dart';

Bulletin _$BulletinFromJson(Map<String, dynamic> json) => Bulletin()
  ..noticeId = json['noticeId'] as int?
  ..noticeTitle = json['noticeTitle'] as String
  ..noticeContent = json['noticeContent'] as String
  ..noticeTime = json['noticeTime'] as String
  ..noticeAuthor = json['noticeAuthor'] as String
  ..userPhone = json['userPhone'] as String
  ..user = json['user'] == null ? null : User.fromJson(json['user']);

Map<String, dynamic> _$BulletinToJson(Bulletin instance) {
  final Map<String, dynamic> json = <String, dynamic>{};
  if (instance.noticeId != null) json['noticeId'] = instance.noticeId;
  json['noticeTitle'] = instance.noticeTitle;
  json['noticeContent'] = instance.noticeContent;
  json['noticeTime'] = instance.noticeTime;
  json['noticeAuthor'] = instance.noticeAuthor;
  json['userPhone'] = instance.userPhone;
  if (instance.user != null) json['user'] = instance.user!.toJson();
  return json;
}
