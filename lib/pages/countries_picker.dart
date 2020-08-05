import 'package:currency_converter/models/app_sizes.dart';
import 'package:currency_converter/models/country.dart';
import 'package:currency_converter/models/data.dart';
import 'package:flutter/material.dart';

class CountriesPicker extends StatefulWidget {
  @override
  _CountriesPickerState createState() => _CountriesPickerState();
}

class _CountriesPickerState extends State<CountriesPicker> {
  String searchText = '';
  Widget buildCountryItem(Country country) {
    return Row(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.asset(
            'icons/flags/png/${country.code.toLowerCase()}.png',
            package: 'country_icons',
            fit: BoxFit.fitWidth,
            width: AppSizes.wUnit * 10,
          ),
        ),
        Text(country.name)
      ],
    );
  }

  Widget buildCharacterCountry(String character, List<Country> localCountries) {
    List<Country> filteredCountries = localCountries
        .where((country) => country.name.substring(0, 1) == character)
        .toList();
    if(filteredCountries.length == 0) return SizedBox(height: 0,);
    return Column(
      children: <Widget>[
        Text(character),
        Column(
          children: filteredCountries.map((item) {
            return buildCountryItem(item);
          }).toList(),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    List<Country> localCountries = countries.where((country) => country.name.toLowerCase().contains(searchText.toLowerCase())).toList();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          SizedBox(height: statusBarHeight,),
          Row(
            children: <Widget>[
              Icon(Icons.arrow_back_ios)
            ],
          ),
          Container(
            alignment: Alignment.center,
            height: AppSizes.hUnit * 7,
            width: AppSizes.wUnit * 80,
            decoration: BoxDecoration(
              color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.lightBlue.withOpacity(0.1),
                    spreadRadius: 7,
                    blurRadius: 7,
                    offset: Offset(0, 1.5), // changes position of shadow
                  )
                ]),
            child: TextField(
              textAlign: TextAlign.left,
              onChanged: (text) {
                setState(() {
                  searchText = text;
                });
              },
                decoration: new InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding:
                    EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                    hintStyle: TextStyle(color: Colors.grey),
                    hintText: "Search Country")
            ),
          ),
          Spacer(),
          Container(
            height: AppSizes.hUnit * 70,
            child: ListView.builder(
              itemCount: countriesAlpha.length,
                itemBuilder: (context, index) =>
                    buildCharacterCountry(countriesAlpha[index], localCountries)),
          ),
        ],
      ),
    );
  }
}
