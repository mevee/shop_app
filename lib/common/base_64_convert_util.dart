import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

String imageToBase64(String imagePath) {
  final bytes = File(imagePath).readAsBytesSync();
  return base64Encode(bytes);
}

Widget base64ToImage(String base64String) {
  // Decode Base64 to bytes
  final bytes = base64Decode(base64String);
  
  // Display in Image.memory()
  return Image.memory(
    bytes,
    fit: BoxFit.cover,
  );
}