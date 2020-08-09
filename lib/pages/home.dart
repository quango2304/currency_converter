import 'dart:convert';
import 'dart:math';

import 'package:clipboard/clipboard.dart';
import 'package:currency_converter/models/app_sizes.dart';
import 'package:currency_converter/models/country.dart';
import 'package:currency_converter/models/currency_rates.dart';
import 'package:currency_converter/pages/countries_picker.dart';
import 'package:currency_converter/util.dart';
import 'package:currency_converter/widgets/clipper.dart';
import 'package:currency_converter/widgets/keyboard/key.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scaledownbutton/scaledownbutton.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> currencies = ['', ''];
  CurrencyRates _currencyRates;
  SharedPreferences prefs;

  Country fromCountry = Country(
    isoCode: "US",
    currencyCode: "USD",
    currencyName: "United States dollar",
    name: "United States of America",
    iso3Code: "USA",
  );
  Country toCountry = Country(
    isoCode: "VN",
    currencyCode: "VND",
    currencyName: "Vietnamese đồng",
    name: "Viet Nam",
    iso3Code: "VNM",
  );
  bool isNavigated = false;

  @override
  void initState() {
    super.initState();
    loadCountries();
    loadCurrency();
  }

  Future<void> loadCountries() async {
    prefs = await SharedPreferences.getInstance();
    String fromCountryCache = prefs.getString('fromCountry');
    String toCountryCache = prefs.getString('toCountry');
    setState(() {
      if (fromCountryCache != null) {
        fromCountry = Country.fromRawJson(fromCountryCache);
      }
      if (toCountryCache != null) {
        toCountry = Country.fromRawJson(toCountryCache);
      }
    });
  }

  void saveCountries(int index, Country country) {
    prefs.setString(index == 0 ? 'fromCountry' : 'toCountry',
        json.encode(country.toJson()));
  }

  Future<void> loadCurrency() async {
    CurrencyRates result = await AppUtils.loadCurrencyRates();
    print(result.toJson());
    setState(() {
      _currencyRates = result;
    });
  }

  void convert(BuildContext context) {
    if (currencies[0] != '') {
      try {
        double from = double.parse(currencies[0]);
        double rateFrom = _currencyRates.rates[fromCountry.currencyCode];
        double rateTo = _currencyRates.rates[toCountry.currencyCode];
        double to = from * (rateTo / rateFrom);
        setState(() {
          to = (to * 1000).ceil() / 1000;
          currencies[1] = to.toString();
        });
      } catch (e) {
        final snackBar = SnackBar(
          content: Text("Wrong format"),
          backgroundColor: Colors.redAccent,
        );
        Scaffold.of(context).showSnackBar(snackBar);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Builder(
        builder: (context) => SingleChildScrollView(
          child: Container(
            height: AppSizes.hUnit * 100,
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    ClipPath(
                      child: Container(
                        color: Colors.lightBlue.withOpacity(0.95),
                        height: AppSizes.hUnit * 40,
                        width: AppSizes.wUnit * 100,
                      ),
                      clipper: CustomClipPath(),
                    ),
                    Spacer(),
                    buildKeyBoard(context)
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: AppSizes.hUnit * 15),
                  width: AppSizes.wUnit * 90,
                  height: AppSizes.hUnit * 30,
                  padding:
                      EdgeInsets.symmetric(horizontal: AppSizes.wUnit * 3.5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.2),
                        spreadRadius: 10,
                        blurRadius: 15,
                        offset: Offset(0, 3), // changes position of shadow
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: AppSizes.hUnit * 4,
                      ),
                      buildCurrencyRow(0, context),
                      Container(
                        margin: EdgeInsets.only(
                            left: AppSizes.wUnit * 10, top: 3, bottom: 3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            ScaleDownButton(
                              onTap: () {
                                setState(() {
                                  Country temp = fromCountry;
                                  fromCountry = toCountry;
                                  toCountry = temp;

                                  String temp2 = currencies[0];
                                  currencies[0] = currencies[1];
                                  currencies[1] = temp2;
                                });
                              },
                              child: Icon(
                                Icons.swap_vert,
                                size: AppSizes.hUnit * 4,
                                color: Colors.redAccent,
                              ),
                            ),
                            SizedBox(
                              width: AppSizes.wUnit * 38.7,
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              size: AppSizes.hUnit * 4,
                              color: Colors.lightBlue,
                            ),
                          ],
                        ),
                      ),
                      buildCurrencyRow(1, context)
                    ],
                  ),
                ),
                Positioned(
                  top: AppSizes.hUnit * 42,
                  child: ScaleDownButton(
                    scale: 0.05,
                    onTap: () {
                      clear();
                    },
                    child: Container(
                        alignment: Alignment.center,
                        width: AppSizes.wUnit * 30,
                        height: AppSizes.hUnit * 5,
                        decoration: BoxDecoration(
                            color: Colors.lightBlue.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.2),
                                spreadRadius: 5,
                                blurRadius: 5,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              )
                            ]),
                        child: _currencyRates == null
                            ? Container(
                                width: AppSizes.wUnit * 5,
                                height: AppSizes.wUnit * 5,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  backgroundColor: Colors.white,
                                ))
                            : Text(
                                "CLEAR",
                                style: GoogleFonts.comfortaa(
                                    color: Colors.white,
                                    fontSize: AppSizes.wUnit * 3.5,
                                    fontWeight: FontWeight.w900),
                              )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row buildCurrencyRow(int index, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        ScaleDownButton(
          scale: 0.05,
          onTap: () async {
            if (!isNavigated) {
              isNavigated = true;
              Country result = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CountriesPicker()));
              if (result != null) {
                saveCountries(index, result);
                if (index == 0) {
                  setState(() {
                    fromCountry = result;
                    convert(context);
                  });
                } else {
                  setState(() {
                    toCountry = result;
                    convert(context);
                  });
                }
              }
              isNavigated = false;
            }
          },
          child: Row(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 2), // changes position of shadow
                      )
                    ]),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.asset(
                    'icons/flags/png/${index == 0 ? fromCountry.isoCode.toLowerCase() : toCountry.isoCode.toLowerCase()}.png',
                    package: 'country_icons',
                    fit: BoxFit.fitWidth,
                    width: AppSizes.wUnit * 10,
                  ),
                ),
              ),
              Container(
                width: AppSizes.wUnit * 3.5,
                height: AppSizes.wUnit * 5,
                color: Colors.transparent,
              ),
              Text(
                index == 0 ? fromCountry.currencyCode : toCountry.currencyCode,
                style: GoogleFonts.comfortaa(
                    color: Colors.grey[600],
                    fontSize: AppSizes.wUnit * 4.5,
                    fontWeight: FontWeight.w600),
              ),
              Icon(Icons.keyboard_arrow_down,
                  size: AppSizes.wUnit * 5, color: Colors.grey[600])
            ],
          ),
        ),
        Container(
          color: Colors.blue.withOpacity(0.05),
          child: Material(
            child: InkWell(
              onTap: () {
                FlutterClipboard.copy(currencies[index])
                    .then((result) {
                  final snackBar = SnackBar(
                    content: Text("Copied '${currencies[index]}' to Clipboard"),
                  );
                  Scaffold.of(context).showSnackBar(snackBar);
                });
              },
              child: Container(
                padding: EdgeInsets.only(
                    left: AppSizes.wUnit * 1, right: AppSizes.wUnit * 1),
                alignment: Alignment.centerRight,
                child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      currencies[index] == ''
                          ? index == 0 ? '|' : ' '
                          : currencies[index],
                      style: GoogleFonts.comfortaa(
                          color: index == 1
                              ? Colors.blue
                              : Colors.black.withOpacity(0.6),
                          fontSize: AppSizes.wUnit * 5,
                          fontWeight: FontWeight.w800),
                      maxLines: 1,
                    )),
                width: AppSizes.wUnit * 45,
                height: AppSizes.hUnit * 6,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Colors.lightBlue.withOpacity(0.3),
                    )),
              ),
            ),
          ),
        )
      ],
    );
  }

  void pressKey(String key, BuildContext context) {
    setState(() {
      currencies[0] += key;
    });
    convert(context);
  }

  void clear() {
    setState(() {
      currencies[0] = '';
      currencies[1] = '';
    });
  }

  Column buildKeyBoard(BuildContext context) {
    TextStyle buttonStyle = GoogleFonts.comfortaa(
        color: Colors.grey[800],
        fontSize: AppSizes.wUnit * 5,
        fontWeight: FontWeight.w800);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            KeyboardButton(
              ontap: () {
                pressKey('7', context);
              },
              child: Text(
                '7',
                style: buttonStyle,
              ),
            ),
            KeyboardButton(
              ontap: () {
                pressKey('8', context);
              },
              child: Text(
                '8',
                style: buttonStyle,
              ),
            ),
            KeyboardButton(
              ontap: () {
                pressKey('9', context);
              },
              child: Text(
                '9',
                style: buttonStyle,
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            KeyboardButton(
              ontap: () {
                pressKey('4', context);
              },
              child: Text(
                '4',
                style: buttonStyle,
              ),
            ),
            KeyboardButton(
              ontap: () {
                pressKey('5', context);
              },
              child: Text(
                '5',
                style: buttonStyle,
              ),
            ),
            KeyboardButton(
              ontap: () {
                pressKey('6', context);
              },
              child: Text(
                '6',
                style: buttonStyle,
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            KeyboardButton(
              ontap: () {
                pressKey('1', context);
              },
              child: Text(
                '1',
                style: buttonStyle,
              ),
            ),
            KeyboardButton(
              ontap: () {
                pressKey('2', context);
              },
              child: Text(
                '2',
                style: buttonStyle,
              ),
            ),
            KeyboardButton(
              ontap: () {
                pressKey('3', context);
              },
              child: Text(
                '3',
                style: buttonStyle,
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            KeyboardButton(
              ontap: () {
                pressKey('0', context);
              },
              child: Text(
                '0',
                style: buttonStyle,
              ),
            ),
            KeyboardButton(
              ontap: () {
                pressKey('.', context);
              },
              child: Text(
                '.',
                style: buttonStyle,
              ),
            ),
            KeyboardButton(
              ontap: () {
                if (currencies[0].length > 0) {
                  setState(() {
                    currencies[0] =
                        currencies[0].substring(0, currencies[0].length - 1);
                    convert(context);
                    if (currencies[0] == '') clear();
                  });
                }
              },
              onLongPress: () {
                clear();
              },
              child: Icon(
                Icons.backspace,
                color: Colors.lightBlue,
                size: AppSizes.wUnit * 7,
              ),
            )
          ],
        )
      ],
    );
  }
}
