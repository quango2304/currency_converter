import 'dart:convert';

import 'package:currency_converter/models/country.dart';
import 'package:flutter/services.dart';

List<Country> countries = [];
List<String> countriesAlpha = [
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'I',
  'J',
  'K',
  'L',
  'M',
  'N',
  'O',
  'P',
  'Q',
  'R',
  'S',
  'T',
  'U',
  'V',
  'W',
  'Y',
  'Z'
];

Future<void> loadJson() async {
  String data = await rootBundle.loadString('assets/countries.json');
  final jsonResult = json.decode(data);
  countries = List<Country>.from(jsonResult.map((x) => Country.fromJson(x)));
}
