import 'dart:convert';

import 'package:currency_converter/models/currency_rates.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppUtils {
  static String toNormal(String input) {
    if(input == 'Å') {
      return 'A';
    }
    return input;
  }
  static Future<CurrencyRates> loadCurrencyRates() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Response response = await Dio(BaseOptions(connectTimeout: 1*1000, receiveTimeout: 1*1000)).get('http://www.convertmymoney.com/rates.json');
      CurrencyRates currencyRates = CurrencyRates.fromRawJson(response.data);
      print("get internet");
      prefs.setString('currencyRates', json.encode(currencyRates.toJson()));
      return currencyRates;
    } on DioError catch (e) {
      print(e);
      String cacheData = prefs.getString('currencyRates');
      if(cacheData!=null) {
        print("get cache");
        CurrencyRates currencyRates = CurrencyRates.fromRawJson(cacheData);
        return currencyRates;
      } else {
        print("get local");
        String data = await rootBundle.loadString('assets/countries.json');
        CurrencyRates currencyRates = CurrencyRates.fromRawJson(data);
        return currencyRates;
      }
    }
  }
}