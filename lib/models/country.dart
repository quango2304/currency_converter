// To parse this JSON data, do
//
//     final country = countryFromJson(jsonString);

import 'dart:convert';

class Country {
  Country({
    this.name,
    this.isoCode,
    this.iso3Code,
    this.currencyCode,
    this.currencyName,
  });

  final String name;
  final String isoCode;
  final String iso3Code;
  final String currencyCode;
  final String currencyName;

  factory Country.fromRawJson(String str) => Country.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    name: json["name"] == null ? null : json["name"],
    isoCode: json["isoCode"] == null ? null : json["isoCode"],
    iso3Code: json["iso3Code"] == null ? null : json["iso3Code"],
    currencyCode: json["currencyCode"] == null ? null : json["currencyCode"],
    currencyName: json["currencyName"] == null ? null : json["currencyName"],
  );

  Map<String, dynamic> toJson() => {
    "name": name == null ? null : name,
    "isoCode": isoCode == null ? null : isoCode,
    "iso3Code": iso3Code == null ? null : iso3Code,
    "currencyCode": currencyCode == null ? null : currencyCode,
    "currencyName": currencyName == null ? null : currencyName,
  };
}
