import 'package:get_storage/get_storage.dart';

enum ApplicationStates {
  loginDone(0),
  homeScreen(1);

  final int value;

  const ApplicationStates(this.value);
}

class ApplicationState {
  final _applicationStateUserDefaultkey = "ApplicationStateUserDefaultkey";

  dynamic get getCurrentState =>
      GetStorage().read(_applicationStateUserDefaultkey);

  void _setCurrentState(ApplicationStates? state) =>
      GetStorage().write(_applicationStateUserDefaultkey, state?.value);

  void userLoggedIn() {
    _setCurrentState(ApplicationStates.loginDone);
  }

  void userLoggedOut() {
    _setCurrentState(null);
  }
}
