import '../../../core/network/dio_client.dart';
import '../../../core/constants/app_constants.dart';
import '../../models/auth_response_model.dart';
import '../../models/user_model.dart';
import '../../models/subscription_model.dart';

/// API Client (Data Layer)
/// Handles all API calls using Dio
/// CRITICAL: No payment-related endpoints (Apple compliance)
class ApiClient {
  final DioClient _dioClient;
  
  ApiClient({required DioClient dioClient}) : _dioClient = dioClient;
  
  // ============================================
  // Authentication Endpoints
  // ============================================
  
  /// Login with email and password
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    final response = await _dioClient.post(
      ApiConstants.login,
      data: request.toJson(),
    );
    return LoginResponseModel.fromJson(response.data);
  }
  
  /// Sign up new user
  Future<LoginResponseModel> signup(SignupRequestModel request) async {
    final response = await _dioClient.post(
      ApiConstants.signup,
      data: request.toJson(),
    );
    return LoginResponseModel.fromJson(response.data);
  }
  
  /// Logout current user
  Future<void> logout() async {
    await _dioClient.post(ApiConstants.logout);
  }
  
  /// Refresh access token
  Future<TokenRefreshResponseModel> refreshToken(
    Map<String, String> refreshToken,
  ) async {
    final response = await _dioClient.post(
      ApiConstants.refreshToken,
      data: refreshToken,
    );
    return TokenRefreshResponseModel.fromJson(response.data);
  }
  
  // ============================================
  // User Endpoints
  // ============================================
  
  /// Get current user profile
  Future<UserModel> getUserProfile() async {
    final response = await _dioClient.get(ApiConstants.userProfile);
    return UserModel.fromJson(response.data);
  }
  
  /// Update user profile
  Future<UserModel> updateProfile(Map<String, dynamic> profileData) async {
    final response = await _dioClient.put(
      ApiConstants.updateProfile,
      data: profileData,
    );
    return UserModel.fromJson(response.data);
  }
  
  // ============================================
  // Subscription Endpoints (READ-ONLY)
  // CRITICAL: No payment processing endpoints
  // ============================================
  
  /// Get current subscription status
  Future<SubscriptionModel> getSubscriptionStatus() async {
    final response = await _dioClient.get(ApiConstants.subscriptionStatus);
    return SubscriptionModel.fromJson(response.data);
  }
  
  /// Get detailed subscription information
  Future<SubscriptionModel> getSubscriptionDetails() async {
    final response = await _dioClient.get(ApiConstants.subscriptionDetails);
    return SubscriptionModel.fromJson(response.data);
  }
  
  // ============================================
  // Video Consultation Endpoints
  // ============================================
  
  /// Get list of appointments
  Future<List<Map<String, dynamic>>> getAppointments({
    String? status,
    int? page,
    int? limit,
  }) async {
    final response = await _dioClient.get(
      ApiConstants.appointments,
      queryParameters: {
        if (status != null) 'status': status,
        if (page != null) 'page': page,
        if (limit != null) 'limit': limit,
      },
    );
    return List<Map<String, dynamic>>.from(response.data);
  }
  
  /// Schedule new appointment
  Future<Map<String, dynamic>> scheduleAppointment(
    Map<String, dynamic> appointmentData,
  ) async {
    final response = await _dioClient.post(
      ApiConstants.scheduleAppointment,
      data: appointmentData,
    );
    return response.data;
  }
  
  /// Get Agora token for video call
  Future<Map<String, dynamic>> getAgoraToken(
    Map<String, dynamic> tokenRequest,
  ) async {
    final response = await _dioClient.post(
      ApiConstants.agoraToken,
      data: tokenRequest,
    );
    return response.data;
  }
  
  // ============================================
  // Health Data Endpoints
  // ============================================
  
  /// Get health metrics
  Future<Map<String, dynamic>> getHealthMetrics({
    String? startDate,
    String? endDate,
  }) async {
    final response = await _dioClient.get(
      ApiConstants.healthMetrics,
      queryParameters: {
        if (startDate != null) 'start_date': startDate,
        if (endDate != null) 'end_date': endDate,
      },
    );
    return response.data;
  }
  
  /// Get lab results
  Future<List<Map<String, dynamic>>> getLabResults({
    int? page,
    int? limit,
  }) async {
    final response = await _dioClient.get(
      ApiConstants.labResults,
      queryParameters: {
        if (page != null) 'page': page,
        if (limit != null) 'limit': limit,
      },
    );
    return List<Map<String, dynamic>>.from(response.data);
  }
  
  /// Get wellness data (Exercise & Diet)
  Future<Map<String, dynamic>> getWellnessData() async {
    final response = await _dioClient.get(ApiConstants.wellnessData);
    return response.data;
  }
  
  /// Submit wellness activity
  Future<void> submitWellnessActivity(
    Map<String, dynamic> activityData,
  ) async {
    await _dioClient.post(
      ApiConstants.wellnessData,
      data: activityData,
    );
  }
  
  // ============================================
  // Support Endpoints
  // ============================================
  
  /// Contact support
  Future<void> contactSupport(Map<String, dynamic> supportRequest) async {
    await _dioClient.post(
      ApiConstants.contactSupport,
      data: supportRequest,
    );
  }
}
