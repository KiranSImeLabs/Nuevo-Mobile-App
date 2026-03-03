import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../providers/user_provider.dart';
import '../../widgets/profile_image_picker_sheet.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_icons.dart';

class AccountSettingsScreen extends ConsumerStatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  ConsumerState<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends ConsumerState<AccountSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _dobController;
  DateTime? _selectedDate;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _dobController = TextEditingController();
    
    // Initialize with user data if available
    // In a real app, we'd listen to the provider. For now, we'll set defaults or wait for the provider build.
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    super.dispose();
  }
  
  bool _isInitialized = false;

  void _handleImageSelection(File image) {
    setState(() {
      _selectedImage = image;
    });
    // TODO: Implement actual upload logic here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image selected for upload')),
    );
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ProfileImagePickerSheet(
        onImageSelected: _handleImageSelection,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);

    // Initialize controllers once with user data
    if (!_isInitialized && userState.hasValue && userState.value != null) {
      final user = userState.value!;
      _nameController.text = user.name;
      _emailController.text = user.email;
      // If user had DOB, set it here. For now, empty or mock.
      _isInitialized = true;
    } else if (!_isInitialized) {
       // Fallback defaults if user provider is empty or loading for dev
       _nameController.text = "Warren I. Ford";
       _emailController.text = "sarah.johnson@email.com";
       _isInitialized = true;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Account Settings',
          style: AppTextStyles.h3.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                
                // Avatar
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey,
                          image: DecorationImage(
                            image: _selectedImage != null
                                ? FileImage(_selectedImage!) as ImageProvider
                                : const AssetImage('assets/images/details_image.png'), // Placeholder
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _showImagePicker,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: const Color(0xFF8D6E63), // Brown
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                            ),
                            child: SvgPicture.asset(
                              AppIcons.icProfileEdit,
                              width: 18,
                              height: 18,
                              // colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Full Name
                _buildLabel('Full Name'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _nameController,
                  hint: 'Full Name',
                  icon: Icons.person_outline,
                ),
                
                const SizedBox(height: 24),
                
                // Email Address
                _buildLabel('Email Address'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _emailController,
                  hint: 'Email Address',
                  icon: Icons.mail_outline,
                  keyboardType: TextInputType.emailAddress,
                  readOnly: true, // Email is unchangeable
                ),
                
                const SizedBox(height: 24),
                
                // Date of Birth
                _buildLabel('Date Of Birth'),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: _buildTextField(
                      controller: _dobController,
                      hint: 'dd/mm/yy',
                      icon: null, 
                      suffixIcon: Icons.calendar_today_outlined,
                    ),
                  ),
                ),
                
                const SizedBox(height: 48),
                
                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: userState.isLoading ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF964A38), // Rust/Brown
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFF964A38).withOpacity(0.6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: userState.isLoading
                          ? [
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            ]
                          : [
                              const Text(
                                'Save',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward, size: 20),
                            ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    IconData? icon,
    IconData? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: readOnly ? Colors.grey[100] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFBECE9)), // Light Pink Border
      ),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: keyboardType,
        style: AppTextStyles.bodyMedium.copyWith(
          color: readOnly ? Colors.grey[600] : AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.bodyMedium.copyWith(color: Colors.grey[400]),
          prefixIcon: icon != null 
              ? Icon(icon, color: Colors.grey[400], size: 22) 
              : null,
          suffixIcon: suffixIcon != null 
              ? Icon(suffixIcon, color: Colors.grey[500], size: 22) 
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          // If no prefix icon, add padding left
          prefix: icon == null ? const SizedBox(width: 16) : null, 
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF964A38), // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black, // Body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF964A38), // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      // Logic to save profile
      final name = _nameController.text.trim();
      // Use YYYY-MM-DD format if date is selected, else use empty string
      final dob = _selectedDate != null 
          ? DateFormat('yyyy-MM-dd').format(_selectedDate!) 
          : _dobController.text.trim();

      await ref.read(userProvider.notifier).updateProfile(
        name: name,
        dateOfBirth: dob,
        profileImageUrl: "https://fastly.picsum.photos/id/1/5000/3333.jpg?hmac=Asv2DU3rA_5D1xSe22xZK47WEAN0wjWeFOhzd13ujW4", // Currently send the profile image as "".
      );

      if (mounted) {
        final userState = ref.read(userProvider);
        if (userState.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(userState.error.toString())),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile saved successfully!')),
          );
          Navigator.of(context).pop();
        }
      }
    }
  }
}
