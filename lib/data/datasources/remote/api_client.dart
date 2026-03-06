import '../../../core/network/dio_client.dart';
import '../../../core/constants/app_constants.dart';
import '../../models/api_response.dart';
import '../../models/auth_response_model.dart';
import '../../models/user_model.dart';
import '../../models/subscription_model.dart';
import '../../models/program_model.dart';
import '../../models/booking_model.dart';
import '../../models/lab_request_model.dart';
import '../../models/diet_plan_model.dart';
import '../../models/preferences_model.dart';
import '../../models/daily_exercise_model.dart';
import '../../models/weekly_schedule_model.dart';
import '../../models/session_progress_model.dart';
import '../../models/active_progress_model.dart';
import '../../models/specialist_model.dart';
import '../../models/payment_integration_models.dart';
import '../../models/billing_response_model.dart';
import '../../models/goal_model.dart';
import '../../models/phase_model.dart';

import 'dart:convert';
import 'package:dio/dio.dart';

/// API Client (Data Layer)
/// Handles all API calls using Dio directly (Manual Implementation of RestClient interface)
class ApiClient {
  final DioClient _dioClient;
  
  ApiClient({required DioClient dioClient}) : _dioClient = dioClient;
  
  // ============================================
  // Authentication Endpoints
  // ============================================
  
  /// Login with email and password
  Future<ApiResponse<AuthResponseData>> login(LoginRequest request) async {
    final response = await _dioClient.post(
      ApiConstants.login,
      data: request.toJson(),
    );
    
    return ApiResponse.fromJson(
      response.data, 
      (json) => AuthResponseData.fromJson(json as Map<String, dynamic>),
    );
  }
  
  /// Sign up new user
  Future<ApiResponse<AuthResponseData>> register(RegisterRequest request) async {
    final response = await _dioClient.post(
      ApiConstants.register,
      data: request.toJson(),
    );
    return ApiResponse.fromJson(
      response.data,
      (json) => AuthResponseData.fromJson(json as Map<String, dynamic>),
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

  /// Update user preferences (Notification & Consent)
  Future<ApiResponse<PreferencesModel>> updatePreferences(
      PreferencesModel preferences) async {
    final response = await _dioClient.put(
      ApiConstants.preferences,
      data: preferences.toJson(),
    );
    return ApiResponse.fromJson(
      response.data,
      (json) => PreferencesModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Get user preferences
  Future<ApiResponse<PreferencesModel>> getPreferences() async {
    final response = await _dioClient.get(ApiConstants.preferences);
    return ApiResponse.fromJson(
      response.data,
      (json) => PreferencesModel.fromJson(json as Map<String, dynamic>),
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
  
  // ============================================
  // Lab Requests Endpoints
  // ============================================

  /// Create Lab Request
  Future<ApiResponse<LabRequestData>> createLabRequest(
      CreateLabRequest request) async {
    final response = await _dioClient.post(
      ApiConstants.labRequests,
      data: request.toJson(),
    );
    return ApiResponse.fromJson(
      response.data,
      (json) => LabRequestData.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Get Lab Requests List
  Future<ApiResponse<LabRequestListResponseData>> getLabRequests() async {
    final response = await _dioClient.get(ApiConstants.labRequests);
    return ApiResponse.fromJson(
      response.data,
      (json) =>
          LabRequestListResponseData.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Get Lab Request By ID
  Future<ApiResponse<LabRequestData>> getLabRequestById(String id) async {
    final response = await _dioClient.get('${ApiConstants.labRequests}/$id');
    return ApiResponse.fromJson(
      response.data,
      (json) => LabRequestData.fromJson(json as Map<String, dynamic>),
    );
  }

  // Add other methods (Programs, Bookings) as needed if they were in the previous attempt
  // For brevity and to fix the immediate error, ensuring register/login/updateProfile exist.
  
  // ============================================
  // Goal Endpoints
  // ============================================

  /// Get All Goals
  Future<ApiResponse<List<GoalModel>>> getGoals() async {
    final response = await _dioClient.get(ApiConstants.goals);
    return ApiResponse.fromJson(
      response.data,
      (json) => (json as List<dynamic>)
          .map((item) => GoalModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Create Goal
  Future<ApiResponse<GoalModel>> createGoal(Map<String, dynamic> data) async {
    final response = await _dioClient.post(
      ApiConstants.goals,
      data: data,
    );
    return ApiResponse.fromJson(
      response.data,
      (json) => GoalModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Get Goal By ID
  Future<ApiResponse<GoalModel>> getGoalById(String id) async {
    final response = await _dioClient.get('${ApiConstants.goals}/$id');
    return ApiResponse.fromJson(
      response.data,
      (json) => GoalModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Update Goal
  Future<ApiResponse<GoalModel>> updateGoal(String id, Map<String, dynamic> data) async {
    final response = await _dioClient.put(
      '${ApiConstants.goals}/$id',
      data: data,
    );
    return ApiResponse.fromJson(
      response.data,
      (json) => GoalModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Delete Goal
  Future<ApiResponse<void>> deleteGoal(String id) async {
    final response = await _dioClient.delete('${ApiConstants.goals}/$id');
    return ApiResponse.fromJson(
      response.data,
      (json) => null,
    );
  }

  // ============================================
  // Phase Endpoints
  // ============================================

  /// Get All Phases
  Future<ApiResponse<List<PhaseModel>>> getPhases() async {
    final response = await _dioClient.get(ApiConstants.phases);
    return ApiResponse.fromJson(
      response.data,
      (json) => (json as List<dynamic>)
          .map((item) => PhaseModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  // ============================================
  // Diet Plan Endpoints
  // ============================================

  /// Get Diet Plan
  Future<ApiResponse<DietPlanModel>> getDietPlan() async {
    final response = await _dioClient.get(ApiConstants.dietPlans);
    

    
    return ApiResponse.fromJson(
      response.data,
      (json) => DietPlanModel.fromJson(json as Map<String, dynamic>),
    );
  }

  // ============================================
  // Guided Sessions Endpoints
  // ============================================

  /// Get Today's Exercise
  Future<ApiResponse<DailyExerciseModel>> getTodayExercise() async {
    final response = await _dioClient.get(ApiConstants.todayExercise);

    return ApiResponse.fromJson(
      response.data,
      (json) => DailyExerciseModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Get Weekly Schedule
  Future<ApiResponse<WeeklyScheduleModel>> getWeeklySchedule() async {
    final response = await _dioClient.get(ApiConstants.weeklySchedule);
    return ApiResponse.fromJson(
      response.data,
      (json) => WeeklyScheduleModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Get Session Details
  Future<ApiResponse<GuidedSessionModel>> getSessionDetails(String id) async {
    final response = await _dioClient.get('${ApiConstants.sessionDetails}/$id');
    return ApiResponse.fromJson(
      response.data,
      (json) => GuidedSessionModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Start Session
  Future<ApiResponse<SessionProgressModel>> startSession(String id) async {
    final response = await _dioClient.post('${ApiConstants.sessionDetails}/$id${ApiConstants.sessionStart}');
    return ApiResponse.fromJson(
      response.data,
      (json) => SessionProgressModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Complete Session
  Future<ApiResponse<SessionProgressModel>> completeSession(String id) async {
    final response = await _dioClient.post('${ApiConstants.sessionDetails}/$id${ApiConstants.sessionComplete}');
    return ApiResponse.fromJson(
      response.data,
      (json) => SessionProgressModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Sync Session Progress
  Future<ApiResponse<SessionProgressModel?>> syncSessionProgress(String id, Map<String, dynamic> data) async {
    // Note: The backend expects a PATCH request for updating progress
    final response = await _dioClient.dio.patch(
      '${ApiConstants.sessionDetails}/$id${ApiConstants.sessionProgressUpdate}',
      data: data,
    );
    return ApiResponse.fromJson(
      response.data,
      (json) => json == null ? null : SessionProgressModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Get Active Progress
  Future<ApiResponse<ActiveProgressModel?>> getActiveProgress() async {
    try {
      final response = await _dioClient.get(ApiConstants.sessionActiveProgress);
      return ApiResponse.fromJson(
        response.data,
        (json) => ActiveProgressModel.fromJson(json as Map<String, dynamic>),
      );
    } catch (e) {
      if (e is DioException) {
         if (e.response?.statusCode == 404) {
            // Assume 404 means no active session, return a successful response with null data
            return ApiResponse(success: true, message: 'No active session', data: null);
         }
      }
      rethrow;
    }
  }

  // ============================================
  // Specialist Endpoints
  // ============================================

  /// Get My Specialists
  Future<ApiResponse<List<SpecialistModel>>> getMySpecialists() async {
    final response = await _dioClient.get(ApiConstants.mySpecialists);
    return ApiResponse.fromJson(
      response.data,
      (json) => (json as List<dynamic>)
          .map((item) => SpecialistModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Get Specialist Details
  Future<ApiResponse<SpecialistModel>> getSpecialistDetails(String id) async {
    final response = await _dioClient.get('${ApiConstants.specialistDetails}/$id');
    return ApiResponse.fromJson(
      response.data,
      (json) => SpecialistModel.fromJson(json as Map<String, dynamic>),
    );
  }

  // ============================================
  // Payment & Subscription Endpoints
  // ============================================

  /// Get Payway Subscription Details
  Future<ApiResponse<SubscriptionPaywayDetails>> getSubscriptionPaywayDetails() async {
    final response = await _dioClient.get(ApiConstants.subscriptionPaywayDetails);
    return ApiResponse.fromJson(
      response.data,
      (json) => SubscriptionPaywayDetails.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Get Saved Cards (Payment Customer)
  Future<ApiResponse<PaymentCustomerDetails>> getSavedCards() async {
    final response = await _dioClient.get(ApiConstants.paymentCustomer);
    return ApiResponse.fromJson(
      response.data,
      (json) => PaymentCustomerDetails.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Tokenize Card
  Future<ApiResponse<SingleUseTokenResponse>> tokenizeCard(
      Map<String, dynamic> cardDetails) async {
    // API Expects URL-encoded form data
    final response = await _dioClient.post(
      ApiConstants.paymentToken,
      data: cardDetails,
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    return ApiResponse.fromJson(
      response.data,
      (json) => SingleUseTokenResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Save Card
  Future<ApiResponse<SaveCardResponse>> saveCard(
      String singleUseTokenId) async {
    final response = await _dioClient.post(
      ApiConstants.paymentSaveCard,
      data: {'singleUseTokenId': singleUseTokenId},
    );
    return ApiResponse.fromJson(
      response.data,
      (json) => SaveCardResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Get Billing Details (Subscription, Cards, History)
  Future<ApiResponse<BillingResponseData>> getBillingDetails() async {
    final response = await _dioClient.get(ApiConstants.billingDetails);
    return ApiResponse.fromJson(
      response.data,
      (json) => BillingResponseData.fromJson(json as Map<String, dynamic>),
    );
  }
}