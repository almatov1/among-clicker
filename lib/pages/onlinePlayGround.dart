import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:badges/badges.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/generated/l10n.dart';

import 'menu.dart';

class OnlinePlayGround extends StatefulWidget {
  final gameToken;
  final userType;
  final botPlay;

  OnlinePlayGround({Key? key, this.gameToken, this.userType, this.botPlay})
      : super(key: key);

  @override
  _OnlinePlayGround createState() => _OnlinePlayGround();
}

class _OnlinePlayGround extends State<OnlinePlayGround> {
  late bool gameActive;
  late String randToken;
  late String mail;
  late String itemType;
  late String elixirValue;
  late String stopTimerValue;
  late Timer gameTimer;
  late Timer powerTimer;
  var postJson = [];
  var serverInfo = [];
  var firstInfo = [];
  bool isLoading = true;
  bool end = false;
  bool surr = false;
  bool adLoadFail = true;
  String motivation = '';
  String enemyMail = 'Enemy@gmail.com';
  int enemyCoins = 0;
  int counter = 0;
  int timerIndicator = 100;
  int powerIndicator = 50;
  int coinsIndicator = 0;
  int editCoinsIndicator = 5;
  int editPowerIndicator = 1;
  int target = 1000;
  late ConfettiController _controllerCenter;
  late InterstitialAd _interstitialAd;
  AudioCache player = AudioCache(prefix: 'assets/audio/');

  Future<void> getAllSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    randToken = prefs.getString('cookieToken')!;
    mail = prefs.getString('cookieMail')!;
    await gameActiveCheck();
    await getSqlData();
    setState(() {});
  }

  Future<void> gameActiveCheck() async {
    var url = "https://george-ivchenko.ru/among/online/gameActiveCheck.php";
    var response = await http.post(Uri.parse(url), body: {
      "gameToken": widget.gameToken,
    });
    var data = json.decode(response.body);
    firstInfo = data;
    if (firstInfo.isNotEmpty) {
      if (firstInfo[0]['connectMail'] == mail) {
        coinsIndicator = int.parse(firstInfo[0]['connectCoins']);
        timerIndicator = int.parse(firstInfo[0]['connectTimer']);
      } else {
        coinsIndicator = int.parse(firstInfo[0]['createCoins']);
        timerIndicator = int.parse(firstInfo[0]['createTimer']);
      }
      gameActive = true;
      checkServerResult();
      powerTimer = Timer.periodic(
          Duration(milliseconds: 700), (Timer p) => powerTimerFunc());
      gameTimer = Timer.periodic(Duration(milliseconds: 500), (Timer g) {
        if (timerIndicator > 0) {
          gameTimerFunc();
        } else {
          drawGame();
        }
      });
    } else {
      gameActive = false;
    }
  }

  Future<void> getSqlData() async {
    var url = "https://george-ivchenko.ru/among/profile.php";
    var response = await http.post(Uri.parse(url), body: {
      "randToken": randToken,
    });
    var data = json.decode(response.body);
    postJson = data;

    if (postJson.isNotEmpty) {
      elixirValue = postJson[0]['elixir'];
      stopTimerValue = postJson[0]['stop_timer'];
      if (int.parse(postJson[0]['noads']) == 0) {
        await adLoad();
      }
      isLoading = false;
    }

    setState(() {});
  }

  Future<void> checkServerResult() async {
    while (end == false) {
      await takeServerInfo();

      if (widget.botPlay == 1) {
        if (enemyCoins >= 1000) {
          await botWin();
          await putServerInfo();
        } else
          await putServerWithBotInfo();
      } else
        await putServerInfo();

      if (int.parse(serverInfo[0]['gameEnd']) == 1) {
        end = true;
        gameTimer.cancel();
        powerTimer.cancel();

        if (serverInfo[0]['winnerMail'] == mail) {
          print('win');
          _showWinBar(context);
          if (int.parse(postJson[0]['noads']) == 0) {
            if (adLoadFail == false) _interstitialAd.show();
          }
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Menu()));
        } else if (serverInfo[0]['winnerMail'] == '0') {
          print('draw');
          _showDrawBar(context);
          if (int.parse(postJson[0]['noads']) == 0) {
            if (adLoadFail == false) _interstitialAd.show();
          }
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Menu()));
        } else {
          print('lose');
          _showLoseBar(context);
          if (int.parse(postJson[0]['noads']) == 0) {
            if (adLoadFail == false) _interstitialAd.show();
          }
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Menu()));
        }
      }

      setState(() {});
    }
  }

  Future<void> takeServerInfo() async {
    var url = "https://george-ivchenko.ru/among/online/takeServerInfo.php";
    var response = await http.post(Uri.parse(url), body: {
      "gameToken": widget.gameToken,
    });
    var data = json.decode(response.body);
    serverInfo = data;

    if (serverInfo.isNotEmpty) {
      if (widget.userType == "create") {
        enemyCoins = int.parse(serverInfo[0]['connectCoins']);
        enemyMail = serverInfo[0]['connectMail'];
      } else {
        enemyCoins = int.parse(serverInfo[0]['createCoins']);
        enemyMail = serverInfo[0]['createMail'];
      }
    }
  }

  Future<void> putServerWithBotInfo() async {
    var url =
        "https://george-ivchenko.ru/among/online/putServerWithBotInfo.php";
    await http.post(Uri.parse(url), body: {
      "gameToken": widget.gameToken,
      "coinsValue": coinsIndicator.toString(),
      "timerValue": timerIndicator.toString(),
    });
  }

  Future<void> putServerInfo() async {
    var userType;
    var userTypeTimer;

    if (widget.userType == 'connect') {
      userType = 'connectCoins';
      userTypeTimer = 'connectTimer';
    } else {
      userType = 'createCoins';
      userTypeTimer = 'createTimer';
    }

    var url = "https://george-ivchenko.ru/among/online/putServerInfo.php";
    await http.post(Uri.parse(url), body: {
      "gameToken": widget.gameToken,
      "userType": userType,
      "coinsValue": coinsIndicator.toString(),
      "userTypeTimer": userTypeTimer,
      "timerValue": timerIndicator.toString(),
    });
  }

  Future<void> botWin() async {
    var url = "https://george-ivchenko.ru/among/online/botWin.php";
    await http.post(Uri.parse(url), body: {
      "gameToken": widget.gameToken,
    });
  }

  Future<void> surrender() async {
    if (surr == false) {
      var userType;

      if (widget.userType == 'connect')
        userType = 'createMail';
      else
        userType = 'connectMail';

      var url = "https://george-ivchenko.ru/among/online/winGame.php";
      var response = await http.post(Uri.parse(url), body: {
        "gameToken": widget.gameToken,
        "userType": userType.toString(),
      });
      var data = json.decode(response.body);

      if (data == 'true') {
        print('loseQuery');
        Navigator.of(context).pop();
      } else {
        _showErrorBar(context);
      }
    } else
      _showSurrTrueBar(context);
  }

  Future<void> winGame() async {
    var userType;

    if (widget.userType == 'connect')
      userType = 'connectMail';
    else
      userType = 'createMail';

    var url = "https://george-ivchenko.ru/among/online/winGame.php";
    var response = await http.post(Uri.parse(url), body: {
      "gameToken": widget.gameToken,
      "userType": userType.toString(),
      "randToken": randToken,
    });
    var data = json.decode(response.body);

    if (data == 'true') {
      print('winQuery');
    }
  }

  Future<void> drawGame() async {
    var url = "https://george-ivchenko.ru/among/online/drawGame.php";
    var response = await http.post(Uri.parse(url), body: {
      "gameToken": widget.gameToken,
    });
    var data = json.decode(response.body);

    if (data == 'true') {
      print('drawQuery');
    }
  }

  Future<void> useItem() async {
    var url = "https://george-ivchenko.ru/among/useItem.php";
    await http.post(Uri.parse(url), body: {
      "randToken": randToken,
      "type": itemType,
    });
  }

  gameTimerFunc() {
    setState(() {
      timerIndicator = timerIndicator - 1;
    });
  }

  powerTimerFunc() {
    if (powerIndicator < 100) {
      powerIndicator = powerIndicator + 5;
    }
    if (counter == 0)
      motivation = S.of(context).onlinePlayGroundPage_motivation1;
    if (counter == 1)
      motivation = S.of(context).onlinePlayGroundPage_motivation2;
    if (counter == 2)
      motivation = S.of(context).onlinePlayGroundPage_motivation3;
    if (counter == 3)
      motivation = S.of(context).onlinePlayGroundPage_motivation4;
    if (counter == 4)
      motivation = S.of(context).onlinePlayGroundPage_motivation5;
    if (counter == 5) {
      motivation = S.of(context).onlinePlayGroundPage_motivation6;
      counter = 0;
    }
    counter++;
    setState(() {});
  }

  void _showSurrTrueBar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.grey[800],
      content: Text(
        S.of(context).main_surrTrue,
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

  void _showLoseBar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.pinkAccent,
      content: Text(
        S.of(context).main_loss,
      ),
      duration: Duration(seconds: 10),
      action: SnackBarAction(
        textColor: Colors.white,
        label: 'X',
        onPressed: () {
          // Code to execute.
        },
      ),
    ));
  }

  void _showDrawBar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.grey[800],
      content: Text(
        S.of(context).main_draw,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      duration: Duration(seconds: 10),
      action: SnackBarAction(
        textColor: Colors.white,
        label: 'X',
        onPressed: () {
          // Code to execute.
        },
      ),
    ));
  }

  void _showWinBar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.yellow,
      content: Text(
        S.of(context).main_win,
        style: TextStyle(color: Colors.black87),
      ),
      duration: Duration(seconds: 10),
      action: SnackBarAction(
        textColor: Colors.black87,
        label: 'X',
        onPressed: () {
          // Code to execute.
        },
      ),
    ));
  }

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
                  surrender();
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

  adLoad() async {
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
            adLoadFail = true;
            print('InterstitialAd failed to load: $error');
          },
        ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllSavedData();
    _controllerCenter =
        ConfettiController(duration: const Duration(milliseconds: 100));
  }

  @override
  void dispose() {
    gameTimer.cancel();
    powerTimer.cancel();
    _controllerCenter.dispose();
    _interstitialAd.dispose();
    player.clearAll();
    super.dispose();
  }

  playAudio() {
    player.play('tap.mp3');
  }

  playItem() {
    player.play('item.mp3');
  }

  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (gameActive == true)
          _showDialog(context);
        else
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Menu()));
        return false;
      },
      child: Scaffold(
        body: Center(
          child: isLoading
              ? SizedBox(
                  height: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(S.of(context).main_loading),
                      CircularProgressIndicator(),
                      Text(S.of(context).main_check),
                    ],
                  ),
                )
              : gameActive
                  ? Stack(
                      children: [
                        SizedBox.expand(
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: Image(
                              image: AssetImage('assets/images/sand.webp'),
                            ),
                          ),
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(bottom: 10, top: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        SizedBox(
                                          width: 150,
                                          height: 10,
                                          child: LinearProgressIndicator(
                                            value: double.parse(
                                                    coinsIndicator.toString()) /
                                                target,
                                            backgroundColor: Colors.black12,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 150,
                                          height: 10,
                                          child: LinearProgressIndicator(
                                            value: double.parse(
                                                    powerIndicator.toString()) /
                                                100,
                                            backgroundColor: Colors.black12,
                                            color: Colors.pink,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                        width: 150,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              size: 25,
                                            ),
                                            Text(
                                              ' ' + coinsIndicator.toString(),
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 150,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.bolt,
                                              size: 25,
                                            ),
                                            Text(
                                              powerIndicator.toString(),
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Text(''),
                              GestureDetector(
                                onTap: () {
                                  if (powerIndicator > 0 &&
                                      timerIndicator > 0 &&
                                      coinsIndicator < target) {
                                    playAudio();
                                    _controllerCenter.play();
                                    setState(() {
                                      coinsIndicator =
                                          coinsIndicator + editCoinsIndicator;
                                      powerIndicator =
                                          powerIndicator - editPowerIndicator;
                                    });
                                  }
                                  if (coinsIndicator >= target) {
                                    winGame();
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 10),
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.1,
                                            child: Text(
                                              enemyMail.substring(
                                                  0, enemyMail.indexOf('@')),
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.1,
                                          height: 10,
                                          child: LinearProgressIndicator(
                                            value: double.parse(
                                                    enemyCoins.toString()) /
                                                target,
                                            backgroundColor: Colors.black12,
                                            color: Colors.indigoAccent,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Image.asset(
                                            'assets/images/soldier.webp',
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Stack(
                                      children: [
                                        Image.asset(
                                          'assets/images/amongSkin.gif',
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 150, top: 50),
                                          child: ConfettiWidget(
                                            confettiController:
                                                _controllerCenter,
                                            blastDirectionality:
                                                BlastDirectionality.explosive,
                                            // don't specify a direction, blast randomly
                                            shouldLoop: false,
                                            // start again as soon as the animation is finished
                                            colors: const [
                                              Colors.green,
                                              Colors.blue,
                                              Colors.pink,
                                              Colors.orange,
                                              Colors.purple
                                            ],
                                            // manually specify the colors to be used
                                            createParticlePath:
                                                drawStar, // define a custom shape/path
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 35),
                                    child: Text(
                                      motivation,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 15),
                                    child: SizedBox(
                                      width: 300,
                                      height: 10,
                                      child: LinearProgressIndicator(
                                        value: double.parse(
                                                timerIndicator.toString()) /
                                            100,
                                        backgroundColor: Colors.black12,
                                        color: Colors.greenAccent,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 300,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.timer,
                                          size: 25,
                                        ),
                                        Text(
                                          ' ' + timerIndicator.toString(),
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    width: 60,
                                    height: 50,
                                    child: Badge(
                                      badgeContent: Text(elixirValue),
                                      badgeColor: Colors.amberAccent,
                                      child: (int.parse(elixirValue) > 0)
                                          ? ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  powerIndicator =
                                                      powerIndicator + 50;
                                                  elixirValue =
                                                      (int.parse(elixirValue) -
                                                              1)
                                                          .toString();
                                                  itemType = 'elixir';
                                                  playItem();
                                                  useItem();
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                fixedSize: Size(50, 60),
                                                shadowColor: Colors.yellow,
                                                shape: BeveledRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                ),
                                              ),
                                              child: Icon(Icons.bolt),
                                            )
                                          : ElevatedButton(
                                              onPressed: null,
                                              style: ElevatedButton.styleFrom(
                                                fixedSize: Size(50, 60),
                                                shadowColor: Colors.yellow,
                                                shape: BeveledRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                ),
                                              ),
                                              child: Icon(Icons.bolt),
                                            ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 60,
                                    height: 50,
                                    child: Badge(
                                      badgeContent: Text(stopTimerValue),
                                      badgeColor: Colors.amberAccent,
                                      child: (int.parse(stopTimerValue) > 0)
                                          ? ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  editCoinsIndicator =
                                                      editCoinsIndicator + 20;
                                                  stopTimerValue = (int.parse(
                                                              stopTimerValue) -
                                                          1)
                                                      .toString();
                                                  itemType = 'stop_timer';
                                                  playItem();
                                                  useItem();
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                fixedSize: Size(50, 60),
                                                shadowColor: Colors.yellow,
                                                shape: BeveledRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                ),
                                              ),
                                              child: Icon(Icons.star),
                                            )
                                          : ElevatedButton(
                                              onPressed: null,
                                              style: ElevatedButton.styleFrom(
                                                fixedSize: Size(50, 60),
                                                shadowColor: Colors.yellow,
                                                shape: BeveledRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                ),
                                              ),
                                              child: Icon(Icons.star),
                                            ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 60,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _showDialog(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shadowColor: Colors.yellow,
                                        shape: BeveledRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                      ),
                                      child: Icon(Icons.home),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Text(S.of(context).onlinePlayGroundPage_notFound),
        ),
      ),
    );
  }
}
