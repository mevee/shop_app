// lib/models/meeting_data.dart
class MeetingData {
  final String sessionId;
  int timeRemainingSeconds; // Store as seconds for simplicity
  final int
  startTimeMillis; // New: Timestamp when the meeting actually started (milliseconds since epoch)
  MeetingData({
    required this.sessionId,
    required this.timeRemainingSeconds,
    required this.startTimeMillis, // Make it optional for flexibility, but expected for this feature
  });

  // Convert a MeetingData object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'timeRemainingSeconds': timeRemainingSeconds,
      'startTimeMillis': startTimeMillis, // Include in JSON
    };
  }

  // Create a MeetingData object from a JSON map
  factory MeetingData.fromJson(Map<String, dynamic> json) {
    return MeetingData(
      sessionId: json['sessionId'] as String,
      timeRemainingSeconds: json['timeRemainingSeconds'] as int,
      startTimeMillis: json['startTimeMillis'] as int,
    );
  }

  Map<String, dynamic> getMeetingStatusInSeconds() {
    int maxMillSeconds = 20 * 60 * 1000; //20 minute millis

    final int currentTimeMillis = DateTime.now().millisecondsSinceEpoch;
    final int elapsedMillis = currentTimeMillis - startTimeMillis;
    final bool isDurationCrossed = elapsedMillis >= maxMillSeconds;

    final int leftDuration = (elapsedMillis / 1000).toInt();
    // 2. Calculate remaining milliseconds from the original total duration
    int remainingMilliseconds = maxMillSeconds - elapsedMillis;
    // Ensure remainingMilliseconds doesn't go below zero
    if (remainingMilliseconds < 0) {
      remainingMilliseconds = 0;
    }

    // Convert remaining milliseconds to seconds
    final int remainingSeconds = (remainingMilliseconds / 1000).ceil();
    return {
      'is20MinCompleted': isDurationCrossed,
      'remainingSeconds': remainingSeconds,
    };
  }
}
