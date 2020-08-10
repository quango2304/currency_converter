import 'package:currency_converter/ad_manager.dart';
import 'package:currency_converter/models/app_sizes.dart';
import 'package:currency_converter/pages/home.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdPage extends StatefulWidget {
  @override
  _AdPageState createState() => _AdPageState();
}

class _AdPageState extends State<AdPage> {
  BannerAd _bannerAd;

  void _loadBannerAd() {
    _bannerAd
      ..load()
      ..show(anchorType: AnchorType.top);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: AppSizes.wUnit*100,
          height: AppSizes.hUnit*100,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/intro.jpg"), fit: BoxFit.cover, colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.srcATop))),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: AppSizes.hUnit*10),
                decoration: BoxDecoration(
                  color: Colors.lightBlue.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => Home()));
                    },
                    child: Container(
                        alignment: Alignment.center,
                        width: AppSizes.wUnit * 45,
                        height: AppSizes.hUnit * 7,
                        child: Text(
                          "Continue",
                          style: GoogleFonts.comfortaa(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: AppSizes.wUnit * 5,
                              fontWeight: FontWeight.w900),
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: AdManager.bannerAdUnitId,
      size: AdSize.mediumRectangle,
    );
    _loadBannerAd();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }
}
