import 'package:untitled1/generated/l10n.dart';
import 'package:untitled1/pages/menu.dart';
import 'package:untitled1/pages/playGround.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class PlayPage extends StatefulWidget {
  @override
  _PlayPage createState() => _PlayPage();
}

class _PlayPage extends State<PlayPage> {
  late String lvl;
  late String randToken;
  var postJson = [];
  bool isLoading = true;

  Future<void> getSqlData() async {
    var url = "";
    var response = await http.post(Uri.parse(url), body: {
      "randToken": randToken,
    });
    var data = json.decode(response.body);
    postJson = data;
    lvl = postJson[0]['lvl'];
    isLoading = false;
    setState(() {});
  }

  Future<void> getAllSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    randToken = prefs.getString('cookieToken')!;
    setState(() {});
    await getSqlData();
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
    super.dispose();
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
          title: Text(S.of(context).playPage_title),
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
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PlayGround(thisLvl: '1')));
                        }, // Handle your callback
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image.asset(
                              'assets/images/noob.webp',
                              height: 100,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  S.of(context).playPage_noob,
                                  style: TextStyle(fontSize: 16),
                                ),
                                (int.parse(lvl) > 0)
                                    ? Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            color: Colors.orangeAccent,
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Colors.orangeAccent,
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Colors.orangeAccent,
                                          ),
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          Icon(Icons.star_border),
                                          Icon(Icons.star_border),
                                          Icon(Icons.star_border),
                                        ],
                                      ),
                              ],
                            ),
                            Text(''),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: InkWell(
                        onTap: () {
                          if (int.parse(lvl) > 0) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PlayGround(thisLvl: '2')));
                          } else {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.pinkAccent,
                              content: Text(
                                S.of(context).playPage_try,
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
                        }, // Handle your callback
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image.asset(
                              'assets/images/soldier.webp',
                              height: 100,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  S.of(context).playPage_soldier,
                                  style: TextStyle(fontSize: 16),
                                ),
                                (int.parse(lvl) > 1)
                                    ? Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            color: Colors.orangeAccent,
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Colors.orangeAccent,
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Colors.orangeAccent,
                                          ),
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          Icon(Icons.star_border),
                                          Icon(Icons.star_border),
                                          Icon(Icons.star_border),
                                        ],
                                      ),
                              ],
                            ),
                            Text(''),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: InkWell(
                        onTap: () {
                          if (int.parse(lvl) > 1) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PlayGround(thisLvl: '3')));
                          } else {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.pinkAccent,
                              content: Text(
                                S.of(context).playPage_try,
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
                        }, // Handle your callback
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image.asset(
                              'assets/images/candidate.webp',
                              height: 100,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  S.of(context).playPage_candidate,
                                  style: TextStyle(fontSize: 16),
                                ),
                                (int.parse(lvl) > 2)
                                    ? Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            color: Colors.orangeAccent,
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Colors.orangeAccent,
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Colors.orangeAccent,
                                          ),
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          Icon(Icons.star_border),
                                          Icon(Icons.star_border),
                                          Icon(Icons.star_border),
                                        ],
                                      ),
                              ],
                            ),
                            Text(''),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: InkWell(
                        onTap: () {
                          if (int.parse(lvl) > 2) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PlayGround(thisLvl: '4')));
                          } else {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.pinkAccent,
                              content: Text(
                                S.of(context).playPage_try,
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
                        }, // Handle your callback
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image.asset(
                              'assets/images/expert.webp',
                              height: 100,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  S.of(context).playPage_expert,
                                  style: TextStyle(fontSize: 16),
                                ),
                                (int.parse(lvl) > 3)
                                    ? Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            color: Colors.orangeAccent,
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Colors.orangeAccent,
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Colors.orangeAccent,
                                          ),
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          Icon(Icons.star_border),
                                          Icon(Icons.star_border),
                                          Icon(Icons.star_border),
                                        ],
                                      ),
                              ],
                            ),
                            Text(''),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: InkWell(
                        onTap: () {
                          if (int.parse(lvl) > 3) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PlayGround(thisLvl: '5')));
                          } else {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.pinkAccent,
                              content: Text(
                                S.of(context).playPage_try,
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
                        }, // Handle your callback
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image.asset(
                              'assets/images/boss.webp',
                              height: 100,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  S.of(context).playPage_boss,
                                  style: TextStyle(fontSize: 16),
                                ),
                                (int.parse(lvl) > 4)
                                    ? Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            color: Colors.orangeAccent,
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Colors.orangeAccent,
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Colors.orangeAccent,
                                          ),
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          Icon(Icons.star_border),
                                          Icon(Icons.star_border),
                                          Icon(Icons.star_border),
                                        ],
                                      ),
                              ],
                            ),
                            Text(''),
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
