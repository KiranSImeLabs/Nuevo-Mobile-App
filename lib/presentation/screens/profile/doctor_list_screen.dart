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
            color: const Color(0xFF4A4543), // Slightly softer dark for header
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4A4543)), // Match title color
          onPressed: () => Navigator.of(context).pop(),
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
                  color: const Color(0xFFF2E6E4), // Slightly darker pinkish/beige to be distinct from white
                  borderRadius: BorderRadius.circular(12),
                  // border: Border.all(color: const Color(0xFFE0D0CC)), // Optional border for visibility
                ),//Color(0xFF6A1E1E)
                child: TextField(
                  onChanged: (value) => _runFilter(value),
                  style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: Colors.black, // Force black color
                      fontWeight: FontWeight.normal,
                  ),
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFF2E6E4), // Explicitly set color here to override theme
                    prefixIcon: Icon(Icons.search, color: Color(0xFF8D6E63), size: 24), // Brownish grey
                    hintText: 'Search Here',
                    hintStyle: TextStyle(
                        color: Color(0xFF9E9E9E), 
                        fontSize: 15, 
                        fontWeight: FontWeight.w400
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
                  color: const Color(0xFF1D1B20), // Dark headings
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
                          style: TextStyle(fontSize: 16, color: Colors.grey),
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
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF2E6E4), // Match search bar background
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 56, // Slightly larger avatar
            height: 56,
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w500, // Medium weight
                    fontSize: 16,
                    color: const Color(0xFF1D1B20),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  specialty,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: const Color(0xFF735B4D), // Muted brown/grey
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          
          // Thin arrow icon
          const Icon(Icons.arrow_forward, color: Color(0xFF8D6E63), size: 18), 
          // Note: Design might show a thinner arrow, but Material's arrow_forward is standard.
          // Could use CupertinoIcons.arrow_right if desired, but sticking to Material consistency.
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
