import 'dart:convert';

import 'package:flutter/material.dart';
import '../../component/input_container.dart';
import '../../constants.dart';
import 'package:http/http.dart' as http;
import '../../accueil/accueil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double viewInset = MediaQuery.of(context).viewInsets.bottom;
    double defaultLoginSize = size.height - (size.height * 0.2);
    double defaultRegisterSize = size.height - (size.height * 0.1);

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: -35,
            child: Image.asset(
              "assets/images/main.jpg",
              width: size.width * 0.3,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              "assets/images/green_top.png",
              width: size.width * 0.3,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              "assets/images/orange_bottom.png",
              width: size.width * 0.2,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Container(
                width: size.width,
                height: defaultLoginSize,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Authentification",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                          color: kPrimaryColor),
                    ),
                    SizedBox(height: 30),
                    Image.asset(
                      "assets/icons/logoSA.svg",
                      height: size.height * 0.20,
                    ),
                    SizedBox(height: 30),

                    // RoundedInput(icon: Icons.mail, hint: "Username"),
                    InputContainer(
                        child: TextField(
                      controller: usernameController,
                      cursorColor: kPrimaryColor,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.email, color: kPrimaryColor),
                          hintText: "Username",
                          border: InputBorder.none),
                    )),

                    // RoundedPasswordInput(hint: 'Password'),

                    InputContainer(
                        child: TextField(
                      controller: passwordController,
                      cursorColor: kPrimaryColor,
                      obscureText: true,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.lock, color: kPrimaryColor),
                          hintText: "Password",
                          border: InputBorder.none),
                    )),

                    //RoundedButton(title: 'LOGIN'),

                    InkWell(
                      onTap: () {
                        setState(() {
                          _isLoading = true;
                        });
                        login();
                      },
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: kPrimaryColor,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.center,
                        child: const Text(
                          "LOGIN",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  static const snackBar = SnackBar(
    content: Text("Remplissez tous les champs..."),
  );
  static const snackBar1 = SnackBar(
    content: Text("Invalid Credentials"),
  );

  // login() async {
  //   //Map data = {
  //    // "username": username,
  //    // "password": password
  //  // };
  //   if(passwordController.text.isNotEmpty && usernameController.text.isNotEmpty) {
  //     dynamic jsonData;
  //     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //     var response = await http.post(
  //         Uri.parse("https://projet-carte.herokuapp.com/api/login"),
  //         body: ({
  //           "username": usernameController.text,
  //           "password": passwordController.text
  //         }));
  //     if (response.statusCode == 200) {
  //       jsonData = json.decode(response.body);
  //       setState(() {
  //         sharedPreferences.setString("accessToken", jsonData['accessToken']);
  //         Navigator.push(
  //                 context,
  //                  MaterialPageRoute(builder: (context) {
  //                    return Accueil();
  //                 }),
  //               );
  //       //  Navigator.of(context).pushAndRemoveUntil(
  //        //     MaterialPageRoute(builder: (BuildContext context) => Accueil()), (
  //          //   Route<dynamic> route) => false);
  //       });
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(snackBar1);
  //     }
  //   }else {
  //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //   }
  // }

  //CREATE FUNCTION TO CALL POST API

  Future<void> login() async {
    if (passwordController.text.isNotEmpty &&
        usernameController.text.isNotEmpty) {
      dynamic jsonData;
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final response = await http.post(
        Uri.parse('https://projet-carte.herokuapp.com/api/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': usernameController.text,
          'password': passwordController.text
        }),
      );
      if (response.statusCode == 200) {
        // If the server did return a 201 CREATED response,
        // then parse the JSON.
        jsonData = json.decode(response.body);
        setState(() {
          sharedPreferences.setString("accessToken", jsonData['accessToken']);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Accueil()));
        });
      } else {
        // If the server did not return a 201 CREATED response,
        // then throw an exception.
        ScaffoldMessenger.of(context).showSnackBar(snackBar1);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
