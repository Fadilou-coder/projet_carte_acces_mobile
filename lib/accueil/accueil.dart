import 'package:flutter/material.dart';
import 'package:projet_carte_acces/constants.dart';
import 'package:projet_carte_acces/text_with_style.dart';

import '../apprenant/apprenant.dart';
import '../visiteur/visiteur.dart';

class Accueil extends StatefulWidget {
  const Accueil({Key? key}) : super(key: key);

  @override
  State<Accueil> createState() => AccueilState();
}

class AccueilState extends State<Accueil> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            body: SizedBox(
          width: size.width,
          height: size.height,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                  top: 0,
                  child: Image.asset("assets/images/Logo-Sonatel-Academy.png",
                      width: size.width / 1.5),
                  height: size.height * 0.3),
              Positioned(
                  top: size.height * 0.3,
                  width: size.width,
                  height: size.height * 0.1,
                  child: Card(
                    color: kPrimaryLightColor,
                    child: TabBar(
                      indicatorColor: kPrimaryColor,
                      labelColor: kPrimaryColor,
                      tabs: [
                        Tab(
                          child: TextWithStyle(
                            data: "Apprenant",
                            color: kPrimaryColor,
                          ),
                        ),
                        Tab(
                          child: TextWithStyle(
                            data: "Visiteur",
                            color: kPrimaryColor,
                          ),
                        )
                      ],
                    ),
                  )),
              Positioned(
                bottom: 0,
                right: 0,
                width: size.width,
                height: size.height * 0.6,
                child: const Card(
                    color: kPrimaryColor,
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
                        TextWithStyle(
                          data: "sonatel academy  systeme pointage v1.0",
                          color: Colors.white,
                        )
                      ]))
            ],
          ),
        )));
  }
}
