import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart' as apple;

class SocialLoginButtons extends StatelessWidget {
  final VoidCallback onGooglePressed;
  final VoidCallback onApplePressed;
  final String googleButtonText;

  const SocialLoginButtons({
    super.key,
    required this.onGooglePressed,
    required this.onApplePressed,
    this.googleButtonText = "Sign in with Google",
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50,
          width: double.infinity,
          child: SignInButton(
            Buttons.google,
            text: googleButtonText,
            onPressed: onGooglePressed,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
        const SizedBox(height: 16),
        apple.SignInWithAppleButton(
          onPressed: onApplePressed,
          height: 50,
          style: apple.SignInWithAppleButtonStyle.black,
          borderRadius: BorderRadius.circular(24),
          iconAlignment: apple.IconAlignment.left,
        ),
      ],
    );
  }
}
