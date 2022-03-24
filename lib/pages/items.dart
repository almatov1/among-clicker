import 'dart:convert';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/generated/l10n.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'menu.dart';

class ItemsPage extends StatefulWidget {
  @override
  _ItemsPage createState() => _ItemsPage();
}

class _ItemsPage extends State<ItemsPage> {
  late InterstitialAd _interstitialAd;
  late String randToken;
  var postJson = [];
  var rng = new Random();
  bool isLoading = true;
  bool caseOpen = false;
  bool caseEnd = false;
  bool adLoadFail = true;
  late int value;
  late String type;
  late String showItemName;
  bool buttonActive = false;
  int clickCounter = 0;
  AudioCache player = AudioCache(prefix: 'assets/audio/');

  Future<void> getSqlData() async {
    var url = "https://george-ivchenko.ru/among/profile.php";
    var response = await http.post(Uri.parse(url), body: {
      "randToken": randToken,
    });
    var data = json.decode(response.body);
    postJson = data;

    if (int.parse(postJson[0]['noads']) == 0) {
      bannerInit();
    }

    if (int.parse(postJson[0]['open_keys']) > 0)
      buttonActive = true;
    else
      buttonActive = false;

    isLoading = false;
    setState(() {});
  }

  Future<void> getAllSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    randToken = prefs.getString('cookieToken')!;
    setState(() {});
    await getSqlData();
  }

  Future<void> getItemsInfo() async {
    var url = "https://george-ivchenko.ru/among/profile.php";
    var response = await http.post(Uri.parse(url), body: {
      "randToken": randToken,
    });
    var data = json.decode(response.body);
    postJson = data;
    if (int.parse(postJson[0]['open_keys']) > 0)
      buttonActive = true;
    else
      buttonActive = false;
  }

  Future<void> openCase() async {
    clickCounter++;
    int counter = rng.nextInt(9);

    if (counter == 0) {
      type = "coins";
      value = 500;
      showItemName = S.of(context).shopPage_coins;
    } else if (counter <= 5) {
      type = "coins";
      value = 500;
      showItemName = S.of(context).shopPage_coins;
    } else if (counter <= 7) {
      type = "stop_timer";
      value = 2;
      showItemName = S.of(context).shopPage_stopTimer;
    } else if (counter <= 9) {
      type = "elixir";
      value = 2;
      showItemName = S.of(context).shopPage_elixir;
    } else {
      type = "coins";
      value = 500;
      showItemName = S.of(context).shopPage_coins;
    }

    await buy();
    await Future.delayed(Duration(seconds: 2), () {
      caseEnd = true;
      playItem();
      if (clickCounter == 2) {
        clickCounter = 0;
        if (int.parse(postJson[0]['noads']) == 0) {
          if (adLoadFail == false) _interstitialAd.show();
          bannerInit();
        }
      }
    });
    await getItemsInfo();

    setState(() {});
  }

  Future<void> buy() async {
    var url = "https://george-ivchenko.ru/among/openCase.php";
    await http.post(Uri.parse(url), body: {
      "randToken": randToken,
      "type": type,
      "value": value.toString(),
    });
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
        adUnitId: 'ca-app-pub-9673031653657238/3541560777',
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            adLoadFail = false;
            // Keep a reference to the ad so you can show it later.
            this._interstitialAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error');
            adLoadFail = true;
          },
        ));
  }

  final BannerAd myBanner = BannerAd(
    adUnitId: 'ca-app-pub-9673031653657238/1340765234',
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(),
  );

  playLoad() {
    player.play('loading.wav');
  }

  playItem() {
    player.play('item.mp3');
  }

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
          title: Text(S.of(context).menuPage_items),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 400,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: caseOpen
                          ? caseEnd
                              ? Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.check_circle_outline),
                                      Text(
                                        " " +
                                            S
                                                .of(context)
                                                .playGroundPage_haveWon +
                                            ": " +
                                            showItemName,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                )
                              : Image.asset(
                                  'assets/images/open.gif',
                                )
                          : SizedBox.shrink(),
                    ),
                    SizedBox(
                      width: 400,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                S.of(context).shopPage_youHave +
                                    " " +
                                    postJson[0]['open_keys'] +
                                    " ",
                                style: TextStyle(fontSize: 16),
                              ),
                              Icon(Icons.vpn_key_outlined),
                            ],
                          ),
                          buttonActive
                              ? ElevatedButton(
                                  onPressed: () {
                                    playLoad();
                                    caseOpen = true;
                                    caseEnd = false;
                                    buttonActive = false;
                                    setState(() {});
                                    openCase();
                                  },
                                  child: Text(S.of(context).itemsPage_open),
                                )
                              : ElevatedButton(
                                  onPressed: null,
                                  child: Text(S.of(context).itemsPage_open),
                                ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 350,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Badge(
                            badgeContent: Text(postJson[0]['coins']),
                            badgeColor: Colors.amberAccent,
                            child: Image.asset(
                              'assets/images/coin.webp',
                              height: 100,
                            ),
                          ),
                          Badge(
                            badgeContent: Text(postJson[0]['elixir']),
                            badgeColor: Colors.amberAccent,
                            child: Image.asset(
                              'assets/images/elixir.webp',
                              height: 100,
                            ),
                          ),
                          Badge(
                            badgeContent: Text(postJson[0]['stop_timer']),
                            badgeColor: Colors.amberAccent,
                            child: Image.asset(
                              'assets/images/stopTimer.webp',
                              height: 100,
                            ),
                          ),
                        ],
                      ),
                    ),
                    (int.parse(postJson[0]['noads']) == 0)
                        ? SizedBox(
                            height: 50,
                            child: AdWidget(
                              ad: myBanner..load(),
                            ),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ),
      ),
    );
  }
}
