import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextWithStyle extends Text {
  // ignore: use_key_in_widget_constructors
  TextWithStyle(
      {required String data,
      Color color = Colors.black,
      double size = 18,
      weight = FontWeight.normal})
      : super(data,
            style: GoogleFonts.openSans(
                color: color, fontSize: size, fontWeight: weight));
}
