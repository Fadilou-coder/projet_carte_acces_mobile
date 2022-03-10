import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
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
    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Card(
            color: const Color.fromRGBO(19, 138, 138, 100),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              CupertinoButton(
                  child: Image.asset(
                    "images/entree.png",
                    width: size.width / 2.5,
                  ),
                  onPressed: () => scanQRCode("entree")),
              CupertinoButton(
                child:
                    Image.asset("images/sortie.png", width: size.width / 2.5),
                onPressed: () => scanQRCode("sortie"),
              ),
            ])),
      ),
    );
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
