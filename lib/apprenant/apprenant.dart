import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:projet_carte_acces/constants.dart';
import 'package:sweetalert/sweetalert.dart';

class Apprenant extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ApprenantState();
}

class ApprenantState extends State<Apprenant> {
  String qrCode = 'Unknown';
  int duration = 600;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
        child: Scaffold(
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
    ));
  }

  Future<void> scanQRCode(String action) async {
    SweetAlert.show(
      context,
      subtitle: "patientez...",
      style: SweetAlertStyle.loading,
    );
    setState(() {
      duration = 1;
    });
    Future.delayed(Duration(seconds: duration), () {
      SweetAlert.show(context,
          subtitle: "success",
          style: SweetAlertStyle.success, onPress: (bool isConfirm) {
        if (isConfirm) {
          scanQRCode(action);
        }
        // return false to keep dialog
        return false;
      });
    });

    // try {
    //   final qrCode = await FlutterBarcodeScanner.scanBarcode(
    //     '#ff6666',
    //     'Cancel',
    //     true,
    //     ScanMode.QR,
    //   );

    //   if (!mounted) return;

    // SweetAlert.show(
    //   context,
    //   subtitle: "patientez...",
    //   style: SweetAlertStyle.loading,
    // );

    // setState(() {
    //   duration = 1;
    // });
    // Future.delayed(Duration(seconds: duration), () {
    //   SweetAlert.show(context,
    //       subtitle: "success",
    //       style: SweetAlertStyle.success, onPress: (bool isConfirm) {
    //     if (isConfirm) {
    //       scanQRCode(action);
    //     }
    //     // return false to keep dialog
    //     return false;
    //   });
    // });

    //   setState(() {
    //     this.qrCode = qrCode;
    //   });
    // } on PlatformException {
    //   qrCode = 'Failed to get platform version.';
    // }
  }
}
