import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedMonth = DateTime.now();
  // Dummy data for demonstration purposes
  // In a real application, this data would come from an API or database
  final Map<DateTime, List<String>> _dailyData = {
    // Example data for June 2025 (matching the image roughly)
    DateTime(2025, 6, 4): ['165 ...', 'Bho ...', 'Govi ...', 'Gul ...'],
    DateTime(2025, 6, 5): ['Gya ...', 'Gya ...', 'Jaip ...', 'Kho ...'],
    DateTime(2025, 6, 6): ['16 Gt ...', '191 G ...', 'Arthl ...', 'Gt R ...'],
    DateTime(2025, 6, 7): ['85 A ...', 'War ...', 'Gha ...', 'Kha ...'],
    DateTime(2025, 6, 8): ['Behr ...', 'Cros ...', 'Cros ...', 'Cros ...'],
    DateTime(2025, 6, 9): ['Bhar ...', 'Ghu ...', 'Pan ...', 'Plot ...'],
    DateTime(2025, 6, 10): ['165 ...', 'Bho ...', 'Govi ...', 'Gul ...'],
    DateTime(2025, 6, 11): ['Gya ...', 'Gya ...', 'Jaip ...', 'Kho ...'],
    DateTime(2025, 6, 12): ['16 Gt ...', '191 G ...', 'Arthl ...', 'Gt R ...'],
    DateTime(2025, 6, 13): ['85 A ...', 'War ...', 'Gha ...', 'Kha ...'],
    DateTime(2025, 6, 14): ['Behr ...', 'Cros ...', 'Cros ...', 'Cros ...'],
    DateTime(2025, 6, 15): ['Behr ...', 'Cros ...', 'Cros ...', 'Cros ...'],
    DateTime(2025, 6, 16): ['Behr ...', 'Cros ...', 'Cros ...', 'Cros ...'],
    DateTime(2025, 6, 17): ['Bhar ...', 'Ghu ...', 'Pan ...', 'Plot ...'],
    DateTime(2025, 6, 18): ['165 ...', 'Bho ...', 'Govi ...', 'Gul ...'],
    DateTime(2025, 6, 19): [
      '85 A ...',
      'War ...',
      'Gha ...',
      'Kha ...',
    ], // Red day in image
    DateTime(2025, 6, 20): ['16 Gt ...', '191 G ...', 'Arthl ...', 'Gt R ...'],
    DateTime(2025, 6, 21): ['Gya ...', 'Gya ...', 'Jaip ...', 'Kho ...'],
    DateTime(2025, 6, 22): ['Behr ...', 'Cros ...', 'Cros ...', 'Cros ...'],
    DateTime(2025, 6, 23): ['Behr ...', 'Cros ...', 'Cros ...', 'Cros ...'],
    DateTime(2025, 6, 24): [
      '165 ...',
      'Bho ...',
      'Govi ...',
      'Gul ...',
    ], // Red day in image
    DateTime(2025, 6, 25): ['Bhar ...', 'Ghu ...', 'Pan ...', 'Plot ...'],
    DateTime(2025, 6, 26): ['85 A ...', 'War ...', 'Gha ...', 'Kha ...'],
    DateTime(2025, 6, 27): ['Gya ...', 'Gya ...', 'Jaip ...', 'Kho ...'],
    DateTime(2025, 6, 28): ['16 Gt ...', '191 G ...', 'Arthl ...', 'Gt R ...'],
    DateTime(2025, 6, 29): ['Behr ...', 'Cros ...', 'Cros ...', 'Cros ...'],
  };

  // Helper function to navigate to the previous month
  void _goToPreviousMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1, 1);
    });
  }

  // Helper function to navigate to the next month
  void _goToNextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 1);
    });
  }

  // Function to build a single day cell in the calendar grid
  Widget _buildDayCell(DateTime date, {bool isCurrentMonth = true}) {
    // Determine if the cell should have a special background color (like red/green in the image)
    Color? backgroundColor;
    final bool hasData = _dailyData.containsKey(date);
    final bool isSpecialDay =
        date.day == 7 ||
        date.day == 19 ||
        date.day == 24; // Example days from image

    if (isSpecialDay) {
      backgroundColor = Colors.red.shade100; // Light red for highlighted days
    } else if (hasData && isCurrentMonth) {
      backgroundColor = Colors.green.shade100; // Light green for days with data
    }

    return Container(
      margin: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        color:
            backgroundColor ??
            Colors.white, // Default to white if no special color
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Day number
          Padding(
            padding: const EdgeInsets.only(top: 4.0, right: 4.0),
            child: Align(
              alignment: Alignment.topRight,
              child: Text(
                date.day.toString(),
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: isCurrentMonth
                      ? Colors.black87
                      : Colors.grey.shade500, // Dim non-current month days
                ),
              ),
            ),
          ),
          // List of data for the day
          if (hasData)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: _dailyData[date]!
                      .map(
                        (item) => Container(
                          margin: const EdgeInsets.only(bottom: 2.0),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 2.0,
                            vertical: 2.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors
                                .yellow
                                .shade100, // Light blue background for text items
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Text(
                            item,
                            style: TextStyle(
                              fontSize: 9.0,
                              color: Colors.black,
                            ),
                            overflow:
                                TextOverflow.clip, // Truncate long text
                            maxLines: 1,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get the first day of the focused month
    final DateTime firstDayOfMonth = DateTime(
      _focusedMonth.year,
      _focusedMonth.month,
      1,
    );
    // Get the last day of the focused month
    final DateTime lastDayOfMonth = DateTime(
      _focusedMonth.year,
      _focusedMonth.month + 1,
      0,
    );
    // Determine the weekday of the first day (Sunday=7, Monday=1, ..., Saturday=6)
    final int firstWeekday = firstDayOfMonth.weekday == 7
        ? 0
        : firstDayOfMonth.weekday; // Adjust so Sunday is 0

    // Create a list of all days to display in the grid (including prev/next month's overflow)
    List<DateTime> daysInGrid = [];

    // Add days from the previous month to fill the first week
    for (int i = firstWeekday; i > 0; i--) {
      daysInGrid.add(firstDayOfMonth.subtract(Duration(days: i)));
    }

    // Add all days of the current month
    for (int i = 1; i <= lastDayOfMonth.day; i++) {
      daysInGrid.add(DateTime(_focusedMonth.year, _focusedMonth.month, i));
    }

    // Add days from the next month to fill the last week
    while (daysInGrid.length % 7 != 0) {
      daysInGrid.add(daysInGrid.last.add(const Duration(days: 1)));
    }

    // Days of the week header
    final List<String> weekdays = [
      'SUN',
      'MON',
      'TUE',
      'WED',
      'THU',
      'FRI',
      'SAT',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            monthNavView(),
            SizedBox(height: 8.0),
            // Weekday headers
            weekDayNameView(weekdays),
    
            // Calendar Grid
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7, // 7 days in a week
                  childAspectRatio:
                      0.4, // Adjust to control cell height vs width
                  crossAxisSpacing: 2.0,
                  mainAxisSpacing: 4.0,
                ),
                itemCount: daysInGrid.length,
                itemBuilder: (context, index) {
                  final date = daysInGrid[index];
                  final bool isCurrentMonth =
                      date.month == _focusedMonth.month;
                                          // return Container(color: Colors.amber,);
                  return _buildDayCell(date, isCurrentMonth: isCurrentMonth);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Table weekDayNameView(List<String> weekdays) {
    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      children: [
        TableRow(
          children: weekdays
              .map(
                (day) => TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        day,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Padding monthNavView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: _goToPreviousMonth,
          ),
          Text(
            DateFormat('MMMM yyyy').format(_focusedMonth),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: _goToNextMonth,
          ),
        ],
      ),
    );
  }
}
