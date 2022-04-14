import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:odc_pointage/accueil/accueilApp.dart';
import 'package:odc_pointage/constants.dart';
import 'package:odc_pointage/text_with_style.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sweetalert/sweetalert.dart';

import '../Screens/login/login.dart';
import '../component/input_container.dart';

class ModifierInfoApp extends StatefulWidget {
  const ModifierInfoApp({Key? key}) : super(key: key);

  @override
  State<ModifierInfoApp> createState() => ModifierInfoAppState();
}

class ModifierInfoAppState extends State<ModifierInfoApp> {
  bool onPressed = false;
  late SharedPreferences sharedPreferences;

  TextEditingController prenom = TextEditingController();
  TextEditingController nom = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController adresse = TextEditingController();
  TextEditingController typePiece = TextEditingController();
  TextEditingController numPiece = TextEditingController();
  TextEditingController dateNaissance = TextEditingController();
  TextEditingController lieuNaissance = TextEditingController();
  TextEditingController numTuteur = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    findApp();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("accessToken") == null) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
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
      print(user.toString());
      setState(() {
        prenom.text = user['prenom'];
        nom.text = user['nom'];
        email.text = user['email'];
        password.text = user['password'];
        confirmPassword.text = user['password'];
        phone.text = user['phone'];
        adresse.text = user['addresse'];
        numTuteur.text = user['numTuteur'];
        dateNaissance.text = user['dateNaissance'];
        lieuNaissance.text = user['lieuNaissance'];
        typePiece.text = user['typePiece'];
        numPiece.text = user['numPiece'];
      });
    }
  }

  final List<Map<String, dynamic>> _items = [
    {'value': 'CNI', 'label': 'CNI'},
    {'value': 'Passport', 'label': 'Passport'}
  ];

  Future<void> updateApp() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("accessToken");
    String? id = sharedPreferences.getString("id");
    var map = new Map<String, String>();
    map['prenom'] = prenom.text;
    map['nom'] = nom.text;
    map['email'] = email.text;
    // map['password'] = password.text;
    map['phone'] = phone.text;
    map['adresse'] = adresse.text;
    map['numTuteur'] = numTuteur.text;
    map['dateNaissance'] = dateNaissance.text;
    map['lieuNaissance'] = lieuNaissance.text;
    map['typePiece'] = typePiece.text;
    map['numPiece'] = numPiece.text;
    map['promo'] = "";
    map['referentiel'] = "";

    XFile xFile = XFile.fromData(Uint8List(16), path: "assets/images/test.jpg");
    var _request = http.MultipartRequest('PUT',
        Uri.parse('https://projet-carte.herokuapp.com/api/apprenants/' + id!));
    _request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Content-Type':
          'multipart/form-data; boundary=<calculated when request is sent>'
    });
    _request.fields.addAll(map);
    _request.files.add(http.MultipartFile.fromBytes(
        'avatar',
        await xFile.readAsBytes().then((value) {
          return value.cast();
        }),
        filename: xFile.path.toString() + xFile.name));
    return await _request.send().then((value) {
      if (value.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    });

    // if (response.statusCode == 200) {
    //   setState(() => onPressed = false);
    //   print(response.body.toString());
    // SweetAlert.show(context,
    //     subtitle: "success",
    //     style: SweetAlertStyle.success, onPress: (bool isConfirm) {
    //   if (isConfirm) {
    //     Navigator.push(context,
    //         MaterialPageRoute(builder: (context) => const AccueilApp()));
    //     return false;
    //   }
    //   return true;
    // });
    // }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: TextWithStyle(
                  data: "Systeme de Pointage des Apprenants",
                  size: 16,
                  color: Colors.white),
              automaticallyImplyLeading: false,
              elevation: 1.0,
              actions: [
                PopupMenuButton(
                    icon: Icon(Icons.menu, color: OrangeColor),
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem<int>(
                          value: 0,
                          child: Text("Ma Carte"),
                        ),
                        PopupMenuItem<int>(
                          value: 1,
                          child: Text("Parametre Compte"),
                        ),
                        PopupMenuItem<int>(
                          value: 2,
                          child: Image.asset("assets/icons/logout.png",
                              width: size.width / 4),
                        ),
                      ];
                    },
                    onSelected: (value) {
                      if (value == 0) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AccueilApp()));
                      } else if (value == 1) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ModifierInfoApp()));
                      } else if (value == 2) {
                        sharedPreferences.clear();
                        checkLoginStatus();
                      }
                    }),
              ],
            ),
            body: SingleChildScrollView(
                child: SizedBox(
              width: size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 10),
                  const Text(
                    "Modifier mes informations",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                        color: OrangeColor),
                  ),
                  const SizedBox(height: 10),
                  InputContainer(
                      child: TextField(
                    controller: prenom,
                    cursorColor: OrangeColor,
                    decoration: const InputDecoration(
                        hintText: "Prénom", border: InputBorder.none),
                  )),
                  const SizedBox(height: 10),
                  InputContainer(
                      child: TextField(
                    controller: nom,
                    cursorColor: OrangeColor,
                    decoration: const InputDecoration(
                        hintText: "Nom", border: InputBorder.none),
                  )),
                  const SizedBox(height: 10),
                  InputContainer(
                      child: TextField(
                    controller: email,
                    cursorColor: OrangeColor,
                    decoration: const InputDecoration(
                        hintText: "Email", border: InputBorder.none),
                  )),
                  const SizedBox(height: 10),
                  InputContainer(
                      child: TextField(
                    controller: password,
                    cursorColor: OrangeColor,
                    obscureText: true,
                    decoration: const InputDecoration(
                        hintText: "Password", border: InputBorder.none),
                  )),
                  const SizedBox(height: 10),
                  InputContainer(
                      child: TextField(
                    controller: confirmPassword,
                    cursorColor: OrangeColor,
                    obscureText: true,
                    decoration: const InputDecoration(
                        hintText: "Confirm password", border: InputBorder.none),
                  )),
                  const SizedBox(height: 10),
                  InputContainer(
                      child: TextField(
                    controller: phone,
                    cursorColor: OrangeColor,
                    decoration: const InputDecoration(
                        hintText: "N° Téléphone", border: InputBorder.none),
                  )),
                  const SizedBox(height: 10),
                  InputContainer(
                      child: TextField(
                    controller: adresse,
                    cursorColor: OrangeColor,
                    decoration: const InputDecoration(
                        hintText: "Adresse", border: InputBorder.none),
                  )),
                  const SizedBox(height: 10),
                  InputContainer(
                      child:
                          //  TextField(
                          //   controller: typePiece,
                          //   cursorColor: OrangeColor,
                          //   decoration: const InputDecoration(
                          //       hintText: "Type de Piece", border: InputBorder.none),
                          // )
                          SelectFormField(
                              type: SelectFormFieldType.dropdown,
                              initialValue: 'CNI',
                              labelText: 'Type de Piece',
                              items: _items,
                              onChanged: (val) => setState(() {
                                    typePiece.text = val;
                                  }),
                              onSaved: (val) => setState(() {
                                    typePiece.text = val!;
                                  }))),
                  const SizedBox(height: 10),
                  InputContainer(
                      child: TextField(
                    controller: numPiece,
                    cursorColor: OrangeColor,
                    decoration: const InputDecoration(
                        hintText: "N° Piece", border: InputBorder.none),
                  )),
                  const SizedBox(height: 10),
                  InputContainer(
                      child: TextField(
                          controller: dateNaissance,
                          cursorColor: OrangeColor,
                          decoration: const InputDecoration(
                              icon: Icon(Icons.calendar_today),
                              labelText: "Date de Naissance",
                              border: InputBorder.none),
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime(2007),
                                firstDate: DateTime(1991),
                                lastDate: DateTime(2007));
                            if (pickedDate != null) {
                              String date =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);

                              setState(() {
                                dateNaissance.text = date;
                              });
                            } else {}
                          })),
                  const SizedBox(height: 10),
                  InputContainer(
                      child: TextField(
                    controller: lieuNaissance,
                    cursorColor: OrangeColor,
                    decoration: const InputDecoration(
                        hintText: "Lieu de Naissance",
                        border: InputBorder.none),
                  )),
                  const SizedBox(height: 10),
                  InputContainer(
                      child: TextField(
                    controller: numTuteur,
                    cursorColor: OrangeColor,
                    decoration: const InputDecoration(
                        hintText: "N° Tuteur", border: InputBorder.none),
                  )),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () async {
                      setState(() => onPressed = true);
                      updateApp();
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                        width: size.width * 0.8,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: OrangeColor,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.center,
                        child: onPressed
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  CircularProgressIndicator(
                                      color: Colors.white),
                                  SizedBox(width: 24),
                                  Text('Patientez SVP...',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18))
                                ],
                              )
                            : const Text('Modifier',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold))),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ))));
  }
}
