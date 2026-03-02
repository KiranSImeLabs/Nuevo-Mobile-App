import '../constants/app_constants.dart';

/// Input Validation Utilities
class Validators {
  /// Validate Email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    if (!ValidationConstants.emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }
  
  /// Validate Login Password (Simple check)
  static String? validateLoginPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  /// Validate Signup Password (Strict check)
  static String? validateSignupPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < ValidationConstants.minPasswordLength) {
      return 'Password must be at least ${ValidationConstants.minPasswordLength} characters';
    }
    
    if (value.length > ValidationConstants.maxPasswordLength) {
      return 'Password must not exceed ${ValidationConstants.maxPasswordLength} characters';
    }
    
    // Check for Uppercase
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    // Check for Number
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }

    // Check for Special Character
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }
    
    return null;
  }
  
  /// Validate Name
  static String? validateName(String? value, [String fieldName = 'Name']) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    
    if (value.length < ValidationConstants.minNameLength) {
      return '$fieldName must be at least ${ValidationConstants.minNameLength} characters';
    }
    
    if (value.length > ValidationConstants.maxNameLength) {
      return '$fieldName must not exceed ${ValidationConstants.maxNameLength} characters';
    }
    
    return null;
  }
  
  /// Validate Required Field
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
  
  /// Validate Phone Number (Basic)
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    
    // Remove all non-digit characters
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    
    if (digitsOnly.length < 10) {
      return 'Please enter a valid phone number';
    }
    
    return null;
  }
  
  /// Validate Confirm Password
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    
    if (value != password) {
      return 'Passwords do not match';
    }
    
    return null;
  }
}
