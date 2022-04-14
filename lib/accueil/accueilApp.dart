import 'package:flutter/material.dart';
import 'package:odc_pointage/carteApprenant.dart';
import 'package:odc_pointage/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/login/login.dart';
import '../text_with_style.dart';
import 'modifierInfoApp.dart';

class AccueilApp extends StatefulWidget {
  const AccueilApp({Key? key}) : super(key: key);

  @override
  State<AccueilApp> createState() => AccueilAppState();
}

class AccueilAppState extends State<AccueilApp> {
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
    double wCarte = 390;
    double hCarte = 300;
    return (DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: TextWithStyle(
                  data: "Systeme de Pointage des Apprenants",
                  size: 16,
                  color: Colors.white),
              automaticallyImplyLeading: false,
              elevation: 1.0,
              actions: [
                PopupMenuButton(
                    icon: Icon(Icons.menu, color: OrangeColor),
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem<int>(
                          value: 0,
                          child: Text("Ma Carte"),
                        ),
                        PopupMenuItem<int>(
                          value: 1,
                          child: Text("Parametre Compte"),
                        ),
                        PopupMenuItem<int>(
                          value: 2,
                          child: Image.asset("assets/icons/logout.png",
                              width: size.width / 4),
                        ),
                      ];
                    },
                    onSelected: (value) {
                      if (value == 0) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AccueilApp()));
                      } else if (value == 1) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ModifierInfoApp()));
                      } else if (value == 2) {
                        sharedPreferences.clear();
                        checkLoginStatus();
                      }
                    }),
              ],
            ),
            body: SizedBox(
                width: size.width,
                height: size.height,
                child: Stack(alignment: Alignment.center, children: <Widget>[
                  Positioned(
                      top: 10,
                      child: TextWithStyle(
                          data: "Ma Carte d'Access",
                          size: 22,
                          weight: FontWeight.bold)),
                  Positioned(
                      top: size.height * 0.1,
                      width: wCarte,
                      height: hCarte,
                      child: CarteApprenant()),
                  Positioned(
                      top: (size.height * 0.1) + 320,
                      child: Column(children: [
                        TextWithStyle(
                          data: "Statistique du mois de Avril 2022",
                          size: 22,
                        ),
                        Row(
                          children: [
                            TextWithStyle(
                                data: "Nombre de minutes Retard: ",
                                size: 22,
                                weight: FontWeight.bold),
                            TextWithStyle(
                              data: "12",
                              size: 22,
                              color: OrangeColor,
                            )
                          ],
                        ),
                        Row(
                          children: [
                            TextWithStyle(
                                data: "Nombre d'Absence: ",
                                size: 22,
                                weight: FontWeight.bold),
                            TextWithStyle(
                              data: "00",
                              size: 22,
                              color: OrangeColor,
                            )
                          ],
                        ),
                        SizedBox(height: 20),
                        TextWithStyle(
                            data: "Attention!!!",
                            size: 22,
                            color: Colors.red,
                            weight: FontWeight.bold),
                        TextWithStyle(
                          data: "Vous serez sanctionné si vous dépassez :",
                          size: 19,
                        ),
                        TextWithStyle(
                            data: "- 60 minutes de retard,",
                            size: 22,
                            weight: FontWeight.bold),
                        TextWithStyle(
                            data: "- 3 abscences",
                            size: 22,
                            weight: FontWeight.bold),
                      ]))
                ])))));
  }
}
