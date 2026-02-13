import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart' as apple;
import 'package:sign_in_button/sign_in_button.dart';
import '../../widgets/common/app_text_field.dart';
import '../../widgets/common/app_primary_button.dart';
import '../../widgets/common/or_divider.dart';
import '../../widgets/common/social_login_buttons.dart';
import '../../providers/auth_provider.dart';
import '../../providers/auth_state.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/validators.dart';
import '../../../core/constants/app_strings.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  // Visibility states
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _signup() {
    if (_formKey.currentState!.validate()) {
      if (!_agreedToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppStrings.agreeTermsError),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }
      
      ref.read(authProvider.notifier).signup(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            // Phone number is optional and currently handled inside signup method or removed from UI based on design
            phoneNumber: null, 
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.status == AuthStatus.error && next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!), backgroundColor: AppColors.error),
        );
      }
    });

    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  
                  // Header
                  Text(
                    AppStrings.createAccount, // AppStrings.createAccount
                    style: AppTextStyles.h2.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.startJourney,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // First Name
                  AppTextField(
                    controller: _firstNameController,
                    hintText: AppStrings.firstName,
                    prefixIcon: Icons.person_outline,
                    validator: Validators.validateName, // Using same validator for now, simpler
                    enabled: !authState.isLoading,
                  ),
                  const SizedBox(height: 16),

                  // Last Name
                  AppTextField(
                    controller: _lastNameController,
                    hintText: AppStrings.lastName,
                    prefixIcon: Icons.person_outline,
                    validator: Validators.validateName,
                    enabled: !authState.isLoading,
                  ),
                  const SizedBox(height: 16),

                  // Email
                  AppTextField(
                    controller: _emailController,
                    hintText: AppStrings.emailAddress,
                    prefixIcon: Icons.mail_outline,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.validateEmail,
                    enabled: !authState.isLoading,
                  ),
                  const SizedBox(height: 16),

                  // Password
                  AppTextField(
                    controller: _passwordController,
                    hintText: AppStrings.password,
                    obscureText: _obscurePassword,
                     suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    validator: Validators.validateSignupPassword,
                    enabled: !authState.isLoading,
                  ),
                  const SizedBox(height: 16),
                  
                  // Confirm Password
                  AppTextField(
                    controller: _confirmPasswordController,
                    hintText: AppStrings.confirmPassword,
                    obscureText: _obscureConfirmPassword,
                    suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                      ),
                    validator: (value) => Validators.validateConfirmPassword(value, _passwordController.text),
                    enabled: !authState.isLoading,
                  ),
                  
                  const SizedBox(height: 24),

                  // Terms Box
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: Checkbox(
                          value: _agreedToTerms,
                          onChanged: authState.isLoading ? null : (value) {
                            setState(() {
                              _agreedToTerms = value ?? false;
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          activeColor: AppColors.primaryButtonColor,//const Color(0xFF8B3A3A),
                          side: const BorderSide(color: Color(0xFFBDBDBD), width: 1.5),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontSize: 13,
                              color: AppColors.textPrimary, 
                              height: 1.4
                            ),
                            children: [
                              const TextSpan(text: AppStrings.agreeTo),
                              TextSpan(
                                text: AppStrings.termsOfService,
                                style: const TextStyle(
                                  color: AppColors.primaryButtonColor,//Color(0xFF8B3A3A),
                                  fontWeight: FontWeight.w500,
                                ),
                                recognizer: TapGestureRecognizer()..onTap = () {
                                  // TODO: Open Terms
                                },
                              ),
                              const TextSpan(text: AppStrings.and),
                              TextSpan(
                                text: AppStrings.privacyPolicy,
                                style: const TextStyle(
                                  color: AppColors.primaryButtonColor,//Color(0xFF8B3A3A),
                                  fontWeight: FontWeight.w500,
                                ),
                                recognizer: TapGestureRecognizer()..onTap = () {
                                  // TODO: Open Privacy Policy
                                },
                              ),
                              const TextSpan(text: '.'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Create Account Button
                  AppPrimaryButton(
                    onPressed: _signup,
                    text: AppStrings.createAccountBtn,
                    isLoading: authState.isLoading,
                  ),
                  
                  const SizedBox(height: 24),

                  // Divider
                  const OrDivider(),
                  
                  const SizedBox(height: 24),

                  // Social Logins
                  SocialLoginButtons(
                    onGooglePressed: () {
                      ref.read(authProvider.notifier).signInWithGoogle();
                    },
                    onApplePressed: () {
                      ref.read(authProvider.notifier).signInWithApple();
                    },
                    googleButtonText: "Sign up with Google",
                  ),

                  const SizedBox(height: 32),

                  // Login Footer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.alreadyHaveAccount,
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                      ),
                      GestureDetector(
                        onTap: () => context.pop(), // Go back to login
                        child: Text(
                          AppStrings.loginLink,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primaryButtonColor,//const Color(0xFF8B3A3A),
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.primaryButtonColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Duplicated from LoginScreen for speed, ideally should be in shared widgets
