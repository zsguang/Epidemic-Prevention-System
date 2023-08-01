import 'package:json_annotation/json_annotation.dart';
import 'package:my_app/models/province.dart';

part 'country.g.dart';

@JsonSerializable()
class Country {
  Country();

  late List<Province> results;
  late bool success;
  
  factory Country.fromJson(Map<String,dynamic> json) => _$CountryFromJson(json);
  Map<String, dynamic> toJson() => _$CountryToJson(this);
}
