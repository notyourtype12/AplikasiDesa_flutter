import 'package:flutter/material.dart';


const String baseURL = "http://127.0.0.1:8000/api"; 

const Map<String, String> headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
};

void errorSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.red,
      content: Text(text),
      duration: const Duration(seconds: 3), 
      )
  );
}