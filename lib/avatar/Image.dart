// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:odc_pointage/avatar/controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImageApp extends StatefulWidget {
  const ImageApp({Key? key}) : super(key: key);

  @override
  State<ImageApp> createState() => ImageAppState();
}

class ImageAppState extends State<ImageApp> {
  late SharedPreferences sharedPreferences;
  final ProfileController profilerController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    // checkLoginStatus();
  }

//   checkLoginStatus() async {
//     sharedPreferences = await SharedPreferences.getInstance();
//     if (sharedPreferences.getString("accessToken") == null) {
//       Navigator.push(context,
//           MaterialPageRoute(builder: (context) => const LoginScreen()));
//     }
//   }

  Uint8List convertBase64Image(String base64String) {
    return const Base64Decoder().convert(base64String.split(',').last);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              elevation: 1.0,
              //   actions: <Widget>[
              //     TextButton(
              //       onPressed: () {
              //         sharedPreferences.clear();
              //         checkLoginStatus();
              //       },
              //       child: Image.asset("assets/icons/logout.png"),
              //     ),
              //   ],
            ),
            body: SizedBox(
              width: size.width,
              height: size.height,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 40,
                        ),
                      ],
                    ),
                    child: SizedBox(
                      height: 115,
                      width: 115,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Obx(() {
                            if (profilerController.isLoading.value) {
                              return const CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/icons/no_user.jpg'),
                                child: Center(
                                    child: CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                )),
                              );
                            } else {
                              if (profilerController.imageURL.isNotEmpty) {
                                return CircleAvatar(
                                    backgroundImage: Image.memory(
                                  convertBase64Image(
                                      profilerController.imageURL),
                                  gaplessPlayback: true,
                                ).image);
                              } else {
                                return const CircleAvatar(
                                  backgroundImage:
                                      AssetImage('assets/icons/no_user.jpg'),
                                );
                              }
                            }
                          }),
                          Positioned(
                            right: -16,
                            bottom: 0,
                            child: SizedBox(
                              height: 46,
                              width: 46,
                              child: TextButton(
                                onPressed: () {
                                  Get.bottomSheet(
                                    Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(16.0),
                                            topRight: Radius.circular(16.0)),
                                      ),
                                      child: Wrap(
                                        alignment: WrapAlignment.end,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.end,
                                        children: [
                                          ListTile(
                                            leading: const Icon(Icons.camera),
                                            title: const Text('Camera'),
                                            onTap: () {
                                              Get.back();
                                              profilerController.uploadImage(
                                                  ImageSource.camera);
                                            },
                                          ),
                                          ListTile(
                                            leading: const Icon(Icons.image),
                                            title: const Text('Gallery'),
                                            onTap: () {
                                              Get.back();
                                              profilerController.uploadImage(
                                                  ImageSource.gallery);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                child: SvgPicture.asset(
                                    "assets/icons/CameraIcon.svg"),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}
