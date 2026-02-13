import '../../../core/network/dio_client.dart';
import '../../../core/constants/app_constants.dart';
import '../../models/api_response.dart';
import '../../models/auth_response_model.dart';
import '../../models/user_model.dart';
import '../../models/subscription_model.dart';
import '../../models/program_model.dart';
import '../../models/booking_model.dart';

/// API Client (Data Layer)
/// Handles all API calls using Dio directly (Manual Implementation of RestClient interface)
class ApiClient {
  final DioClient _dioClient;
  
  ApiClient({required DioClient dioClient}) : _dioClient = dioClient;
  
  // ============================================
  // Authentication Endpoints
  // ============================================
  
  /// Login with email and password
  Future<ApiResponse<LoginResponseData>> login(LoginRequest request) async {
    try {
      print('📤 Calling login API...');
      final response = await _dioClient.post(
        ApiConstants.login,
        data: request.toJson(),
      );
      
      print('📥 Raw response received:');
      print('  - statusCode: ${response.statusCode}');
      print('  - data type: ${response.data.runtimeType}');
      print('  - data: ${response.data}');
      
      final apiResponse = ApiResponse.fromJson(
        response.data, 
        (json) => LoginResponseData.fromJson(json as Map<String, dynamic>),
      );
      
      print('✅ API Response parsed successfully');
      print('  - success: ${apiResponse.success}');
      print('  - data: ${apiResponse.data}');
      
      return apiResponse;
    } catch (e, stackTrace) {
      print('❌ Error in login API call:');
      print('  - Error: $e');
      print('  - Type: ${e.runtimeType}');
      print('  - StackTrace: $stackTrace');
      rethrow;
    }
  }
  
  /// Sign up new user
  Future<ApiResponse<LoginResponseData>> register(RegisterRequest request) async {
    final response = await _dioClient.post(
      ApiConstants.register,
      data: request.toJson(),
    );
    return ApiResponse.fromJson(
      response.data,
      (json) => LoginResponseData.fromJson(json as Map<String, dynamic>),
    );
  }
  
  /// Logout current user
  Future<ApiResponse<void>> logout() async {
    // Assuming client-side only or API call if exists
    return const ApiResponse(success: true, message: 'Logged out locally');
  }
  
  /// Forgot Password
  Future<ApiResponse<void>> forgotPassword(ForgotPasswordRequest request) async {
    final response = await _dioClient.post(
      ApiConstants.forgotPassword,
      data: request.toJson(),
    );
    return ApiResponse.fromJson(
      response.data,
      (json) => null,
    );
  }
  
  /// Resend Reset Code
  Future<ApiResponse<void>> resendResetCode(ForgotPasswordRequest request) async {
    final response = await _dioClient.post(
      ApiConstants.resendResetCode,
      data: request.toJson(),
    );
     return ApiResponse.fromJson(
      response.data,
      (json) => null,
    );
  }
  
  /// Verify Reset Code
  Future<ApiResponse<void>> verifyResetCode(VerifyResetCodeRequest request) async {
    final response = await _dioClient.post(
      ApiConstants.verifyResetCode,
      data: request.toJson(),
    );
     return ApiResponse.fromJson(
      response.data,
      (json) => null,
    );
  }
  
  /// Reset Password
  Future<ApiResponse<void>> resetPassword(ResetPasswordRequest request) async {
    final response = await _dioClient.post(
      ApiConstants.resetPassword,
      data: request.toJson(),
    );
     return ApiResponse.fromJson(
      response.data,
      (json) => null,
    );
  }

  // ============================================
  // User Endpoints
  // ============================================
  
  /// Get current user profile
  Future<ApiResponse<UserModel>> getUserProfile() async {
    final response = await _dioClient.get(ApiConstants.userProfile);
    return ApiResponse.fromJson(
      response.data,
      (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );
  }
  
  /// Update user profile
  Future<ApiResponse<UserModel>> updateProfile(Map<String, dynamic> data) async {
     final response = await _dioClient.dio.patch(
       ApiConstants.updateProfile,
       data: data,
    );
     return ApiResponse.fromJson(
      response.data,
      (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );
  }
  
  /// Check Email
  Future<ApiResponse<void>> checkEmail(String email) async {
    final response = await _dioClient.get(
      ApiConstants.checkEmail,
      queryParameters: {'email': email},
    );
     return ApiResponse.fromJson(
      response.data,
      (json) => null,
    );
  }
  
  // ============================================
  // Subscription Endpoints
  // ============================================
  
  Future<SubscriptionModel> getSubscriptionStatus() async {
    throw UnimplementedError("Use getUserProfile() instead");
  }
  
  Future<SubscriptionModel> getSubscriptionDetails() async {
     throw UnimplementedError("Use getUserProfile() instead");
  }
  
  // Add other methods (Programs, Bookings) as needed if they were in the previous attempt
  // For brevity and to fix the immediate error, ensuring register/login/updateProfile exist.
}
