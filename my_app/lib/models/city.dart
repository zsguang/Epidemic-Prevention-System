import 'package:json_annotation/json_annotation.dart';

part 'city.g.dart';

@JsonSerializable()
class City {
  City();

  late String cityName;
  int? currentConfirmedCount;
  int? confirmedCount;
  int? suspectedCount;
  int? curedCount;
  int? deadCount;
  int? highDangerCount;
  int? midDangerCount;
  int? locationId;
  String? currentConfirmedCountStr;
  String? cityEnglishName;
  
  factory City.fromJson(Map<String,dynamic> json) => _$CityFromJson(json);
  Map<String, dynamic> toJson() => _$CityToJson(this);
}
