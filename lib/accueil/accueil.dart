import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';

class Accueil extends StatefulWidget {
  @override
  State<Accueil> createState() => AccueilState();
}

class AccueilState extends State<Accueil> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Image.asset("images/Logo-Sonatel-Academy.png"),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [],
            )
          ],
        ),
      ),
    );
  }
}
