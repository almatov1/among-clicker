import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:badges/badges.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/generated/l10n.dart';
import 'package:untitled1/pages/final.dart';
import 'package:untitled1/pages/play.dart';

class PlayGround extends StatefulWidget {
  final thisLvl;

  PlayGround({Key? key, this.thisLvl}) : super(key: key);

  @override
  _PlayGround createState() => _PlayGround();
}

class _PlayGround extends State<PlayGround> {
  late Timer gameTimer;
  late Timer powerTimer;
  int timerIndicator = 100;
  int powerIndicator = 50;
  int coinsIndicator = 0;
  late String randToken;
  var postJson = [];
  bool isLoading = true;
  bool adLoadFail = true;
  late int delayGameTimer;
  int delayPowerTimer = 1000;
  int editPowerIndicator = 1;
  late int editCoinsIndicator;
  late String backgroundUrl;
  late String winCoins;
  late int powerValue;
  late int speedValue;
  late int visibilityValue;
  late int lvl;
  late int target;
  late String itemType;
  late String elixirValue;
  late String stopTimerValue;
  late ConfettiController _controllerCenter;
  late InterstitialAd _interstitialAd;
  AudioCache player = AudioCache(prefix: 'assets/audio/');

  Future<void> getSqlData() async {
    var url = "";
    var response = await http.post(Uri.parse(url), body: {
      "randToken": randToken,
    });
    var data = json.decode(response.body);
    postJson = data;
    lvl = int.parse(postJson[0]['lvl']);
    powerValue = int.parse(postJson[0]['power']);
    speedValue = int.parse(postJson[0]['speed']);
    visibilityValue = int.parse(postJson[0]['visibility']);
    elixirValue = postJson[0]['elixir'];
    stopTimerValue = postJson[0]['stop_timer'];
    if (int.parse(postJson[0]['noads']) == 0) {
      await adLoad();
    }
    isLoading = false;
  }

  Future<void> getAllSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    randToken = prefs.getString('cookieToken')!;
    await getSqlData();
  }

  Future<void> lvlUp() async {
    if (lvl < int.parse(widget.thisLvl)) {
      var url = "";
      await http.post(Uri.parse(url), body: {
        "randToken": randToken,
        "lvl": widget.thisLvl,
        "winCoins": winCoins,
      });
    } else {
      var url = "";
      await http.post(Uri.parse(url), body: {
        "randToken": randToken,
        "winCoins": winCoins,
      });
    }
  }

  Future<void> useItem() async {
    var url = "";
    await http.post(Uri.parse(url), body: {
      "randToken": randToken,
      "type": itemType,
    });
  }

  Future<void> checkLvl() async {
    if (widget.thisLvl == '1') {
      target = 100;
      winCoins = '50';
      delayGameTimer = 1000;
      backgroundUrl = 'assets/images/sand.webp';
    } else if (widget.thisLvl == '2') {
      target = 500;
      winCoins = '100';
      delayGameTimer = 700;
      backgroundUrl = 'assets/images/road.webp';
    } else if (widget.thisLvl == '3') {
      target = 1000;
      winCoins = '200';
      delayGameTimer = 500;
      backgroundUrl = 'assets/images/city.webp';
    } else if (widget.thisLvl == '4') {
      target = 1500;
      winCoins = '400';
      delayGameTimer = 100;
      backgroundUrl = 'assets/images/sky.webp';
    } else {
      target = 10000;
      winCoins = '1000';
      delayGameTimer = 700;
      delayPowerTimer = 600;
      backgroundUrl = 'assets/images/cosmos.webp';
    }

    await getAllSavedData();

    if (visibilityValue == 0) {
      editCoinsIndicator = 1;
    } else if (visibilityValue <= 25) {
      editCoinsIndicator = 2;
    } else if (visibilityValue <= 50) {
      editCoinsIndicator = 4;
    } else if (visibilityValue <= 80) {
      editCoinsIndicator = 5;
    } else {
      editCoinsIndicator = 10;
    }

    if (speedValue == 0) {
    } else if (speedValue <= 5) {
      delayGameTimer = delayGameTimer + 100;
    } else if (speedValue <= 25) {
      delayGameTimer = delayGameTimer + 200;
    } else if (speedValue <= 50) {
      delayGameTimer = delayGameTimer + 300;
    } else if (speedValue <= 80) {
      delayGameTimer = delayGameTimer + 400;
    } else {
      delayGameTimer = delayGameTimer + 500;
    }

    if (powerValue == 0) {
    } else if (powerValue <= 5) {
      delayPowerTimer = delayPowerTimer - 100;
    } else if (powerValue <= 25) {
      delayPowerTimer = delayPowerTimer - 200;
    } else if (powerValue <= 50) {
      delayPowerTimer = delayPowerTimer - 300;
    } else if (powerValue <= 80) {
      delayPowerTimer = delayPowerTimer - 400;
    } else {
      delayPowerTimer = delayPowerTimer - 500;
    }

    setTimes();

    setState(() {});
  }

  gameTimerFunc() {
    setState(() {
      timerIndicator = timerIndicator - 1;
    });
  }

  powerTimerFunc() {
    if (powerIndicator < 100) {
      powerIndicator = powerIndicator + editPowerIndicator;
    }
    setState(() {});
  }

  void timersCancel() {
    setState(() {
      gameTimer.cancel();
      powerTimer.cancel();
    });
  }

  setTimes() {
    powerTimer = Timer.periodic(
        Duration(milliseconds: delayPowerTimer), (Timer t) => powerTimerFunc());
    gameTimer =
        Timer.periodic(Duration(milliseconds: delayGameTimer), (Timer g) {
      if (timerIndicator > 0) {
        gameTimerFunc();
      } else {
        gameTimer.cancel();
        if (int.parse(postJson[0]['noads']) == 0) {
          if (adLoadFail == false) _interstitialAd.show();
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.pinkAccent,
          content: Text(
            S.of(context).main_loss,
            style: TextStyle(color: Colors.white),
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
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PlayPage()));
      }
    });
  }

  adLoad() async {
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

  @override
  void initState() {
    checkLvl();
    _controllerCenter =
        ConfettiController(duration: const Duration(milliseconds: 100));
    super.initState();
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PlayPage()));
                  timersCancel();
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
        _showDialog(context);
        return false;
      },
      child: Scaffold(
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
            : Stack(
                children: [
                  SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Image(
                        image: AssetImage(backgroundUrl),
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
                              padding: EdgeInsets.only(bottom: 10, top: 20),
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                              lvlUp();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                backgroundColor: Colors.yellow,
                                content: (int.parse(widget.thisLvl) == 5)
                                    ? Text(
                                        S.of(context).playGroundPage_final,
                                        style: TextStyle(color: Colors.black),
                                      )
                                    : Text(
                                        S.of(context).playGroundPage_haveWon +
                                            ' ' +
                                            winCoins +
                                            ' ' +
                                            S.of(context).playGroundPage_coins,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                action: SnackBarAction(
                                  textColor: Colors.black,
                                  label: 'X',
                                  onPressed: () {
                                    // Code to execute.
                                  },
                                ),
                              ));
                              gameTimer.cancel();
                              (int.parse(widget.thisLvl) == 5)
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FinalPage()))
                                  : Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PlayPage()));
                            }
                          },
                          child: Stack(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 0),
                                child: Image.asset(
                                  'assets/images/amongSkin.gif',
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 80, left: 150),
                                child: ConfettiWidget(
                                  confettiController: _controllerCenter,
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
                                      drawStar, // define a custom shape/path.
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 15),
                              child: SizedBox(
                                width: 300,
                                height: 10,
                                child: LinearProgressIndicator(
                                  value:
                                      double.parse(timerIndicator.toString()) /
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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                                (int.parse(elixirValue) - 1)
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
                                            borderRadius: BorderRadius.all(
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
                                            borderRadius: BorderRadius.all(
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
                                            stopTimerValue =
                                                (int.parse(stopTimerValue) - 1)
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
                                            borderRadius: BorderRadius.all(
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
                                            borderRadius: BorderRadius.all(
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
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
              ),
      ),
    );
  }
}
