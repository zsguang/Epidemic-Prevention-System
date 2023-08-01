import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'community.g.dart';

@JsonSerializable()
class Community {
  Community();

  late String communityId;
  late String communityName;
  late String communityAddress;
  bool selected = false;
  
  factory Community.fromJson(Map<String,dynamic> json) => _$CommunityFromJson(json);
  Map<String, dynamic> toJson() => _$CommunityToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
