// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:convert';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:flutter/material.dart';
import 'package:odc_pointage/accueil/accueilApp.dart';
import 'package:odc_pointage/constants.dart';
import 'package:odc_pointage/text_with_style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sweetalert/sweetalert.dart';

import '../Screens/login/login.dart';
import '../component/input_container.dart';
import 'modifierInfoApp.dart';

class ModifierPassword extends StatefulWidget {
  const ModifierPassword({Key? key}) : super(key: key);

  @override
  State<ModifierPassword> createState() => ModifierPasswordState();
}

class ModifierPasswordState extends State<ModifierPassword> {
  bool onPressed = false;
  late SharedPreferences sharedPreferences;

  dynamic user;

  TextEditingController password = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

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
      setState(() => user = json.decode(response.body));
    }
  }

  Future<void> updateApp() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("accessToken");
    String? id = sharedPreferences.getString("id");
    if (password.text.trim().isEmpty ||
        newPassword.text.trim().isEmpty ||
        confirmPassword.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("remplir tous les champs..."),
      ));
      setState(() => onPressed = false);
    } else {
      if (new DBCrypt().checkpw(password.text, user['password'])) {
        if (newPassword.text == confirmPassword.text) {
          final response = await http.put(
            Uri.parse(
                'https://projet-carte.herokuapp.com/api/apprenants/field/' +
                    id!),
            headers: <String, String>{
              'Authorization': 'Bearer ' + token!,
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{'password': newPassword.text}),
          );
          if (response.statusCode == 200) {
            setState(() => onPressed = false);
            SweetAlert.show(context,
                subtitle: "success",
                style: SweetAlertStyle.success, onPress: (bool isConfirm) {
              if (isConfirm) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AccueilApp()));
                return false;
              }
              return true;
            });
          } else
            setState(() => onPressed = false);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Les deux mot de passe ne correspondent pas..."),
          ));
          setState(() => onPressed = false);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Mot de passe incorrect..."),
        ));
        setState(() => onPressed = false);
      }
    }
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
                          child: Text("Modifier mes informations"),
                        ),
                        PopupMenuItem<int>(
                          value: 2,
                          child: Text("Changer de mot de passe"),
                        ),
                        PopupMenuItem<int>(
                          value: 3,
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ModifierPassword()));
                      } else if (value == 3) {
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
                    controller: password,
                    cursorColor: OrangeColor,
                    obscureText: true,
                    decoration: const InputDecoration(
                        hintText: "Mot de passe actuel",
                        border: InputBorder.none),
                  )),
                  const SizedBox(height: 10),
                  InputContainer(
                      child: TextField(
                    controller: newPassword,
                    cursorColor: OrangeColor,
                    obscureText: true,
                    decoration: const InputDecoration(
                        hintText: "Nouveau mot de passe",
                        border: InputBorder.none),
                  )),
                  const SizedBox(height: 10),
                  InputContainer(
                      child: TextField(
                    controller: confirmPassword,
                    cursorColor: OrangeColor,
                    obscureText: true,
                    decoration: const InputDecoration(
                        hintText: "Confirmer mot de passe",
                        border: InputBorder.none),
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
