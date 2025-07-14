abstract class EndPoints {
  EndPoints._();
  static const onBoarding = 'api/v1/master/config';
  static const onBoardingConfig = 'api/v1/user/{userId}/onboarding-config';
  static const login = 'api/v1/user/login';
  static const verifyEmail = 'api/v1/user/verify-email';
  static const userRegistration = 'api/v1/user';
  static const getSubscription = 'api/v1/subscription';
  static const getAllChats = 'api/v1/user-chat';
  static const chatById = 'api/v1/user-chat/{chat_id}';
  static const forgotPassword = 'api/v1/user/forgot-password';
  static const newPassword = 'api/v1/user/reset-password';
  static const updateChats = 'api/v1/user-chat';
  static const archivePinnedChats = "api/v1/user-chat/{chat_id}";
  static const updatePersonalInfo = 'api/v1/user/{user_id}';
  static const getSharedChats = 'api/v1/share-chat';
  static const resentSignUp = 'api/v1/user/resend-email/{user_id}';
  static const shareChat = 'api/v1/share-chat';
  static const submitResponseFeedback =
      'api/v1/user-chat/{chat_id}/conversation/{conversation_id}/message/{message_id}/feedback';
}
