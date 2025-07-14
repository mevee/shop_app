import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateUtil {
  static const String customDateFormat2 = 'dd MMM, yyyy';
}

Widget horizontalSpacing(double space) {
  return SizedBox(
    width: space,
  );
}

Widget verticalSpacing(double space) {
  return SizedBox(
    height: space,
  );
}

double getWidth(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  return width;
}

double getHeight(BuildContext context) {
  final height = MediaQuery.of(context).size.height;
  return height;
}

DateTime getCurrentDate() {
  return DateTime.fromMillisecondsSinceEpoch(
      DateTime.now().millisecondsSinceEpoch);
}

String formatEpochTime(int epochTime) {
  final DateTime date = DateTime.fromMillisecondsSinceEpoch(epochTime);

  final String formattedDate = DateFormat('MMMM d').format(date);

  return formattedDate;
}

double getLineHeight(int lineHeight) {
  return lineHeight / 16;
}
