import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:projet_carte_acces/constants.dart';
import 'package:sweetalert/sweetalert.dart';

class Visiteur extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => VisiteurState();
}

class VisiteurState extends State<Visiteur> {
  String qrCode = 'Unknown';

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
              CupertinoButton(
                  child: Image.asset(
                    "assets/images/entree.png",
                    width: size.width / 2.5,
                  ),
                  onPressed: () => scanQRCode("entree")),
              CupertinoButton(
                  child: Image.asset("assets/images/sortie.png",
                      width: size.width / 2.5),
                  onPressed: () => scanQRCode("entree")),
            ])),
      ),
    );
  }

  Future<void> scanQRCode(String action) async {
    SweetAlert.show(context,
        title: "success",
        subtitle: action + "enregistrer avec success",
        style: SweetAlertStyle.success);
    // try {
    //   final qrCode = await FlutterBarcodeScanner.scanBarcode(
    //     '#ff6666',
    //     'Cancel',
    //     true,
    //     ScanMode.QR,
    //   );

    //   if (!mounted) return;

    //   if (action == "entree") {

    //   }

    //   setState(() {
    //     this.qrCode = qrCode;
    //   });
    // } on PlatformException {
    //   qrCode = 'Failed to get platform version.';
    // }
  }
}
