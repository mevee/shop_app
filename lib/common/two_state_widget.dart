import 'package:flutter/material.dart';

Widget twoState({
  bool state = false,
  required Widget child,
  required Widget replace,
}) {
  if (state) {
    return replace;
  } else {
    return child;
  }
}
