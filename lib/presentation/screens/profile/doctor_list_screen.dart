import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class DoctorListScreen extends StatefulWidget {
  const DoctorListScreen({super.key});

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  // Dummy Data
  final List<Map<String, String>> _allDoctors = [
    {
      'name': 'DR. Mike',
      'specialty': 'Dietitian',
      'image': 'assets/images/details_image.png',
    },
    {
      'name': 'Dr. A. Smith',
      'specialty': 'General Practitioner',
      'image': 'assets/images/details_image.png',
    },
    {
      'name': 'Dr. Sarah Connor',
      'specialty': 'Cardiologist',
      'image': 'assets/images/details_image.png',
    },
    {
      'name': 'Dr. John Doe',
      'specialty': 'Dermatologist',
      'image': 'assets/images/details_image.png',
    },
     {
      'name': 'Dr. Emily Blunt',
      'specialty': 'Psychiatrist',
      'image': 'assets/images/details_image.png',
    },
  ];

  // This list holds the data for the list view
  List<Map<String, String>> _foundDoctors = [];

  @override
  void initState() {
    _foundDoctors = _allDoctors;
    super.initState();
  }

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<Map<String, String>> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _allDoctors;
    } else {
      results = _allDoctors
          .where((user) =>
              user["name"]!.toLowerCase().contains(enteredKeyword.toLowerCase()) ||
              user["specialty"]!.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    // Refresh the UI
    setState(() {
      _foundDoctors = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Doctor List',
          style: AppTextStyles.h3.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5EAE8), // Pinkish background
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  onChanged: (value) => _runFilter(value),
                  decoration: const InputDecoration(
                    icon: Icon(Icons.search, color: Color(0xFF8D6E63)),
                    hintText: 'Search Here',
                    hintStyle: TextStyle(color: Color(0xFF8D6E63), fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              Text(
                'Your Doctor List',
                style: AppTextStyles.h3.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              
              // Doctor List Items
              Expanded(
                child: _foundDoctors.isNotEmpty
                    ? ListView.builder(
                        itemCount: _foundDoctors.length,
                        itemBuilder: (context, index) => _buildDoctorItem(
                          context,
                          name: _foundDoctors[index]['name']!,
                          specialty: _foundDoctors[index]['specialty']!,
                          imagePath: _foundDoctors[index]['image']!,
                        ),
                      )
                    : const Center(
                        child: Text(
                          'No doctors found',
                          style: TextStyle(fontSize: 24, color: Colors.grey),
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
    required String imagePath,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5EAE8), // Pinkish background
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  specialty,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: const Color(0xFF8D6E63), // Brownish
                  ),
                ),
              ],
            ),
          ),
          
          const Icon(Icons.arrow_forward, color: Color(0xFF8D6E63), size: 18),
        ],
      ),
    );
  }
}
