import 'dart:convert';

class Country {
  Country({
    this.name,
    this.code,
  });

  final String name;
  final String code;

  factory Country.fromRawJson(String str) => Country.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    name: json["name"] == null ? null : json["name"],
    code: json["code"] == null ? null : json["code"],
  );

  Map<String, dynamic> toJson() => {
    "name": name == null ? null : name,
    "code": code == null ? null : code,
  };
}
