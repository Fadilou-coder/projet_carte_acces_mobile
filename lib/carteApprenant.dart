// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:convert';
import 'dart:typed_data';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:odc_pointage/text_with_style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'avatar/service.dart';

class CarteApprenant extends StatefulWidget {
  const CarteApprenant({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CarteApprenantState();
}

class CarteApprenantState extends State<CarteApprenant> {
  late SharedPreferences sharedPreferences;
  var app = new Map<String, dynamic>();
  var token = '';
  var id = '';
  var isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    findApp();
  }

  Uint8List convertBase64Image(String base64String) {
    return const Base64Decoder().convert(base64String.split(',').last);
  }

  void uploadImage(ImageSource imageSource, id, token) async {
    try {
      // ignore: deprecated_member_use
      final pickedFile = await ImagePicker().getImage(source: imageSource);
      isLoading(true);
      if (pickedFile != null) {
        var response =
            await ImageService.uploadFile(pickedFile.path, id, token);

        if (response.statusCode == 200) {
          setState(() {
            app = response.data;
          });
          Get.snackbar('Success', 'Image uploaded successfully',
              margin: const EdgeInsets.only(top: 5, left: 10, right: 10));
        } else {
          Get.snackbar('Failed', 'Choisissez une image inférieur à 2MB',
              margin: const EdgeInsets.only(top: 5, left: 10, right: 10));
        }
      } else {
        Get.snackbar('Failed', 'Image not selected',
            margin: const EdgeInsets.only(top: 5, left: 10, right: 10));
      }
    } finally {
      isLoading(false);
    }
  }

  bottomSet() {
    return Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
        ),
        child: Wrap(
          alignment: WrapAlignment.end,
          crossAxisAlignment: WrapCrossAlignment.end,
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Camera'),
              onTap: () {
                Get.back();
                uploadImage(ImageSource.camera, id, token);
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Gallery'),
              onTap: () {
                Get.back();
                uploadImage(ImageSource.gallery, id, token);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget imageButtom() {
    if (isLoading.value) {
      return const CircleAvatar(
        backgroundImage: AssetImage('assets/icons/no_user.jpg'),
        child: Center(
            child: CircularProgressIndicator(
          backgroundColor: Colors.white,
        )),
      );
    } else {
      if (app['avatar'] != null) {
        return CircleAvatar(
            backgroundImage: Image.memory(
          convertBase64Image(app['avatar']),
          gaplessPlayback: true,
        ).image);
      } else {
        return const CircleAvatar(
          backgroundImage: AssetImage('assets/icons/no_user.jpg'),
        );
      }
    }
  }

  Future<void> findApp() async {
    dynamic user;
    sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("accessToken");
    String? id = sharedPreferences.getString("id");
    final response = await http.get(
      Uri.parse('https://projet-carte.herokuapp.com/api/apprenants/' + id!),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + token!
      },
    );

    if (response.statusCode == 200) {
      user = json.decode(response.body);
      setState(() {
        app = user;
        this.id = id;
        this.token = token;
      });
    }
  }

  Widget ImageProfil() {
    return SizedBox(
      height: 80,
      width: 80,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Obx(() {
            return GestureDetector(onTap: bottomSet, child: imageButtom());
          }),
          Positioned(
            right: -13,
            bottom: -10,
            child: SizedBox(
              height: 46,
              width: 46,
              child: TextButton(
                onPressed: () {
                  bottomSet();
                },
                child: SvgPicture.asset("assets/icons/CameraIcon.svg"),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (app.toString() == "{}") {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: CircularProgressIndicator(
          backgroundColor: Colors.white,
        )),
      );
    }
    return Scaffold(
      body: SizedBox(
          width: size.width,
          height: size.height,
          child: Stack(alignment: Alignment.center, children: <Widget>[
            Card(
                elevation: 24,
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Column(children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset("assets/images/logo_odc.png", width: 150),
                          Image.asset("assets/images/Logo-Sonatel-Academy.png",
                              width: 120),
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWithStyle(
                                  data: app['prenom'] + " " + app['nom'],
                                  size: 16,
                                  weight: FontWeight.bold,
                                ),
                                Row(children: [
                                  TextWithStyle(
                                      data: "Numero d'étudiant: ",
                                      size: 16,
                                      weight: FontWeight.bold),
                                  TextWithStyle(data: app['code'], size: 16),
                                ]),
                                Row(children: [
                                  TextWithStyle(
                                      data: "Réferentiel: ",
                                      size: 16,
                                      weight: FontWeight.bold),
                                  TextWithStyle(
                                      data: app['referentiel']['libelle'],
                                      size: 16),
                                ]),
                                TextWithStyle(
                                    data: "Date de naissance:",
                                    size: 16,
                                    weight: FontWeight.bold),
                                TextWithStyle(
                                    data: app['dateNaissance'] +
                                        " à " +
                                        app['lieuNaissance'],
                                    size: 16),
                                Row(children: [
                                  TextWithStyle(
                                      data: "Adresse: ",
                                      size: 16,
                                      weight: FontWeight.bold),
                                  TextWithStyle(
                                      data: app['addresse'], size: 16),
                                ]),
                                Row(children: [
                                  TextWithStyle(
                                      data: "Telephone: ",
                                      size: 16,
                                      weight: FontWeight.bold),
                                  TextWithStyle(data: app['phone'], size: 16),
                                ])
                              ]),
                        ]),
                  ]),
                )),
            Positioned(
              top: 95,
              right: 20,
              child: ImageProfil(),
            ),
            Positioned(
              top: 180,
              right: 15,
              child: BarcodeWidget(
                barcode: Barcode.qrCode(),
                color: Colors.black,
                data: app['code'],
                width: 90,
                height: 60,
              ),
            ),
            Positioned(
                bottom: 10,
                child: Row(children: [
                  TextWithStyle(
                      data: "Numero de contact d'urgence: ",
                      size: 14,
                      weight: FontWeight.bold),
                  TextWithStyle(data: app['numTuteur'], size: 14),
                ]))
          ])),
    );
  }
}
