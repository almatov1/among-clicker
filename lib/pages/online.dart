import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/generated/l10n.dart';
import 'package:untitled1/pages/menu.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:untitled1/pages/onlinePlayGround.dart';

class OnlinePage extends StatefulWidget {
  @override
  _OnlinePage createState() => _OnlinePage();
}

class _OnlinePage extends State<OnlinePage> {
  late String randToken;
  late String mail;
  late String gameToken;
  late String rating;
  late String userType;
  late Timer secTimer;
  int counterServer = 0;
  var postJson = [];
  var serversList = [];
  var activeGameData = [];
  var serverInfo = [];
  bool isLoading = true;
  bool activeGames = false;
  bool findGame = false;
  bool end = true;
  bool searchServer = false;
  var secInts = [
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    23,
    24,
    25,
  ];

  var botName = [
    'gellagit@gmail.com',
    'floren@gmail.com',
    'arman_boss@gmail.com',
    'igor_akinfeev@gmail.com',
    'egormarik@gmail.com',
    'ruslanris252@gmail.com',
    'askarovich351@gmail.com',
    'jarasminecraft@gmail.com',
    'jacobusa_1@gmail.com',
    'george14r@gmail.com',
    'small_knife@gmail.com',
    'badcatbad@gmail.com',
    'stromae888@gmail.com',
    'timmytrumpet@gmail.com',
    'unclefleeeex@gmail.com',
  ];

  Future<void> getAllSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    randToken = prefs.getString('cookieToken')!;
    mail = prefs.getString('cookieMail')!;

    await takeGamesInfo();
    await checkActiveGames();
    await getSqlData();
    setState(() {});
  }

  Future<void> takeGamesInfo() async {
    var url = "";
    var response = await http.post(Uri.parse(url), body: {
      "mail": mail,
    });
    var data = json.decode(response.body);
    serversList = data;
  }

  Future<void> checkActiveGames() async {
    var url = "";
    var response = await http.post(Uri.parse(url), body: {
      "randToken": randToken,
    });
    var data = json.decode(response.body);
    activeGameData = data;

    if (activeGameData.isNotEmpty) {
      activeGames = true;
      if (activeGameData[0]['connectToken'] == randToken)
        userType = 'connect';
      else
        userType = 'create';
    }
  }

  Future<void> getSqlData() async {
    var url = "";
    var response = await http.post(Uri.parse(url), body: {
      "randToken": randToken,
    });
    var data = json.decode(response.body);
    postJson = data;

    if (int.parse(postJson[0]['onlineGamesWin']) == 0)
      rating = S.of(context).onlinePage_beginner;
    else if (int.parse(postJson[0]['onlineGamesWin']) <= 9)
      rating = S.of(context).onlinePage_beginner;
    else if (int.parse(postJson[0]['onlineGamesWin']) <= 24)
      rating = S.of(context).onlinePage_soldier;
    else if (int.parse(postJson[0]['onlineGamesWin']) <= 49)
      rating = S.of(context).onlinePage_master;
    else if (int.parse(postJson[0]['onlineGamesWin']) <= 99)
      rating = S.of(context).onlinePage_genius;
    else
      rating = S.of(context).onlinePage_global_elite;

    if (postJson.isNotEmpty) {
      isLoading = false;
    }

    setState(() {});
  }

  Future<void> randServer() async {
    var url = "";
    var response = await http.post(Uri.parse(url), body: {
      "randToken": randToken,
      "mail": mail,
    });
    var data = json.decode(response.body);
    serverInfo = data;

    if (serverInfo.isNotEmpty) {
      setState(() {
        gameToken = serverInfo[0]['gameToken'].toString();
        findGame = true;
        if (serverInfo[0]['connectToken'] == randToken)
          userType = 'connect';
        else
          userType = 'create';
      });
    }
  }

  Future<void> stopGame() async {
    var url = "";
    var response = await http.post(Uri.parse(url), body: {
      "gameToken": gameToken,
    });
    var data = json.decode(response.body);
    if (data == 'true') {
      if (end == false) secTimer.cancel();
      Navigator.push(context, MaterialPageRoute(builder: (context) => Menu()));
    }
  }

  Future<void> checkServerActive() async {
    var rng = new Random();
    searchServer = true;
    end = false;
    secTimer = Timer.periodic(Duration(seconds: 1), (Timer s) {
      counterServer++;
    });
    while (end == false) {
      var url = "";
      var response = await http.post(Uri.parse(url), body: {
        "gameToken": gameToken,
      });
      var data = json.decode(response.body);
      if (data == 'true') {
        end = true;
        secTimer.cancel();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OnlinePlayGround(
                      gameToken: gameToken,
                      userType: userType,
                      botPlay: 0,
                    )));
      } else {
        if (counterServer > secInts[rng.nextInt(14)]) {
          end = true;
          var url = "";
          var response = await http.post(Uri.parse(url), body: {
            "gameToken": gameToken,
            "botName": botName[rng.nextInt(14)],
          });
          var data = json.decode(response.body);
          if (data == 'true') {
            secTimer.cancel();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OnlinePlayGround(
                          gameToken: gameToken,
                          userType: userType,
                          botPlay: 1,
                        )));
          } else {
            end = false;
          }
        }
      }

      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllSavedData();
  }

  @override
  void dispose() {
    myBanner.dispose();
    secTimer.cancel();
    super.dispose();
  }

  final BannerAd myBanner = BannerAd(
    adUnitId: '',
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(),
  );

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              S.of(context).main_exit,
              style: TextStyle(fontSize: 14),
            ),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  stopGame();
                },
                child: Text(
                  ' ' + S.of(context).main_yes + ' ',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  ' ' + S.of(context).main_no + ' ',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (findGame == true) {
          _showDialog(context);
        } else {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Menu()));
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              if (findGame == true) {
                _showDialog(context);
              } else {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Menu()));
              }
            },
          ),
          title: Text(S.of(context).onlinePage_title),
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
                    Container(
                      height: MediaQuery.of(context).size.height * 0.18,
                      decoration: BoxDecoration(
                        color: Colors.yellow[600],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: SizedBox.expand(
                        child: Center(
                          child: SizedBox(
                            width: 350,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.network(
                                  postJson[0]['avatar'],
                                  width: 150,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      S.of(context).onlinePage_rank +
                                          ' ' +
                                          rating,
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Text(''),
                                    Text(
                                      S.of(context).onlinePage_won +
                                          ' ' +
                                          postJson[0]['onlineGamesWin'] +
                                          ' ' +
                                          S.of(context).onlinePage_games,
                                      style: TextStyle(fontSize: 14),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    activeGames
                        ? SizedBox(
                            width: 200,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                if (activeGameData[0]['connectToken'] ==
                                    'bot') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OnlinePlayGround(
                                        gameToken: activeGameData[0]
                                            ['gameToken'],
                                        userType: userType,
                                        botPlay: 1,
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OnlinePlayGround(
                                        gameToken: activeGameData[0]
                                            ['gameToken'],
                                        userType: userType,
                                        botPlay: 0,
                                      ),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.yellow[600],
                                shadowColor: Colors.yellow,
                                shape: BeveledRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                              child: Text(S.of(context).onlinePage_back),
                            ),
                          )
                        : Column(
                            children: [
                              findGame
                                  ? SizedBox.shrink()
                                  : SizedBox(
                                      width: 200,
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          await randServer();
                                          checkServerActive();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.yellow[600],
                                          shadowColor: Colors.yellow,
                                          shape: BeveledRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                          ),
                                        ),
                                        child:
                                            Text(S.of(context).onlinePage_find),
                                      ),
                                    ),
                              findGame
                                  ? Padding(
                                      padding: EdgeInsets.only(top: 25),
                                      child: Column(
                                        children: [
                                          CircularProgressIndicator(),
                                          Padding(
                                            padding: EdgeInsets.only(top: 10),
                                            child: Text(
                                                counterServer.toString() +
                                                    ' ' +
                                                    S
                                                        .of(context)
                                                        .onlinePage_passed),
                                          ),
                                        ],
                                      ),
                                    )
                                  : SizedBox.shrink(),
                            ],
                          ),
                    SizedBox(
                      width: 380,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            childAspectRatio: 5,
                          ),
                          itemCount: serversList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              color: (serversList[index]['winnerMail'] == mail)
                                  ? Colors.yellow[600]
                                  : Colors.grey[300],
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons
                                                  .account_circle_outlined),
                                              Text(
                                                ' ' +
                                                    serversList[index]
                                                            ['createMail']
                                                        .substring(
                                                            0,
                                                            serversList[index][
                                                                    'createMail']
                                                                .indexOf('@')),
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ],
                                          ),
                                          (int.parse(serversList[index]
                                                      ['createCoins']) >
                                                  500)
                                              ? (serversList[index]
                                                          ['createMail'] ==
                                                      serversList[index]
                                                          ['winnerMail'])
                                                  ? Text(
                                                      serversList[index]
                                                          ['createCoins'],
                                                      style: TextStyle(
                                                          fontSize: 13),
                                                    )
                                                  : Text(
                                                      (int.parse(serversList[
                                                                      index][
                                                                  'createCoins']) -
                                                              50)
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 13),
                                                    )
                                              : Text(
                                                  serversList[index]
                                                      ['createCoins'],
                                                  style:
                                                      TextStyle(fontSize: 13),
                                                ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons
                                                  .account_circle_outlined),
                                              Text(
                                                ' ' +
                                                    serversList[index]
                                                            ['connectMail']
                                                        .substring(
                                                            0,
                                                            serversList[index][
                                                                    'connectMail']
                                                                .indexOf('@')),
                                                maxLines: 1,
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ],
                                          ),
                                          (int.parse(serversList[index]
                                                      ['connectCoins']) >
                                                  500)
                                              ? (serversList[index]
                                                          ['connectMail'] ==
                                                      serversList[index]
                                                          ['winnerMail'])
                                                  ? Text(
                                                      serversList[index]
                                                          ['connectCoins'],
                                                      style: TextStyle(
                                                          fontSize: 13),
                                                    )
                                                  : Text(
                                                      (int.parse(serversList[
                                                                      index][
                                                                  'connectCoins']) -
                                                              50)
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 13),
                                                    )
                                              : Text(
                                                  serversList[index]
                                                      ['connectCoins'],
                                                  style:
                                                      TextStyle(fontSize: 13),
                                                ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
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
