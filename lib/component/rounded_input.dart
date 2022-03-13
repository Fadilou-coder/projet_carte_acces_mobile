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
    var usernameController = TextEditingController();
    return InputContainer(
        child: TextField(
          controller: usernameController,
      cursorColor: kPrimaryColor,
      decoration: InputDecoration(
          icon: Icon(icon, color: kPrimaryColor),
          hintText: hint,
          border: InputBorder.none
      ),
    ));
  }
}
