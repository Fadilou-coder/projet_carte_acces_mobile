import 'package:flutter/material.dart';
import '../constants.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton ({
    Key? key,
    required this.title,
}) : super (key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

<<<<<<< HEAD
=======

>>>>>>> 0b54d83d28d61d33ab638bfcc4916aef644c2193
    return  InkWell(
      onTap: (){},
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: size.width * 0.8,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
<<<<<<< HEAD
            color: kPrimaryColor
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        child: Text(
           title,
           style: TextStyle(
              color: Colors.white,
              fontSize: 18
          ),
        ),
=======
            color: kPrimaryColor,
        ),
        padding: const EdgeInsets.symmetric(vertical: 5),
        alignment: Alignment.center,
        //child: Text(
         //  title,
         //  style: const TextStyle(
              //color: Colors.white,
              //fontSize: 18
         // ),
        //),

          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              side: BorderSide(width: 2, color: Colors.white),
            ),
            onPressed: () => {},
            child: Text(title),
          )

>>>>>>> 0b54d83d28d61d33ab638bfcc4916aef644c2193
      ),
    );
  }
}