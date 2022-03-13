import 'package:flutter/material.dart';
import '../constants.dart';
import 'input_container.dart';


class RoundedPasswordInput extends StatelessWidget {
  const RoundedPasswordInput ({
    Key? key,
    required this.hint
  }) : super(key: key);

  final String hint;

  @override
  Widget build(BuildContext context){
    var passwordController = TextEditingController();
    return InputContainer(
        child: TextField(
          controller: passwordController,
          cursorColor: kPrimaryColor,
          obscureText: true,
          decoration: InputDecoration(
              icon: Icon(Icons.lock, color: kPrimaryColor),
              hintText: hint,
              border: InputBorder.none
          ),
        ));
  }
}
