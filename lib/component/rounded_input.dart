import 'package:flutter/material.dart';
import '../constants.dart';
import 'input_container.dart';


class RoundedInput extends StatelessWidget {
  const RoundedInput ({
    Key? key,
    required this.icon,
    required this.hint
}) : super(key: key);

  final IconData icon;
  final String hint;

  @override
  Widget build(BuildContext context){
<<<<<<< HEAD
    return InputContainer(
        child: TextField(
=======
    var usernameController = TextEditingController();
    return InputContainer(
        child: TextField(
          controller: usernameController,
>>>>>>> 0b54d83d28d61d33ab638bfcc4916aef644c2193
      cursorColor: kPrimaryColor,
      decoration: InputDecoration(
          icon: Icon(icon, color: kPrimaryColor),
          hintText: hint,
          border: InputBorder.none
      ),
    ));
  }
}
