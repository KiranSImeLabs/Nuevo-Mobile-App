import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../providers/specialist_provider.dart';
import '../../../domain/entities/specialist.dart';
import '../my_plan/clinician_profile_screen.dart';

class DoctorListScreen extends ConsumerStatefulWidget {
  const DoctorListScreen({super.key});

  @override
  ConsumerState<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends ConsumerState<DoctorListScreen> {
  String _searchKeyword = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(specialistListProvider.notifier).fetchSpecialists();
    });
  }

  void _runFilter(String enteredKeyword) {
    setState(() {
      _searchKeyword = enteredKeyword;
    });
  }

  @override
  Widget build(BuildContext context) {
    final specialistState = ref.watch(specialistListProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Doctor List',
          style: AppTextStyles.h3.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 18,
            color: const Color(0xFF4A4543),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4A4543)),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF2E6E4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  onChanged: (value) => _runFilter(value),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFF2E6E4),
                    prefixIcon: Icon(Icons.search, color: Color(0xFF8D6E63), size: 24),
                    hintText: 'Search Here',
                    hintStyle: TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              Text(
                'Your Doctor List',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: const Color(0xFF1D1B20),
                ),
              ),
              const SizedBox(height: 16),
              
              // Specialist List
              Expanded(
                child: specialistState.when(
                  data: (specialists) {
                    final filteredSpecialists = specialists.where((specialist) {
                      final name = specialist.fullName.toLowerCase();
                      final role = specialist.role.toLowerCase();
                      final keyword = _searchKeyword.toLowerCase();
                      return name.contains(keyword) || role.contains(keyword);
                    }).toList();

                    if (filteredSpecialists.isEmpty) {
                      return const Center(
                        child: Text(
                          'No doctors found',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: filteredSpecialists.length,
                      itemBuilder: (context, index) {
                        final specialist = filteredSpecialists[index];
                        return GestureDetector(
                          onTap: () {
                            // Navigate to details screen with ID
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ClinicianProfileScreen(
                                  specialistId: specialist.id,
                                  name: specialist.fullName,
                                  role: specialist.role,
                                  imageUrl: specialist.profileImage,
                                  bio: specialist.biography,
                                ),
                              ),
                            );
                          },
                          child: _buildDoctorItem(
                            context,
                            name: specialist.fullName,
                            specialty: specialist.role,
                            imageUrl: specialist.profileImage,
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(
                    child: Text(
                      'Error: $error',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorItem(
    BuildContext context, {
    required String name,
    required String specialty,
    String? imageUrl,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF2E6E4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
              image: imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: imageUrl == null
                ? Icon(Icons.person, color: Colors.grey[600])
                : null,
          ),
          const SizedBox(width: 16),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: const Color(0xFF1D1B20),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  specialty,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: const Color(0xFF735B4D),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          
          const Icon(Icons.arrow_forward, color: Color(0xFF8D6E63), size: 18), 
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
