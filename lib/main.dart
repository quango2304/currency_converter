import 'package:currency_converter/models/app_sizes.dart';
import 'package:currency_converter/models/data.dart';
import 'package:currency_converter/pages/countries_picker.dart';
import 'package:currency_converter/pages/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadJson();
    });
  }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrain) {
        AppSizes().init(constrain);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
//          home: CountriesPicker()
          home: Home(),
        );
      },
    );
  }
}
