// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:convert';
import 'dart:io';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:odc_pointage/text_with_style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CarteApprenant extends StatefulWidget {
  const CarteApprenant({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CarteApprenantState();
}

class CarteApprenantState extends State<CarteApprenant> {

   //PickedFile? _imageFile;
   //final ImagePicker _picker = ImagePicker();

  late SharedPreferences sharedPreferences;
  var app = new Map<String, dynamic>();
  @override
  void initState() {
    super.initState();
    findApp();
  }

  Future<void> findApp() async {
    dynamic user;
    sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("accessToken");
    String? id = sharedPreferences.getString("id");
    final response = await http.get(
      Uri.parse('https://projet-carte.herokuapp.com/api/apprenants/' + id!),
      // Uri.parse('http://localhost:8080/api/apprenants/' + id),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + token!
      },
    );

    if (response.statusCode == 200) {
      user = json.decode(response.body);
      setState(() {
        app = user;
      });
    }
  }

 // Widget imageProfile(){
   // return  Center(
    //child: Stack(children: <Widget>[
      // CircleAvatar(
       // radius: 40.0,
    // backgroundImage: _imageFile == null
     // ? AssetImage("assets/images/test.jpg") as ImageProvider
     // : FileImage(File(_imageFile!.path))
   // ),
    //Positioned(
     //child: InkWell(
      //onTap: (){
       //  showModalBottomSheet(context: context,
         //  builder: ((builder) => bottomSheet()),
          //);
         //},
      //child: Icon(
       // Icons.camera_alt,
        // color: Colors.teal,
        //  size: 20.0,
        // ),
    // ),
    // ),
    //  ],
    // )
   // );
 // }

 // Widget bottomSheet() {
   // return Container(
     //       height: 40.0,
       //     width: MediaQuery.of(context).size.width,
         //   child: Row(
          //  children: <Widget>[
          //  Text(
           //   "Choose Profile photo",
          //     style: TextStyle(
        //       fontSize: 20.0,
        //     ),
         //   ),
       //     Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      //      TextButton.icon(
     //       icon: Icon(Icons.camera),
  //          onPressed: () {
  //              takePhoto(ImageSource.camera);
     //        },
    //         label: Text("Camera"),
   //         ),
   //         TextButton.icon(
   //         icon: Icon(Icons.image),
    //        onPressed: () {
      //         takePhoto(ImageSource.gallery);
       //     },
    //         label: Text("Gallery"),
    //         ),
    //       ])
   //        ],
      //    ),
      //   );
     //  }

     //  void takePhoto(ImageSource source) async {
     //  final pickedFile = await _picker.pickImage(
     //    source: source,
   //   );
   //    setState(() {
  //       _imageFile = pickedFile as PickedFile;
   //   });
 // }

    @override
    Widget build(BuildContext context) {
      Size size = MediaQuery.of(context).size;
      if (app.toString() == "{}") {
        return Scaffold();
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
                          //  imageProfile(),
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
                child: Image.asset("assets/images/test.jpg", width: 80, height: 80,),
              ),
              Positioned(
                top: 175,
                right: 10,
                child: BarcodeWidget(
                  barcode: Barcode.qrCode(),
                  color: Colors.black,
                  data: app['code'],
                  width: 80,
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