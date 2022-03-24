import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/generated/l10n.dart';
import 'menu.dart';

class FinalPage extends StatefulWidget {
  @override
  _FinalPage createState() => _FinalPage();
}

class _FinalPage extends State<FinalPage> {
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
          title: Text(S.of(context).finalPage_endText),
        ),
        body: Stack(
          children: [
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: Image(
                  image: AssetImage('assets/images/finalBackground.gif'),
                ),
              ),
            ),
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/medal.webp',
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 0, top: 50),
                    child: SizedBox(
                      width: 200,
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.deepOrangeAccent, width: 2),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Among Clicker',
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(S.of(context).finalPage_authors),
                            Text('Azamat Almatov'),
                            Text(''),
                            Text('Devio Software 2021'),
                          ],
                        ),
                      ),
                    ),
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
