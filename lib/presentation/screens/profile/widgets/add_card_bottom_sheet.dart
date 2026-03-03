import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../providers/core_providers.dart';
import '../../../../core/errors/exceptions.dart';

class AddCardBottomSheet extends ConsumerStatefulWidget {
  const AddCardBottomSheet({super.key});

  @override
  ConsumerState<AddCardBottomSheet> createState() => _AddCardBottomSheetState();
}

class _AddCardBottomSheetState extends ConsumerState<AddCardBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  Future<void> _saveCard() async {
    FocusScope.of(context).unfocus(); // Hide keyboard to show snackbar
    if (!_formKey.currentState!.validate()) return;
    
    // Parse expiry
    final expiryParts = _expiryController.text.split('/');
    if (expiryParts.length != 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid expiry date format (MM/YY)')),
      );
      return;
    }

    final month = expiryParts[0].trim();
    final year = expiryParts[1].trim();
    // Assuming year is 2 digits, Payway might expect 2 or 4. 
    // Postman example: "expiryDateYear": "29" -> 2 digits.
    
    setState(() {
      _isLoading = true;
      _errorMessage = null; // Clear previous error
    });

    try {
      final apiClient = ref.read(apiClientProvider);

      // 1. Tokenize
      final tokenResponse = await apiClient.tokenizeCard({
        'paymentMethod': 'creditCard',
        'cvn': _cvvController.text,
        'cardholderName': _nameController.text,
        'cardNumber': _numberController.text.replaceAll(' ', ''),
        'expiryDateMonth': month,
        'expiryDateYear': year,
      });
      print("tokenResponse: ${tokenResponse.data}");
      if (!tokenResponse.success || tokenResponse.data == null) {
        String errorMessage = tokenResponse.message ?? 'Tokenization failed';
        if (tokenResponse.errors != null && tokenResponse.errors!.isNotEmpty) {
           errorMessage = tokenResponse.errors!.first.msg ?? errorMessage;
        }
        throw Exception(errorMessage);
      }

      final singleUseTokenId = tokenResponse.data!.singleUseTokenId;

      // 2. Save Card
      final saveResponse = await apiClient.saveCard(singleUseTokenId);

      if (!saveResponse.success) {
         String errorMessage = saveResponse.message ?? 'Failed to save card';
         if (saveResponse.errors != null && saveResponse.errors!.isNotEmpty) {
            errorMessage = saveResponse.errors!.first.msg ?? errorMessage;
         }
         throw Exception(errorMessage);
      }

      if (mounted) {
        // Show success snackbar using regular ScaffoldMessenger (works after pop)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Card saved successfully')),
        );
        Navigator.pop(context); // Close sheet
      }

    } on ValidationException catch (e) {
      if (mounted) {
        setState(() {
           _errorMessage = e.errors?.isNotEmpty == true ? e.errors!.first : e.message;
        });
      }
    } on DioException catch (e) {
      if (mounted) {
        String message = e.message ?? 'An error occurred';
        if (e.response != null && e.response?.data != null) {
          final data = e.response!.data;
          if (data is Map<String, dynamic>) {
            if (data['errors'] != null && data['errors'] is List && (data['errors'] as List).isNotEmpty) {
               final firstError = (data['errors'] as List).first;
               if (firstError is Map && firstError['msg'] != null) {
                 message = firstError['msg'];
               }
            } else if (data['message'] != null) {
              message = data['message'];
            }
          }
        }
        setState(() {
          _errorMessage = message;
        });
      }
    } catch (e) {
      if (mounted) {
        final message = e.toString().replaceFirst('Exception: ', '');
        setState(() {
          _errorMessage = message;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.addCard,
                  style: AppTextStyles.h3.copyWith(fontSize: 18),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: AppColors.textPrimary),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildLabel(AppStrings.cardName),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _nameController,
              hintText: 'John Doe',
              validator: (val) => val == null || val.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            _buildLabel(AppStrings.cardNumber),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _numberController,
              hintText: '0000 0000 0000 0000',
              keyboardType: TextInputType.number,
              validator: (val) => val == null || val.length < 13 ? 'Invalid card number' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel(AppStrings.expiryDate),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _expiryController,
                        hintText: AppStrings.mmYy,
                        keyboardType: TextInputType.datetime,
                        validator: (val) {
                          if (val == null || !val.contains('/')) return 'MM/YY';
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel(AppStrings.cvv),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _cvvController,
                        hintText: '123',
                        keyboardType: TextInputType.number,
                        validator: (val) => val == null || val.length < 3 ? 'Invalid CVV' : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            if (_errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                   children: [
                     const Icon(Icons.error_outline, color: Colors.red, size: 20),
                     const SizedBox(width: 8),
                     Expanded(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 13))),
                   ]
                )
              ),
              const SizedBox(height: 16),
            ],
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveCard,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA0503D), // Deep rich brown/red
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: _isLoading 
                  ? const SizedBox(
                      width: 24, 
                      height: 24, 
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.saveCard,
                          style: AppTextStyles.button.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, size: 20, color: Colors.white),
                      ],
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), // Slightly rounded corners
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primaryColor),
        ),
        filled: true,
        fillColor: const Color(0xFFFAFAFA), // Very light grey fill
      ),
      validator: validator,
    );
  }
}
