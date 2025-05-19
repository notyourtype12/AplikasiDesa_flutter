import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void showCustomSnackbar({
  required BuildContext context,
  required String message,
  required Color backgroundColor,
  IconData? icon,
}) {
  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: backgroundColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    duration: const Duration(seconds: 3),
    content: Row(
      children: [
        if (icon != null)
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Icon(icon, color: Colors.white),
          ),
        Expanded(
          child: Text(
            message,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
