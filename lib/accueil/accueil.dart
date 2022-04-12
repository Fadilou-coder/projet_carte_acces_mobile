import 'package:flutter/material.dart';
import 'package:odc_pointage/constants.dart';
import 'package:odc_pointage/text_with_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/login/login.dart';
import '../apprenant/apprenant.dart';
import '../visiteur/visiteur.dart';

class Accueil extends StatefulWidget {
  const Accueil({Key? key}) : super(key: key);

  @override
  State<Accueil> createState() => AccueilState();
}

class AccueilState extends State<Accueil> {
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("accessToken") == null) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              elevation: 1.0,
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    sharedPreferences.clear();
                    checkLoginStatus();
                  },
                  child: Image.asset("assets/icons/logout.png"),
                ),
              ],
            ),
            body: SizedBox(
              width: size.width,
              height: size.height,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Positioned(
                      top: 20,
                      child: Image.asset("assets/images/logo_odc.png",
                          width: size.width / 1.5),
                      height: size.height * 0.2),
                  Positioned(
                      bottom: size.height * 0.55,
                      width: size.width,
                      height: size.height * 0.1,
                      child: Card(
                        color: kPrimaryLightColor,
                        child: TabBar(
                          indicatorColor: OrangeColor,
                          labelColor: OrangeColor,
                          tabs: [
                            Tab(
                              child: TextWithStyle(
                                data: "Apprenant",
                                color: OrangeColor,
                              ),
                            ),
                            Tab(
                              child: TextWithStyle(
                                data: "Visiteur",
                                color: OrangeColor,
                              ),
                            )
                          ],
                        ),
                      )),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    width: size.width,
                    height: size.height * 0.55,
                    child: const Card(
                        color: Colors.white,
                        child: TabBarView(
                          children: [
                            MaterialApp(
                                debugShowCheckedModeBanner: false,
                                home: Apprenant()),
                            MaterialApp(
                                debugShowCheckedModeBanner: false,
                                home: Visiteur()),
                          ],
                        )),
                  ),
                  Positioned(
                      bottom: 10,
                      child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                TextWithStyle(
                                  data: "Orange ",
                                  color: OrangeColor,
                                ),
                                TextWithStyle(
                                  data: "Digital Center",
                                  color: Colors.black,
                                ),
                                TextWithStyle(
                                  data: " systeme pointage v1.0",
                                  color: OrangeColor,
                                )
                              ],
                            )
                          ]))
                ],
              ),
            )));
  }
}
