import 'dart:convert';

class CurrencyRates {
  CurrencyRates({
    this.timestamp,
    this.base,
    this.rates,
  });

  final int timestamp;
  final String base;
  final Map<String, double> rates;

  factory CurrencyRates.fromRawJson(String str) => CurrencyRates.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CurrencyRates.fromJson(Map<String, dynamic> json) => CurrencyRates(
    timestamp: json["timestamp"] == null ? null : json["timestamp"],
    base: json["base"] == null ? null : json["base"],
    rates: json["rates"] == null ? null : Map.from(json["rates"]).map((k, v) => MapEntry<String, double>(k, v.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    "timestamp": timestamp == null ? null : timestamp,
    "base": base == null ? null : base,
    "rates": rates == null ? null : Map.from(rates).map((k, v) => MapEntry<String, dynamic>(k, v)),
  };
}
