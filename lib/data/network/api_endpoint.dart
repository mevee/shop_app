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
  static const employeeDistanceGET =
      'crm/employee/v1/get-employee-today-total-distance?userName={userName}&date={date}';
  static const employeeAttendanceGET =
      'crm/auth/v1/get-employee-attendance?userName={userName}';

  //Products
  static const productListGET = 'crm/shop/v1/product-details';
  static const productListByScheduleGET =
      'crm/employee/v1/get-existing-quantity?scheduleId={scheduleId}';

  //schedule
  static const employeeSchuleQtyGET =
      'crm/employee/v1/get-employee-schedule-quantity-details?scheduleId={scheduleId}';
  static const employeeSchuleImagesGET =
      'crm/employee/v1/get-employee-schedule-images-details?scheduleId={scheduleId}';
  static const employeeSchuleDetailsGET =
      'crm/employee/v1/get-employee-schedule-details?scheduleId={scheduleId}';
  static const employeeSchuleByDateGET =
      'crm/employee/v1/get-employee-schedule-day?date={date}';
  static const employeeSchuleByMonthGET =
      'crm/employee/v1/get-employee-schedule-monthly?date={date}';
  static const checkEmployeeAtShopLocationGET =
      'crm/employee/v1/get-current-distance?scheduleId={sheduleId}}&lat={lat}&lng={long}';

  //Manage scheudle
  static const agentListGET = 'crm/auth/v1/get-all-user-details-by-manager';
  static const allScheduleByAgentGET =
      'crm/employee/v1/get-other-employee-schedule-day?userName={userName}&date={date}';
  static const authorizeSchedulePOST =
      'crm/employee/v1/authorized-employee-schedule';
  static const shopUpdateLatLongPOST = 'crm/shop/v1/update-lat-lng';
  static const shopWholeSaleUpdateLatLongPOST =
      'crm/whole-seller/v1/update-lat-lng';
      ////get-agent-last-address?employeeId=admin%40hamster.com&dateTime=2025-08-04T15%3A30%3A00
  static const getAgentAddressGET = 'crm/employee/v1/get-agent-last-address?employeeId={agentId}&dateTime={dateTime}';

  //---------------{{url}}/http://localhost:81/crm/shop/v1/add-shop-document
  static const addShopPOST = 'crm/shop/v1/add-shop-document';
  static const getShopImagesGET = 'crm/shop/v1/get-shop-document?shopMasterId={shopId}&shopType={shopType}';

  //---------------
  static const addEmployeeSchedulePOST =
      'crm/employee/v1/add-employee-schedule';
  static const updateEmployeeSchedulePOST =
      'crm/employee/v1/update-employee-schedule';
  static const addEmployeeScheduleDetailPOST =
      'crm/employee/v1/add-employee-schedule-details';
  static const cancelScheduleDetailPOST =
      'crm/employee/v1/cancel-employee-schedule-details';

  //Shop master
  // {{url}}/crm/shop/v1/get-shop-list-by-name?shopName=
  static const shopListGET = 'crm/shop/v1/get-shop-list';
  //  get-shop-list-by-name?shopName=star&pageNumber=0&pageSize=10
  static const shopListSearchGET =
      'crm/shop/v1/get-shop-list-by-name?shopName={shopName}&districtName={districtName}&pageNumber={pageNumber}&pageSize={pageSize}';
  static const shopWholeSaleListSearchGET =
      'crm/whole-seller/v1/get-whole-seller-list-by-name?wholeSellerName={shopName}&districtName={districtName}&pageNumber={pageNumber}&pageSize={pageSize}';
  static const addSShopPOST = '/crm/shop/v1/add-shop';
}
