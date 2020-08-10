import 'package:currency_converter/ad_manager.dart';
import 'package:currency_converter/models/app_sizes.dart';
import 'package:currency_converter/models/data.dart';
import 'package:currency_converter/pages/ad.dart';
import 'package:currency_converter/pages/countries_picker.dart';
import 'package:currency_converter/pages/home.dart';
import 'package:firebase_admob/firebase_admob.dart';
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
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrain) {
        AppSizes().init(constrain);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
//          home: CountriesPicker()
          home: FutureBuilder(
            future: _initAdMob(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return AdPage();
              } else {
                return Container(color: Colors.white,);
              }
            },
          ),
        );
      },
    );
  }

  Future<void> _initAdMob() {
    return FirebaseAdMob.instance.initialize(appId: AdManager.appId);
  }
}
