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
    return DateTime.parse(dateString);
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
    return DateTime.parse(dateString);
  }

  /// Parses a 'yyyy-MM-dd' string to DateTime
  static bool isToday(String dateString) {
    DateTime givenDate = DateTime.parse(dateString);
    DateTime now = DateTime.now();
    return givenDate.isAtSameMomentAs(now);
  }

  // Parses a 'yyyy-MM-dd' string to DateTime
  static bool isPastDate(String dateString) {
    DateTime givenDate = DateTime.parse(dateString);
    DateTime now = DateTime.now();
    return givenDate.isBefore(now);
  }

  // Parses a 'yyyy-MM-dd' string to DateTime
  static bool isFutureDate(String dateString) {
    DateTime givenDate = DateTime.parse(dateString);
    DateTime now = DateTime.now();
    if (givenDate.isBefore(now)) {
      return false;
    } else if (givenDate.isAtSameMomentAs(now)) {
      return false;
    } else {
      return true;
    }
  }

  static String _formatDate(DateTime date) {
    return '${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)}';
  }

  static String _twoDigits(int n) => n.toString().padLeft(2, '0');
  static String to24Format(String time12Hour) {
    // Parse the 12-hour format string to DateTime
    DateFormat inputFormat = DateFormat("yyyy-MM-dd'T'h:mm a");
    DateTime dateTime = inputFormat.parse(time12Hour);
    //-----
    DateFormat outputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
    String time24Hour = outputFormat.format(dateTime);
    return time24Hour;
  }
}
