import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateFormatter {
  /// Returns current date in 'yyyy-MM-ddTHH:mm:ss' format
  static String getCurrentDateTimeString() {
    return DateTime.now().toIso8601String().substring(0, 19);
  }

  /// Formats a DateTime object to 'yyyy-MM-ddTHH:mm:ss' format
  static String formatDateTime(DateTime dateTime) {
    return dateTime.toIso8601String().substring(0, 19);
  }

  /// Parses a string in 'yyyy-MM-ddTHH:mm:ss' format to DateTime
  static DateTime parseDateTimeString(String dateString) {
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return DateTime.now();
    }
  }

  /// Returns current date in 'yyyy-MM-dd' format
  static String get currentDate {
    final now = DateTime.now();
    return _formatDate(now);
  }

  /// Formats a DateTime to 'yyyy-MM-dd' format
  static String format(DateTime date) {
    return _formatDate(date);
  }

  /// Parses a 'yyyy-MM-dd' string to DateTime
  static DateTime parse(String dateString) {
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return DateTime.now();
    }
  }

  /// Parses a 'yyyy-MM-dd' string to DateTime
  static bool isToday(String dateString) {
    try {
      DateTime givenDate = DateTime.parse(dateString);
      DateTime now = DateTime.now();
      return givenDate.isAtSameMomentAs(now);
    } catch (e) {
      return false;
    }
  }

  // Parses a 'yyyy-MM-dd' string to DateTime
  static bool isPastDate(String dateString) {
    try {
      DateTime givenDate = DateTime.parse(dateString);
      DateTime now = DateTime.now();
      return givenDate.isBefore(now);
    } catch (e) {
      return false;
    }
  }

  // Parses a 'yyyy-MM-dd' string to DateTime
  static bool isFutureDate(String dateString) {
    try {
      DateTime givenDate = DateTime.parse(dateString);
      DateTime now = DateTime.now();
      if (givenDate.isBefore(now)) {
        return false;
      } else if (givenDate.isAtSameMomentAs(now)) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  static String _formatDate(DateTime date) {
    return '${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)}';
  }

  static String _twoDigits(int n) => n.toString().padLeft(2, '0');
  static String to24Format(String time12Hour) {
    try {
      // Parse the 12-hour format string to DateTime
      DateFormat inputFormat = DateFormat("yyyy-MM-dd'T'h:mm a");
      DateTime dateTime = inputFormat.parse(time12Hour);
      //-----
      DateFormat outputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
      String time24Hour = outputFormat.format(dateTime);
      return time24Hour;
    } catch (e) {
      return "";
    }
  }

  static String getTimeDifference(String? isoTimeString, String? logouteTime) {
    if (isoTimeString == null) return "0h 0m";
    if (logouteTime == null) return "0h 0m";
    try {
      final givenTime = DateTime.parse(isoTimeString);
      final currentTime = DateTime.parse(logouteTime);
      // final currentTime = DateTime.now();
      final difference = currentTime
          .difference(givenTime)
          .abs(); // Ensure positive duration

      final hours = difference.inHours;
      final minutes = difference.inMinutes.remainder(
        60,
      ); // Remaining minutes after full hours

      return "${hours}h ${minutes}m";
    } catch (e) {
      return "0h 0m"; // Fallback if parsing fails
    }
  }
}

extension TimeOfDayExtension on TimeOfDay {
  String to24hour() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}
