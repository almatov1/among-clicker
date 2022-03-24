import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/generated/l10n.dart';
import 'package:untitled1/pages/items.dart';
import 'package:untitled1/pages/play.dart';
import 'package:untitled1/pages/shop.dart';
import 'package:untitled1/pages/skills.dart';
import 'online.dart';
import 'package:audioplayers/audioplayers.dart';

class Menu extends StatefulWidget {
  @override
  _Menu createState() => _Menu();
}

class _Menu extends State<Menu> with WidgetsBindingObserver {
  bool _login = false;
  late String randToken;
  var postJson = [];
  static const _chars =
      '';
  Random _rnd = Random();
  AudioCache player = AudioCache(prefix: 'assets/audio/');
  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  late String randomToken;
  int noAds = 0;
  int signError = 1;
  bool isLoading = true;
  bool wantLoad = true;
  bool isNotTraining = false;
  int trainingCoins = 0;
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  Future<void> audioPause() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('audio', false);
  }

  Future<void> removeAudioPause() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('audio');
  }

  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cookieMail', _googleSignIn.currentUser!.email);
    prefs.setString('cookieToken', randToken);
    prefs.setString(
        'cookiePhoto', _googleSignIn.currentUser!.photoUrl.toString());
  }

  Future<void> getAllSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('cookieToken') != null) {
      _login = true;
      randomToken = prefs.getString('cookieToken')!;
    }
    if (prefs.getString('cookieNotTraining') != null) {
      isNotTraining = true;
    }
    var checkAudio = prefs.getBool('audio');
    if (checkAudio == null) {
      wantLoad = true;
      if (isNotTraining == true) playAudio();
    } else
      wantLoad = false;
    setState(() {});
  }

  Future<void> deleteAllData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('cookieMail');
    prefs.remove('cookieToken');
    prefs.remove('cookiePhoto');
  }

  Future register() async {
    var url = "";
    var response = await http.post(Uri.parse(url), body: {
      "mail": _googleSignIn.currentUser!.email,
      "randToken": randToken,
      "avatar": _googleSignIn.currentUser!.photoUrl.toString(),
    });
    var data = json.decode(response.body);
    if (data == "Success") {
      saveData();
      _login = true;
      setState(() {});
    } else
      _showErrorBar(context);
  }

  Future<void> trainingEnd() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cookieNotTraining', 'true');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllSavedData();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    player.clearAll();
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  playAudio() async {
    audioPlayer = await player.play('1.mp3');
    setState(() {});
  }

  playAddCoins() {
    player.play('tap.mp3');
  }

  Future<void> _handleSignIn() async {
    var user = await _googleSignIn.signIn();
    if (user != null) signError = 0;
    setState(() {});
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
    } else if (state == AppLifecycleState.inactive) {
    } else if (state == AppLifecycleState.paused) {
      audioPlayer.pause();
      audioPause();
      wantLoad = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        audioPlayer.pause();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Menu()));
        return false;
      },
      child: isNotTraining
          ? Scaffold(
              key: _drawerKey,
              body: Stack(
                children: [
                  SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Image(
                        image: AssetImage('assets/images/menuBackground.gif'),
                      ),
                    ),
                  ),
                  _login
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 25),
                                child: Image.asset(
                                  'assets/images/app.webp',
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: SizedBox(
                                  width: 250,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      //audioPlayer.pause();
                                      audioPlayer.pause();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PlayPage()));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.yellow[600],
                                      shadowColor: Colors.yellow,
                                      shape: BeveledRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                    ),
                                    child: Text(S.of(context).menuPage_play),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: SizedBox(
                                  width: 250,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      //audioPlayer.pause();
                                      audioPlayer.pause();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  OnlinePage()));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.yellow[600],
                                      shadowColor: Colors.yellow,
                                      shape: BeveledRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                    ),
                                    child: Text(S.of(context).menuPage_online),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: SizedBox(
                                  width: 250,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      //audioPlayer.pause();
                                      audioPlayer.pause();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SkillsPage()));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.yellow[600],
                                      shadowColor: Colors.yellow,
                                      shape: BeveledRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                    ),
                                    child: Text(S.of(context).menuPage_skills),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: SizedBox(
                                  width: 250,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      //audioPlayer.pause();
                                      audioPlayer.pause();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ShoppingPage()));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.yellow[600],
                                      shadowColor: Colors.yellow,
                                      shape: BeveledRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                    ),
                                    child: Text(S.of(context).menuPage_shop),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 25),
                                child: Image.asset(
                                  'assets/images/app.webp',
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: SizedBox(
                                  width: 250,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await _handleSignIn();
                                      if (signError == 0) {
                                        randToken = getRandomString(12);
                                        register();
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.yellow[600],
                                      shadowColor: Colors.yellow,
                                      shape: BeveledRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                    ),
                                    child: Text(S.of(context).menuPage_sign),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
              drawer: Drawer(
                // Add a ListView to the drawer. This ensures the user can scroll
                // through the options in the drawer if there isn't enough vertical
                // space to fit everything.
                child: ListView(
                  // Important: Remove any padding from the ListView.
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.yellow[600],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.account_circle_outlined),
                          Text(' ' + S.of(context).menuPage_acc_m),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.shopping_basket_outlined),
                      title: Text(S.of(context).menuPage_items),
                      onTap: () {
                        audioPlayer.pause();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ItemsPage()));
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.logout),
                      title: Text(S.of(context).menuPage_logout),
                      onTap: () async {
                        await _googleSignIn.signOut();
                        deleteAllData();
                        _login = false;
                        Navigator.of(context).pop();
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
              floatingActionButton: Row(
                mainAxisAlignment:
                    _login ? MainAxisAlignment.center : MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Container(
                      child: wantLoad
                          ? FloatingActionButton(
                              heroTag: null,
                              onPressed: () {
                                audioPlayer.pause();
                                wantLoad = false;
                                audioPause();
                                setState(() {});
                              },
                              backgroundColor: Colors.yellow[600],
                              shape: BeveledRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(''),
                                  Icon(Icons.music_note),
                                  Text(''),
                                ],
                              ),
                            )
                          : FloatingActionButton(
                              heroTag: null,
                              onPressed: () {
                                playAudio();
                                wantLoad = true;
                                removeAudioPause();
                                setState(() {});
                              },
                              backgroundColor: Colors.yellow[600],
                              shape: BeveledRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(''),
                                  Icon(Icons.music_off),
                                  Text(''),
                                ],
                              ),
                            ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Container(
                      child: _login
                          ? FloatingActionButton(
                              heroTag: null,
                              onPressed: () {
                                _drawerKey.currentState!.openDrawer();
                              },
                              backgroundColor: Colors.yellow[600],
                              shape: BeveledRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(''),
                                  Icon(Icons.account_circle_outlined),
                                  Text(''),
                                ],
                              ),
                            )
                          : Text(''),
                    ),
                  ),
                ],
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat)
          : Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(''),
                    Text(
                      S.of(context).menuPage_training,
                      style: TextStyle(fontSize: 27),
                    ),
                    SizedBox(
                      width: 200,
                      height: 10,
                      child: LinearProgressIndicator(
                        value: trainingCoins / 10,
                        backgroundColor: Colors.black12,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        playAddCoins();
                        trainingCoins++;
                        if (trainingCoins == 10) {
                          trainingEnd();
                          isNotTraining = true;
                          playAudio();
                          wantLoad = true;
                        }
                        setState(() {});
                      },
                      child: Image.asset(
                        'assets/images/amongSkin.gif',
                        width: 200,
                      ),
                    ),
                    Text(
                      S.of(context).menuPage_tip,
                      style: TextStyle(fontSize: 16),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          S.of(context).menuPage_skip,
                          style: TextStyle(fontSize: 16),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            trainingEnd();
                            isNotTraining = true;
                            playAudio();
                            wantLoad = true;
                            setState(() {});
                          },
                          child: Icon(Icons.close),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
