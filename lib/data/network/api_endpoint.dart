abstract class EndPoints {
  EndPoints._();
//{{url}}/crm/auth/v1/perform-login

  static const onBoarding = 'crm/auth/v1/master/config';
  static const onBoardingConfig = 'crm/auth/v1/user/{userId}/onboarding-config';
  static const login = 'crm/auth/v1/perform-login';
  static const forgotPasswordAndSendOtp = 'crm/auth/v1/forget-password-otp';
  static const verifyOtpAndPassword = 'crm/auth/v1/forget-password';

  //employee
  static const employeeClockInPOST = 'crm/auth/v1/employee-attendance';
  static const employeeClockOutPOST = 'crm/auth/v1/employee-attendance-logout';
  static const employeeRouteUpdatePOST = 'crm/auth/v1/employee-location';
  //get-employee-today-total-distance?userName=admin@hamster.com&date=2025-07-12
  static const employeeDistanceGET = 'crm/auth/v1/get-employee-today-total-distance?userName={userName}&date={date}';
  //{{url}}/crm/auth/v1/get-employee-attendance?userName=admin@hamster.com
  static const employeeAttendanceGET = 'crm/auth/v1/get-employee-attendance?userName={userName}';

  
  }
