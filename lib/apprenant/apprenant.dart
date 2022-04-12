// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Apprenant extends StatefulWidget {
  const Apprenant({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ApprenantState();
}

class ApprenantState extends State<Apprenant> {
  int duration = 600;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Card(
            color: Colors.white,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                  flex: 1,
                  child: CupertinoButton(
                      child: Image.asset(
                        "assets/images/entree.png",
                        width: size.width / 2,
                      ),
                      onPressed: () => scanQRCode("entree"))),
              Expanded(
                flex: 1,
                child: CupertinoButton(
                    child: Image.asset("assets/images/sortie.png",
                        width: size.width / 2),
                    onPressed: () => scanQRCode("sortie")),
              ),
            ])),
      ),
    );
  }

  Future<void> scanQRCode(String action) async {
    // SweetAlert.show(
    //   context,
    //   subtitle: "patientez...",
    //   style: SweetAlertStyle.loading,
    // );
    // bool status = await entree("1 254 5678 90101");
    // if (status == true) {
    //   setState(() {
    //     duration = 1;
    //   });
    //   Future.delayed(Duration(seconds: duration), () {
    //     SweetAlert.show(context,
    //         subtitle: "success",
    //         style: SweetAlertStyle.success, onPress: (bool isConfirm) {
    //       if (isConfirm) {
    //         scanQRCode(action);
    //       }
    //       // return false to keep dialog
    //       return false;
    //     });
    //   });
    // }

    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );
      if (qrCode != "-1") {
        SweetAlert.show(
          context,
          subtitle: "patientez...",
          style: SweetAlertStyle.loading,
        );
        if (action == "entree") {
          if ((await entree(qrCode)) == true) {
            setState(() {
              duration = 1;
            });
            Future.delayed(Duration(seconds: duration), () {
              SweetAlert.show(context,
                  subtitle: "success", style: SweetAlertStyle.success);
            });
          } else {
            setState(() {
              duration = 1;
            });
            Future.delayed(Duration(seconds: duration), () {
              SweetAlert.show(context,
                  subtitle: "Attention!!!", title: "Qr Code invalide!");
            });
          }
        } else if (action == "sortie") {
          if ((await sortie(qrCode)) == true) {
            setState(() {
              duration = 1;
            });
            Future.delayed(Duration(seconds: duration), () {
              SweetAlert.show(context,
                  subtitle: "success", style: SweetAlertStyle.success);
            });
          } else {
            setState(() {
              duration = 1;
            });
            Future.delayed(Duration(seconds: duration), () {
              SweetAlert.show(context,
                  subtitle: "Attention!!!",
                  title: "Qr Code invalide!",
                  style: SweetAlertStyle.error);
            });
          }
        }
      }
    } on PlatformException {
      setState(() {
        duration = 1;
      });
      Future.delayed(Duration(seconds: duration), () {
        SweetAlert.show(context,
            subtitle: "Erreur scan", style: SweetAlertStyle.confirm);
      });
    }
  }

  Future<bool> entree(String qrCode) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("accessToken");
    final response = await http.post(
      Uri.parse(
          'https://projet-carte.herokuapp.com/api/visites/create/apprenant'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + token!,
      },
      body: jsonEncode(<String, Object>{
        "apprenant": {'code': qrCode}
      }),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> sortie(String qrCode) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("accessToken");
    final response = await http.post(
      Uri.parse(
          'https://projet-carte.herokuapp.com/api/visites/sortieApprenant'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + token!,
      },
      body: jsonEncode(<String, Object>{
        "apprenant": {'code': qrCode}
      }),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
