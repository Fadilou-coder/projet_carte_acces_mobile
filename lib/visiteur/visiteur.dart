// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:projet_carte_acces/constants.dart';
import 'package:sweetalert/sweetalert.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Visiteur extends StatefulWidget {
  const Visiteur({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => VisiteurState();
}

class VisiteurState extends State<Visiteur> {
  int duration = 600;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Card(
            color: kPrimaryColor,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                  flex: 1,
                  child: CupertinoButton(
                      child: Image.asset(
                        "assets/images/entree.png",
                        width: size.width / 2,
                      ),
                      onPressed: () => test())),
              Expanded(
                  flex: 1,
                  child: CupertinoButton(
                      child: Image.asset("assets/images/sortie.png",
                          width: size.width / 2),
                      onPressed: () => scanQRCode("sortie"))),
            ])),
      ),
    );
  }

  test() {
    final user =
        jsonDecode('{"cni": "1111111111111", "date": "2022-03-18 19:27:00"}');
    var parsedDate = DateTime.parse(user['date']);
    SweetAlert.show(context,
        subtitle:
            (DateTime.now().difference(parsedDate).inHours).round().toString(),
        style: SweetAlertStyle.success, onPress: (bool isConfirm) {
      return false;
    });
  }

  Future<void> scanQRCode(String action) async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );

      SweetAlert.show(
        context,
        subtitle: "patientez...",
        style: SweetAlertStyle.loading,
      );
      if (action == "entree") {
        // ignore: unrelated_type_equality_checks
        if ((await entree(qrCode)) == false) {
          setState(() {
            duration = 1;
          });
          Future.delayed(Duration(seconds: duration), () {
            SweetAlert.show(context,
                subtitle: "success",
                style: SweetAlertStyle.success, onPress: (bool isConfirm) {
              if (isConfirm) {
                scanQRCode(action);
                return false;
              }
              // return false to keep dialog
              return false;
            });
          });
        } else {
          setState(() {
            duration = 1;
          });
          Future.delayed(Duration(seconds: duration), () {
            SweetAlert.show(context,
                subtitle: "Attention!!!",
                title: "Access refuser!",
                style: SweetAlertStyle.error, onPress: (bool isConfirm) {
              if (isConfirm) {
                scanQRCode(action);
                return false;
              }
              // return false to keep dialog
              return false;
            });
          });
        }
      } else if (action == "sortie") {
        // ignore: unrelated_type_equality_checks
        if ((await sortie(qrCode)) == true) {
          setState(() {
            duration = 1;
          });
          Future.delayed(Duration(seconds: duration), () {
            SweetAlert.show(context,
                subtitle: "success",
                style: SweetAlertStyle.success, onPress: (bool isConfirm) {
              if (isConfirm) {
                scanQRCode(action);
                return false;
              }
              // return false to keep dialog
              return false;
            });
          });
        } else {
          setState(() {
            duration = 1;
          });
          Future.delayed(Duration(seconds: duration), () {
            SweetAlert.show(context,
                subtitle: "Attention!!!",
                title: "Qr Code invalide!",
                style: SweetAlertStyle.error, onPress: (bool isConfirm) {
              if (isConfirm) {
                scanQRCode(action);
                return false;
              }
              // return false to keep dialog
              return false;
            });
          });
        }
      }
    } on PlatformException {
      setState(() {
        duration = 1;
      });
      Future.delayed(Duration(seconds: duration), () {
        SweetAlert.show(context,
            subtitle: "Erreur scan",
            style: SweetAlertStyle.confirm, onPress: (bool isConfirm) {
          if (isConfirm) {
            scanQRCode(action);
          }
          // return false to keep dialog
          return false;
        });
      });
    }
  }

  Future<bool> entree(String qrCode) async {
    final user = jsonDecode(qrCode);
    var parsedDate = DateTime.parse(user['date']);
    if ((DateTime.now().difference(parsedDate).inHours).round() >= 1) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> sortie(String qrCode) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("accessToken");
    final user = jsonDecode(qrCode);
    final response = await http.post(
      Uri.parse(
          'https://projet-carte.herokuapp.com/api/visites/sortieVisiteur'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + token!,
      },
      body: jsonEncode(<String, Object>{
        "visiteur": {'cni': user['cni']}
      }),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
