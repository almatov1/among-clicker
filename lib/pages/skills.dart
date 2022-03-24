import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/generated/l10n.dart';
import 'package:untitled1/pages/shop.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'menu.dart';

class SkillsPage extends StatefulWidget {
  @override
  _SkillsPage createState() => _SkillsPage();
}

class _SkillsPage extends State<SkillsPage> {
  late String coins;
  late String visibility;
  late String speed;
  late String power;
  late InterstitialAd _interstitialAd;
  late String randToken;
  var postJson = [];
  bool isLoading = true;
  bool adLoadFail = true;
  late String type;
  late String skillUppedValue;
  late int calculate;
  int clickCounter = 0;
  AudioCache player = AudioCache(prefix: 'assets/audio/');

  Future<void> skillUp() async {
    if (int.parse(coins) >= 0) {
      var url = "";
      await http.post(Uri.parse(url), body: {
        "randToken": randToken,
        "type": type,
        "value": skillUppedValue,
        "coins": coins,
      });
    }
  }

  Future<void> getSqlData() async {
    var url = "";
    var response = await http.post(Uri.parse(url), body: {
      "randToken": randToken,
    });
    var data = json.decode(response.body);
    postJson = data;
    coins = postJson[0]['coins'];
    visibility = postJson[0]['visibility'];
    speed = postJson[0]['speed'];
    power = postJson[0]['power'];

    if (int.parse(postJson[0]['noads']) == 0) {
      await bannerInit();
    }

    isLoading = false;
    setState(() {});
  }

  Future<void> getAllSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    randToken = prefs.getString('cookieToken')!;
    setState(() {});
    await getSqlData();
  }

  playAudio() {
    player.play('skill.wav');
  }

  @override
  void initState() {
    // TODO: implement initState
    getAllSavedData();
    super.initState();
  }

  @override
  void dispose() {
    myBanner.dispose();
    _interstitialAd.dispose();
    player.clearAll();
    super.dispose();
  }

  bannerInit() async {
    await InterstitialAd.load(
        adUnitId: '',
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            adLoadFail = false;
            // Keep a reference to the ad so you can show it later.
            this._interstitialAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            adLoadFail = true;
            print('InterstitialAd failed to load: $error');
          },
        ));
  }

  final BannerAd myBanner = BannerAd(
    adUnitId: '',
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(),
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Menu()));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => Menu())),
          ),
          title: Text(S.of(context).skillsPage_title),
        ),
        body: isLoading
            ? Center(
                child: SizedBox(
                  height: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(S.of(context).main_loading),
                      CircularProgressIndicator(),
                      Text(S.of(context).main_check),
                    ],
                  ),
                ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          width: 300,
                          height: 10,
                          child: LinearProgressIndicator(
                            value: double.parse(coins) / 1000,
                            backgroundColor: Colors.black12,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: SizedBox(
                            width: 300,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  S.of(context).shopPage_coins + ': ' + coins,
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ShoppingPage()));
                                  },
                                  child: Text(
                                    S.of(context).skillsPage_need,
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: 300,
                          height: 10,
                          child: LinearProgressIndicator(
                            value: double.parse(visibility) / 100,
                            backgroundColor: Colors.black12,
                            color: Colors.greenAccent,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 25),
                          child: SizedBox(
                            width: 300,
                            child: Text(S.of(context).skillsPage_vDescription),
                          ),
                        ),
                        SizedBox(
                          width: 300,
                          child: Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('$visibility%'),
                                (int.parse(visibility) >= 100 ||
                                        int.parse(coins) < 100)
                                    ? IconButton(
                                        onPressed: null, icon: Icon(Icons.add))
                                    : IconButton(
                                        onPressed: () {
                                          playAudio();
                                          clickCounter++;
                                          calculate = int.parse(visibility) + 5;
                                          type = 'visibility';
                                          skillUppedValue =
                                              calculate.toString();
                                          visibility = calculate.toString();
                                          if (int.parse(coins) != 0)
                                            coins = (int.parse(coins) - 100)
                                                .toString();
                                          skillUp();
                                          if (int.parse(postJson[0]['noads']) ==
                                              0) {
                                            if (clickCounter == 2) {
                                              clickCounter = 0;
                                              if (adLoadFail == false) _interstitialAd.show();
                                              bannerInit();
                                            }
                                          }
                                          setState(() {});
                                        },
                                        icon: Icon(Icons.add),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: 300,
                          height: 10,
                          child: LinearProgressIndicator(
                            value: double.parse(speed) / 100,
                            backgroundColor: Colors.black12,
                            color: Colors.blueAccent,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 25),
                          child: SizedBox(
                            width: 300,
                            child: Text(S.of(context).skillsPage_sDescription),
                          ),
                        ),
                        SizedBox(
                          width: 300,
                          child: Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('$speed%'),
                                (int.parse(speed) >= 100 ||
                                        int.parse(coins) < 100)
                                    ? IconButton(
                                        onPressed: null, icon: Icon(Icons.add))
                                    : IconButton(
                                        onPressed: () {
                                          playAudio();
                                          clickCounter++;
                                          calculate = int.parse(speed) + 5;
                                          type = 'speed';
                                          skillUppedValue =
                                              calculate.toString();
                                          speed = calculate.toString();
                                          if (int.parse(coins) != 0)
                                            coins = (int.parse(coins) - 100)
                                                .toString();
                                          skillUp();
                                          if (int.parse(postJson[0]['noads']) ==
                                              0) {
                                            if (clickCounter == 2) {
                                              clickCounter = 0;
                                              _interstitialAd.show();
                                              bannerInit();
                                            }
                                          }
                                          setState(() {});
                                        },
                                        icon: Icon(Icons.add),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: 300,
                          height: 10,
                          child: LinearProgressIndicator(
                            value: double.parse(power) / 100,
                            backgroundColor: Colors.black12,
                            color: Colors.pink,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 25),
                          child: SizedBox(
                            width: 300,
                            child: Text(S.of(context).skillsPage_pDescription),
                          ),
                        ),
                        SizedBox(
                          width: 300,
                          child: Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('$power%'),
                                (int.parse(power) >= 100 ||
                                        int.parse(coins) < 100)
                                    ? IconButton(
                                        onPressed: null, icon: Icon(Icons.add))
                                    : IconButton(
                                        onPressed: () {
                                          playAudio();
                                          clickCounter++;
                                          calculate = int.parse(power) + 5;
                                          type = 'power';
                                          skillUppedValue =
                                              calculate.toString();
                                          power = calculate.toString();
                                          if (int.parse(coins) != 0)
                                            coins = (int.parse(coins) - 100)
                                                .toString();

                                          skillUp();
                                          if (int.parse(postJson[0]['noads']) ==
                                              0) {
                                            if (clickCounter == 2) {
                                              clickCounter = 0;
                                              _interstitialAd.show();
                                              bannerInit();
                                            }
                                          }
                                          setState(() {});
                                        },
                                        icon: Icon(Icons.add),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    (int.parse(postJson[0]['noads']) == 0)
                        ? SizedBox(
                            height: 50,
                            child: AdWidget(
                              ad: myBanner..load(),
                            ),
                          )
                        : Text(''),
                  ],
                ),
              ),
      ),
    );
  }
}
