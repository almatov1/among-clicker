import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:untitled1/generated/l10n.dart';
import 'menu.dart';
import 'package:super_easy_in_app_purchase/super_easy_in_app_purchase.dart';

class ShoppingPage extends StatefulWidget {
  @override
  _ShoppingPage createState() => _ShoppingPage();
}

class _ShoppingPage extends State<ShoppingPage> {
  late String randToken;
  var postJson = [];
  bool isLoading = true;
  late SuperEasyInAppPurchase inAppPurchase;
  late int value;
  late String type;

  Future<void> getSqlData() async {
    var url = "https://george-ivchenko.ru/among/profile.php";
    var response = await http.post(Uri.parse(url), body: {
      "randToken": randToken,
    });
    var data = json.decode(response.body);
    postJson = data;
    isLoading = false;
    setState(() {});
  }

  Future<void> getAllSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    randToken = prefs.getString('cookieToken')!;
    setState(() {});
    getSqlData();
  }

  Future<void> buy() async {
    var url = "https://george-ivchenko.ru/among/buyItem.php";
    var response = await http.post(Uri.parse(url), body: {
      "randToken": randToken,
      "type": type,
      "value": value.toString(),
    });
    var data = json.decode(response.body);
    if (data == 'true') {
      _showSuccesBar(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => Menu()));
    } else {
      _showErrorBar(context);
    }
  }

  void _showErrorBar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.grey[800],
      content: Text(
        S.of(context).main_error,
        style: TextStyle(color: Colors.white),
      ),
      action: SnackBarAction(
        textColor: Colors.white,
        label: 'X',
        onPressed: () {
          // Code to execute.
        },
      ),
    ));
  }

  void _showSuccesBar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.yellow,
      content: Text(
        S.of(context).main_succes,
        style: TextStyle(color: Colors.black87),
      ),
      action: SnackBarAction(
        textColor: Colors.black87,
        label: 'X',
        onPressed: () {
          // Code to execute.
        },
      ),
    ));
  }

  void _showAlreadyBar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.yellow,
      content: Text(
        S.of(context).main_already,
        style: TextStyle(color: Colors.black87),
      ),
      action: SnackBarAction(
        textColor: Colors.black87,
        label: 'X',
        onPressed: () {
          // Code to execute.
        },
      ),
    ));
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    inAppPurchase = SuperEasyInAppPurchase(
      // Any of these function will run when its corresponding product gets purchased successfully
      // For simplicity, only a message is printed to console
      whenSuccessfullyPurchased: <String, Function>{
        'super_click': () async => await buy(),
        'noads': () async => await buy(),
        'coins': () async => await buy(),
        'elixir': () => buy(),
        'open_keys': () => buy(),
      },
    );
    getAllSavedData();
  }

  @override
  void dispose() {
    myBanner.dispose();
    inAppPurchase.stop();
    super.dispose();
  }

  final BannerAd myBanner = BannerAd(
    adUnitId: 'ca-app-pub-9673031653657238/1340765234',
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
          title: Text(S.of(context).shopPage_title),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => Menu())),
          ),
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
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.13,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            type = 'coins';
                            value = 2400;
                          });
                          inAppPurchase.startPurchase('coins',
                              isConsumable: true);
                        }, // Handle your callback
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image.asset(
                              'assets/images/coin.webp',
                              height: 100,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  S.of(context).shopPage_coins,
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(S.of(context).shopPage_youHave +
                                    ' ' +
                                    postJson[0]['coins']),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.attach_money,
                                  size: 16,
                                ),
                                Text(
                                  '5.00',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.13,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            type = 'elixir';
                            value = 5;
                          });
                          inAppPurchase.startPurchase('elixir',
                              isConsumable: true);
                        }, // Handle your callback
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image.asset(
                              'assets/images/elixir.webp',
                              height: 100,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  S.of(context).shopPage_elixir,
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(S.of(context).shopPage_youHave +
                                    ' ' +
                                    postJson[0]['elixir']),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.attach_money,
                                  size: 16,
                                ),
                                Text(
                                  '2.00',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.13,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            type = 'stop_timer';
                            value = 5;
                          });
                          inAppPurchase.startPurchase('super_click',
                              isConsumable: true);
                        }, // Handle your callback
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image.asset(
                              'assets/images/stopTimer.webp',
                              height: 100,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  S.of(context).shopPage_stopTimer,
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(S.of(context).shopPage_youHave +
                                    ' ' +
                                    postJson[0]['stop_timer']),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.attach_money,
                                  size: 16,
                                ),
                                Text(
                                  '3.00',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.13,
                      child: InkWell(
                        onTap: () {
                          if (int.parse(postJson[0]['noads']) == 0) {
                            setState(() {
                              type = 'noads';
                              value = 1;
                            });
                            inAppPurchase.startPurchase('noads');
                          } else {
                            _showAlreadyBar(context);
                          }
                        }, // Handle your callback
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image.asset(
                              'assets/images/ads.webp',
                              height: 100,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  S.of(context).shopPage_noAds,
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(S.of(context).shopPage_youHave +
                                    ' ' +
                                    postJson[0]['noads']),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.attach_money,
                                  size: 16,
                                ),
                                Text(
                                  '3.00',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.13,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            type = 'open_keys';
                            value = 2;
                          });
                          inAppPurchase.startPurchase('open_keys',
                              isConsumable: true);
                        }, // Handle your callback
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image.asset(
                              'assets/images/keyCase.webp',
                              height: 100,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  S.of(context).shopPage_keys,
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(S.of(context).shopPage_youHave +
                                    ' ' +
                                    postJson[0]['open_keys']),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.attach_money,
                                  size: 16,
                                ),
                                Text(
                                  '1.00',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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
