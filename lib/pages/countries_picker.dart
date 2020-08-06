import 'package:currency_converter/models/app_sizes.dart';
import 'package:currency_converter/models/countries.dart';
import 'package:currency_converter/models/country.dart';
import 'package:currency_converter/models/data.dart';
import 'package:currency_converter/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scaledownbutton/scaledownbutton.dart';

class CountriesPicker extends StatefulWidget {
  @override
  _CountriesPickerState createState() => _CountriesPickerState();
}

class _CountriesPickerState extends State<CountriesPicker> {
  String searchText = '';

  Widget buildCountryItem(Country country, int index) {
    return Container(
      color: Colors.white,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pop(context, country);
          },
          child: Container(
            padding: EdgeInsets.only(
                left: AppSizes.wUnit * 10, right: AppSizes.wUnit * 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                index != 0
                    ? Container(
                        height: 2,
                        color: Colors.grey.withOpacity(0.2),
                      )
                    : Container(
                        height: 0,
                        color: Colors.grey,
                      ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: AppSizes.hUnit * 2),
                  width: AppSizes.wUnit * 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.asset(
                          'icons/flags/png/${country.isoCode.toLowerCase()}.png',
                          package: 'country_icons',
                          fit: BoxFit.fitWidth,
                          width: AppSizes.wUnit * 10,
                        ),
                      ),
                      SizedBox(
                        width: AppSizes.wUnit * 2,
                      ),
                      Expanded(
                          child: Text(country.name, overflow: TextOverflow.ellipsis,)),
                      Text(country.currencyCode),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCharacterCountry(String character, List<Country> localCountries) {
    List<Country> filteredCountries = localCountries
        .where((country) =>
            AppUtils.toNormal(country.name.substring(0, 1)) == character)
        .toList();
    if (filteredCountries.length == 0)
      return SizedBox(
        height: 0,
      );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: AppSizes.hUnit * 2,
        ),
        Container(
            margin: EdgeInsets.only(left: AppSizes.wUnit * 10),
            child: Text(
              character,
              style:
                  TextStyle(color: Colors.grey, fontSize: AppSizes.wUnit * 4),
            )),
        SizedBox(
          height: AppSizes.hUnit * 2,
        ),
        Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
              color: Colors.lightBlue.withOpacity(0.1),
              spreadRadius: 7,
              blurRadius: 7,
              offset: Offset(0, 5), // changes position of shadow
            )
          ]),
          child: Column(
            children: filteredCountries.map((item) {
              return buildCountryItem(item, filteredCountries.indexOf(item));
            }).toList(),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    List<Country> localCountries;
    if (searchText != '' && searchText != null) {
      localCountries = countryList
          .where((country) => (country.name
          .replaceAll(' ', '')
          .toLowerCase()
          .contains(searchText.replaceAll(' ', '').toLowerCase())||country.currencyCode
          .replaceAll(' ', '')
          .toLowerCase()
          .contains(searchText.replaceAll(' ', '').toLowerCase())))
          .toList();
    } else {
      localCountries = countryList;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Container(
        height: AppSizes.hUnit * 100,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: statusBarHeight,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ScaleDownButton(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                        padding: EdgeInsets.only(
                            right: AppSizes.wUnit * 6,
                            top: AppSizes.wUnit * 3,
                            bottom: AppSizes.wUnit * 3),
                        child: Icon(
                          Icons.close,
                          size: AppSizes.wUnit * 6,
                        )))
              ],
            ),
            Container(
              alignment: Alignment.center,
              height: AppSizes.hUnit * 7,
              width: AppSizes.wUnit * 88,
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
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 11, top: 11, right: 15),
                      hintStyle: TextStyle(color: Colors.grey),
                      hintText: "Search country, currency")),
            ),
            SizedBox(
              height: AppSizes.hUnit * 3,
            ),
            Expanded(
//              child: SingleChildScrollView(
//                child: Column(
//                  children: countriesAlpha.map((a) => buildCharacterCountry(
//                      a, localCountries)).toList(),
//                ),
//              ),
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: countriesAlpha.length,
                    itemBuilder: (context, index) => buildCharacterCountry(
                        countriesAlpha[index], localCountries)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
