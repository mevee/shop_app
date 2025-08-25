import 'package:shop_app/data/meeting_model.dart';
import 'package:shop_app/models/login_response.dart';

enum UserManagerKeys {
  userClockedIn("USER_CLOCKED_IN"),
  userLoggedIn("USER_LOGGED_IN"),
  userAccessToken("USER_TOKEN"),
  userId("USER_ID"),
  working("WORKING"),
  meetingsData("MEETING_DATA"),
  userCredRememeber("USER_CRED_REMEMBER"),
  userCred("USER_CRED"),
  testData("TEST_DATA"),
  userData("USER_DATA");

  final String value;
  const UserManagerKeys(this.value);
}

mixin SessionPref {
  Future<void> initPreferences();
  dynamic isClockedIn();
  void setClockedIn(bool? value);

  void saveUserCred(LoginRequest? data);
  LoginRequest? getSavedCred();

  void setUserData(LoginResponse? data);
  LoginResponse? getUserData();
  dynamic isUserLoggedIn();
  void setIsUserLoggedIn(bool? value);

  String? getUserToken();
  void setUserToken(String? token);
  String? getUserId();
  void setUserId(String? value);
  String? getTestData();
  void setTestData(String? value);

  bool? getIsWorking();
  void setIsWorking(bool? value);

  bool? isRememberOn();
  void setRememberOn(bool? value);

  Future<void> saveMeetingSession(String meetingId, MeetingData data);
  MeetingData? getMeetingSession(String meetingId);
  Future<void> removeMeetingSession(String meetingId);
  Map<String, MeetingData>? getAllMeetingSessions();
  Future<void> clearAllMeetingSessions();
  bool isMeetingCompletedMinDuration(String meetingId, int minDurationMinutes);

  void logOut();
}
