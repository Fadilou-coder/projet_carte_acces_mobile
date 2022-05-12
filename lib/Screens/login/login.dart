import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:odc_pointage/accueil/accueilApp.dart';
import '../../component/input_container.dart';
import '../../constants.dart';
import 'package:http/http.dart' as http;
import '../../accueil/accueil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../text_with_style.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;

  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  String _deviceinfo = '';

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    initPlatformState();
  }

  checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool('isLoggedIn') ?? false;
    if (status) {
      if (prefs.getString("role") == "APPRENANT") {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AccueilApp()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Accueil()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double defaultLoginSize = size.height - (size.height * 0.2);

    return Scaffold(
      body: Stack(
        children: [
          //   Positioned(
          //     top: 0,
          //     right: 0,
          //     child: Image.asset(
          //       "assets/images/main.png",
          //       width: size.width * 0.3,
          //     ),
          //   ),
          //   Positioned(
          //     bottom: 0,
          //     right: 0,
          //     child: Image.asset(
          //       "assets/images/orange_bottom.png",
          //       width: size.width * 0.2,
          //     ),
          //   ),
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: SizedBox(
                width: size.width,
                height: defaultLoginSize,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Image.asset(
                      "assets/images/login.png",
                      height: size.height * 0.20,
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "Authentification",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                          color: OrangeColor),
                    ),
                    const SizedBox(height: 10),

                    // RoundedInput(icon: Icons.mail, hint: "Username"),
                    InputContainer(
                        child: TextField(
                      controller: usernameController,
                      cursorColor: OrangeColor,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.email, color: OrangeColor),
                          hintText: "Email",
                          border: InputBorder.none),
                    )),

                    // RoundedPasswordInput(hint: 'Password'),

                    InputContainer(
                        child: TextField(
                      controller: passwordController,
                      cursorColor: OrangeColor,
                      obscureText: true,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.lock, color: OrangeColor),
                          hintText: "Password",
                          border: InputBorder.none),
                    )),

                    InkWell(
                      onTap: () async {
                        setState(() => isLoading = true);
                        login();
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
                          child: isLoading
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    CircularProgressIndicator(
                                        color: Colors.white),
                                    SizedBox(width: 24),
                                    Text('Please Wait...',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 18))
                                  ],
                                )
                              : const Text('LOGIN',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold))),
                    ),

                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextWithStyle(data: "ID: "),
                        TextWithStyle(
                            data: _deviceinfo, weight: FontWeight.bold)
                      ],
                    )
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

  //CREATE FUNCTION TO CALL POST API

  Future<void> login() async {
    if (passwordController.text.isNotEmpty &&
        usernameController.text.isNotEmpty) {
      initPlatformState();
      dynamic jsonData;
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final response = await http.post(
        Uri.parse('https://projet-carte.herokuapp.com/api/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': usernameController.text,
          'password': passwordController.text
        }),
      );

      if (response.statusCode == 200) {
        jsonData = json.decode(response.body);
        if (jsonData['role'][0] == "APPRENANT") {
          setState(() {
            sharedPreferences.setString("accessToken", jsonData['accessToken']);
            sharedPreferences.setString("role", jsonData['role'][0]);
            sharedPreferences.setString("id", jsonData['id'].toString());

            sharedPreferences.setBool("isLoggedIn", true);
          });
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AccueilApp()));
        } else {
          final res = await http.get(
              Uri.parse(
                  'https://projet-carte.herokuapp.com/api/devices/adress/' +
                      _deviceinfo),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              });
          if (res.statusCode == 200) {
            setState(() {
              sharedPreferences.setString(
                  "accessToken", jsonData['accessToken']);
              sharedPreferences.setString("role", jsonData['role'][0]);
              sharedPreferences.setString("id", jsonData['id'].toString());
              sharedPreferences.setBool("isLoggedIn", true);

              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Accueil()));
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: TextWithStyle(
                  data:
                      "Vous ne pouvez pas acceder à l'application avec cet appareil veuillez contacter l'administration",
                  color: OrangeColor),
            ));
            setState(() => isLoading = false);
          }
        }
      } else {
        // If the server did not return a 201 CREATED response,
        // then throw an exception.
        ScaffoldMessenger.of(context).showSnackBar(snackBar1);
        setState(() => isLoading = false);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() => isLoading = false);
    }
  }

  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
        setState(() {
          _deviceinfo = deviceData['androidId'];
        });
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
        setState(() {
          _deviceinfo = deviceData['identifierForVendor'];
        });
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }
}
