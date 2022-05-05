import 'package:flutter/material.dart';
import 'package:odc_pointage/accueil/ModifierPassword.dart';
import 'package:odc_pointage/carteApprenant.dart';
import 'package:odc_pointage/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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

  String nbrAbs = "00";
  String nbrRtd = "00";

  String currentMonth = "";

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    checkStats();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("accessToken") == null) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  checkCurrentMonth() {
    var mois = [
      "JANVIER",
      "FEVRIER",
      "MARS",
      "AVRIL",
      "MAI",
      "JUIN",
      "JUILLET",
      "AOUT",
      "SEPTEMBRE",
      "OCTOBRE",
      "NOVEMBRE",
      "DECEMBRE"
    ];

    DateTime today = new DateTime.now();

    int tmp = 0;

    mois.forEach((m) {
      if (tmp == today.month) {
        setState(() {
          currentMonth = m + " " + today.year.toString();
        });

        return;
      }
      tmp = tmp + 1;
    });
  }

  checkStats() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("accessToken");
    String? id = sharedPreferences.getString("id");

    DateTime today = new DateTime.now();

    String mp = (today.month + 1).toString();

    print(today.toString().substring(0, 7) + "-01");
    print(today.toString().substring(0, 6) + mp + "-01");

    final response = await http.get(
      Uri.parse('https://projet-carte.herokuapp.com/api/apprenants/' +
          id! +
          '/nbrAbs/' +
          today.toString().substring(0, 7) +
          "-01" +
          '/' +
          today.toString().substring(0, 6) +
          mp +
          "-01"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + token!
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        nbrAbs = response.body;
      });
    }

    final response1 = await http.get(
      Uri.parse('https://projet-carte.herokuapp.com/api/apprenants/' +
          id +
          '/nbrRetard/' +
          today.toString().substring(0, 7) +
          "-01" +
          '/' +
          today.toString().substring(0, 6) +
          mp +
          "-01"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + token
      },
    );

    if (response1.statusCode == 200) {
      setState(() {
        nbrRtd = response1.body;
      });
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
                          child: Text("Modifier mes informations"),
                        ),
                        PopupMenuItem<int>(
                          value: 2,
                          child: Text("Changer de mot de passe"),
                        ),
                        PopupMenuItem<int>(
                          value: 3,
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ModifierPassword()));
                      } else if (value == 3) {
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
                          data: "Statistique du mois de " + currentMonth,
                          size: 22,
                        ),
                        Row(
                          children: [
                            TextWithStyle(
                                data: "Nombre de minutes Retard: ",
                                size: 22,
                                weight: FontWeight.bold),
                            TextWithStyle(
                              data: nbrRtd,
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
                              data: nbrAbs,
                              size: 22,
                              color: OrangeColor,
                            )
                          ],
                        ),
                        SizedBox(height: 5),
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
