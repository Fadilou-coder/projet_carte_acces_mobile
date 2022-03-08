import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:projet_carte_acces/text_with_style.dart';

class Accueil extends StatefulWidget {
  const Accueil({Key? key}) : super(key: key);

  @override
  State<Accueil> createState() => AccueilState();
}

class AccueilState extends State<Accueil> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      width: size.width,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
              top: 10,
              child: Image.asset("images/Logo-Sonatel-Academy.png",
                  width: size.width / 2),
              height: size.height * 0.5),
          Positioned(
            bottom: 0,
            right: 0,
            width: size.width,
            height: size.height * 0.5,
            child: Card(
                color: const Color.fromRGBO(19, 138, 138, 100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      CupertinoButton(
                          child: Image.asset("images/btn_app.png",
                              width: size.width / 3),
                          onPressed: () {}),
                      CupertinoButton(
                        child: Image.asset("images/btn_vst.png",
                            width: size.width / 3),
                        onPressed: () {},
                      ),
                    ]),
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
    ));
  }
}
