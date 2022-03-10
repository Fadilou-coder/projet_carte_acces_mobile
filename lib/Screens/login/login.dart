import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../component/rounded_button.dart';
import '../../component/rounded_input.dart';
import '../../component/rounded_password.dart';
import '../../constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
   _LoginScreenState createState() => _LoginScreenState();
}

class  _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
       Size size = MediaQuery.of(context).size;

       double viewInset = MediaQuery.of(context).viewInsets.bottom;
       double defaultLoginSize = size.height -(size.height * 0.2);
       double defaultRegisterSize = size.height -(size.height * 0.1);

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

                     children:[
                       const Text(
                         "Authentification",
                         style: TextStyle(
                           fontWeight: FontWeight.bold,
                           fontSize: 26,
                           color: kPrimaryColor
                         ),
                       ),
                       SizedBox(height: 30),
                       Image.asset(
                         "assets/icons/logoSA.svg",
                         height: size.height * 0.35,
                       ),
                       SizedBox(height: 30),

                       RoundedInput(icon: Icons.mail, hint: "Username"),

                       RoundedPasswordInput(hint: 'Password'),

                       RoundedButton(title: 'LOGIN')
                     ],
                   ),
                 ),
               ),
             )
           ],
         ) ,
       );
  }
}