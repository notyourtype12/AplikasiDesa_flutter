import 'package:flutter/material.dart';


// const String baseURL = "http://10.0.2.2:8000/api"; //emulator
const String baseURL = "http://192.168.0.107:8000/api"; 
// const String baseURL = "http://127.0.0.1:8000/api"; //chrome

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