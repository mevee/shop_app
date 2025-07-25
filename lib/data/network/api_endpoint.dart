abstract class EndPoints {
  EndPoints._();
//{{url}}/crm/auth/v1/perform-login

  static const onBoarding = 'crm/auth/v1/master/config';
  static const onBoardingConfig = 'crm/auth/v1/user/{userId}/onboarding-config';
  static const login = 'crm/auth/v1/perform-login';
  static const forgotPasswordAndSendOtp = 'crm/auth/v1/forget-password-otp';
  static const verifyOtpAndPassword = 'crm/auth/v1/forget-password';

  //employee
  static const userLogoutPOST = '/crm/auth/v1/perform-logout';
  static const employeeClockInPOST = 'crm/auth/v1/employee-attendance';
  static const employeeClockOutPOST = 'crm/auth/v1/employee-attendance-logout';
  static const employeeRouteUpdatePOST = 'crm/employee/v1/employee-location';
  //get-employee-today-total-distance?userName=admin@hamster.com&date=2025-07-12
  static const employeeDistanceGET = 'crm/auth/v1/get-employee-today-total-distance?userName={userName}&date={date}';
  //{{url}}/crm/auth/v1/get-employee-attendance?userName=admin@hamster.com
  static const employeeAttendanceGET = 'crm/auth/v1/get-employee-attendance?userName={userName}';

  //Products
  static const productListGET = 'crm/shop/v1/product-details';

  //schedule
  static const employeeSchuleQtyGET = 'crm/employee/v1/get-employee-schedule-quantity-details?scheduleId={scheduleId}';
  static const employeeSchuleImagesGET = 'crm/employee/v1/get-employee-schedule-images-details?scheduleId={scheduleId}';
  static const employeeSchuleDetailsGET = 'crm/employee/v1/get-employee-schedule-details?scheduleId={scheduleId}';
  static const employeeSchuleByDateGET = 'crm/employee/v1/get-employee-schedule-day?date={date}';
  static const employeeSchuleByMonthGET = 'crm/employee/v1/get-employee-schedule-monthly?date={date}';
  
  static const addEmployeeSchedulePOST = 'crm/employee/v1/add-employee-schedule';
  static const updateEmployeeSchedulePOST = 'crm/employee/v1/update-employee-schedule';
  static const addEmployeeScheduleDetailPOST = 'crm/employee/v1/add-employee-schedule-details';
     
  //Shop master
  // {{url}}/crm/shop/v1/get-shop-list-by-name?shopName=
  static const shopListGET = 'crm/shop/v1/get-shop-list';
  //  get-shop-list-by-name?shopName=star&pageNumber=0&pageSize=10
  static const shopListSearchGET = 'crm/shop/v1/get-shop-list-by-name?shopName={shopName}&pageNumber={pageNumber}&pageSize={pageSize}';
  static const addSShopPOST = '/crm/shop/v1/add-shop';


  }
