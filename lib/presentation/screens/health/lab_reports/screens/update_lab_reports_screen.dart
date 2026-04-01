import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../widgets/common/dashed_border.dart';

class UpdateLabReportsScreen extends StatefulWidget {
  const UpdateLabReportsScreen({super.key});

  @override
  State<UpdateLabReportsScreen> createState() => _UpdateLabReportsScreenState();
}

class _UpdateLabReportsScreenState extends State<UpdateLabReportsScreen> {
  final _dateController = TextEditingController(text: "10/24/2023");
  final _labNameController = TextEditingController();
  final _labLocationController = TextEditingController();
  final List<String> _addedParameters = [];
  final Map<String, Map<String, TextEditingController>> _detailedControllers = {};

  final Map<String, List<String>> _testDetailsMap = {
    "Blood Sugar": ["Fasting (mg/dL)", "Post-Prandial (mg/dL)"],
    "Blood Pressure": ["Systolic (mmHg)", "Diastolic (mmHg)"],
    "Lipid Profile": ["Total Cholesterol (mg/dL)", "HDL (mg/dL)", "LDL (mg/dL)"],
    "Thyroid Panel (TSH, T3, T4)": ["TSH (mIU/L)", "Free T3 (pg/mL)", "Free T4 (ng/dL)"],
    "Complete Blood Count (CBC)": ["RBC (M/mcL)", "WBC (K/mcL)", "Hemoglobin (g/dL)", "Hematocrit (%)", "Platelets (K/mcL)"],
    "Comprehensive Metabolic Panel (CMP)": ["Glucose (mg/dL)", "Calcium (mg/dL)", "Sodium (mEq/L)", "Potassium (mEq/L)", "BUN (mg/dL)", "Creatinine (mg/dL)"],
    "Liver Function Panel": ["ALT (U/L)", "AST (U/L)", "ALP (U/L)", "Total Bilirubin (mg/dL)", "Albumin (g/dL)"],
    "Iron Panel": ["Serum Iron (mcg/dL)", "Ferritin (ng/mL)", "TIBC (mcg/dL)", "Transferrin Saturation (%)"],
    "Testosterone (Total, Free)": ["Total Testosterone (ng/dL)", "Free Testosterone (pg/mL)"],
    "Vitamin D": ["25-Hydroxy Vitamin D (ng/mL)"],
    "HbA1c": ["HbA1c (%)"],
    "Vitamin B12": ["Vitamin B12 (pg/mL)"],
    "Folate": ["Folate (ng/mL)"],
    "Magnesium": ["Magnesium (mg/dL)"],
    "C-Reactive Protein (CRP)": ["hs-CRP (mg/L)"],
    "Cortisol (Morning)": ["Cortisol (mcg/dL)"],
    "Ferritin": ["Ferritin (ng/mL)"],
    "Insulin (Fasting)": ["Insulin (uIU/mL)"],
  };

  @override
  void dispose() {
    _dateController.dispose();
    _labNameController.dispose();
    _labLocationController.dispose();
    for (var paramMap in _detailedControllers.values) {
      for (var controller in paramMap.values) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF8F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF735B4D)),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            }
          },
        ),
        title: const Text(
          "Wellness Lab",
          style: TextStyle(
            color: Color(0xFF735B4D),
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "BIOMARKER ENTRY",
              style: TextStyle(
                color: Color(0xFFA05E44),
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Update Lab Reports",
              style: TextStyle(
                color: Color(0xFF1E1E1E),
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Document your journey toward vitality. Every data point is a step closer to understanding your unique biological rhythm.",
              style: TextStyle(
                color: Color(0xFF757575),
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            
            _buildTestDetailsCard(),
            const SizedBox(height: 24),
            
            ..._addedParameters.map((param) {
              Widget cardContent;
              final onRemove = () {
                setState(() {
                  _addedParameters.remove(param);
                  final controllers = _detailedControllers.remove(param);
                  if (controllers != null) {
                    for (var c in controllers.values) {
                      c.dispose();
                    }
                  }
                });
              };
              
              if (param == "Blood Pressure") {
                cardContent = _buildBloodPressureCard(onRemove: onRemove);
              } else {
                cardContent = _buildDetailedGenericCard(param, onRemove);
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: cardContent,
              );
            }),
            
            _buildAddParameterBtn(),
            const SizedBox(height: 32),
            
            _buildFooter(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F2EF),
        borderRadius: BorderRadius.circular(24),
      ),
      child: child,
    );
  }

  Widget _buildHeaderRow(IconData icon, String title, String subtitle, {VoidCallback? onRemove}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFEFE6E2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFFA05E44), size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF1E1E1E),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF8C8C8C),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        if (onRemove != null)
          IconButton(
            icon: const Icon(Icons.close, color: Color(0xFF8C8C8C)),
            onPressed: onRemove,
          ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF4A4A4A),
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    TextEditingController? controller,
    Widget? suffixIcon,
    Widget? suffixPrefix,
    bool isCenter = false,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFF1EAE6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        textAlign: isCenter ? TextAlign.center : TextAlign.start,
        style: TextStyle(
          color: const Color(0xFF4A4A4A),
          fontSize: isCenter ? 24 : 16,
          fontWeight: isCenter ? FontWeight.bold : FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: const Color(0xFFDCC8C0),
            fontSize: isCenter ? 24 : 16,
            fontWeight: isCenter ? FontWeight.w500 : FontWeight.w400,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          suffixIcon: suffixIcon ?? (suffixPrefix != null ? Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [suffixPrefix],
            ),
          ) : null),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFA05E44),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1E1E1E),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.month}/${picked.day}/${picked.year}";
      });
    }
  }

  Widget _buildTestDetailsCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderRow(Icons.calendar_today_outlined, "Test Date", "WHEN WAS THE SAMPLE TAKEN?"),
          const SizedBox(height: 24),
          _buildLabel("SELECT DATE"),
          _buildTextField(
            hint: "MM/DD/YYYY",
            controller: _dateController,
            readOnly: true,
            onTap: () => _selectDate(context),
            suffixIcon: const Icon(Icons.calendar_month_outlined, color: Color(0xFF4A4A4A), size: 20),
          ),
          const SizedBox(height: 20),
          _buildLabel("LAB NAME"),
          _buildTextField(hint: "e.g. Quest Diagnostics", controller: _labNameController),
          const SizedBox(height: 20),
          _buildLabel("LAB LOCATION"),
          _buildTextField(hint: "City, State", controller: _labLocationController),
        ],
      ),
    );
  }

  Widget _buildDetailedGenericCard(String param, VoidCallback onRemove) {
    final controllersMap = _detailedControllers[param] ?? {};
    final fields = _testDetailsMap[param] ?? ["Result Value"];
    
    // Assign generic icon if needed, but water_drop or science is fine.
    IconData cardIcon = Icons.science_outlined;
    if (param.contains("Blood")) cardIcon = Icons.water_drop_outlined;

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderRow(cardIcon, param, "ENTER DETAILS", onRemove: onRemove),
          const SizedBox(height: 24),
          ...fields.map((field) {
            final isLast = field == fields.last;
            return Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel(field.toUpperCase()),
                  _buildTextField(
                    hint: "0.0",
                    controller: controllersMap[field],
                    isCenter: false,
                  ),
                ],
              ),
            );
          }).toList()
        ],
      ),
    );
  }

  Widget _buildBloodPressureCard({required VoidCallback onRemove}) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderRow(Icons.monitor_heart_outlined, "Blood Pressure", "VITAL SIGNS (mmHg)", onRemove: onRemove),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildLabel("SYSTOLIC"),
                    _buildTextField(hint: "120", controller: _detailedControllers["Blood Pressure"]?["Systolic (mmHg)"], isCenter: true),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
                child: Text("/", style: TextStyle(color: Color(0xFFDCC8C0), fontSize: 24, fontWeight: FontWeight.w300)),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildLabel("DIASTOLIC"),
                    _buildTextField(hint: "80", controller: _detailedControllers["Blood Pressure"]?["Diastolic (mmHg)"], isCenter: true),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "Ensure you are seated comfortably for 5 minutes before taking the reading.",
            style: TextStyle(color: Color(0xFF8C8C8C), fontSize: 11, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }



  Widget _buildAddParameterBtn() {
    return InkWell(
      onTap: _showAddParameterBottomSheet,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: DashedBorder.all(color: const Color(0xFFE5D5D0), width: 1.5),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Color(0xFF4A3E39),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 16),
            ),
            const SizedBox(height: 12),
            const Text(
              "Add Custom Parameter",
              style: TextStyle(
                color: Color(0xFF1E1E1E),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "THYROID, VITAMIN D, HBA1C, ETC.",
              style: TextStyle(
                color: Color(0xFF8C8C8C),
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F2EF),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.verified_user, color: Color(0xFF00796B), size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Secure & Private",
                      style: TextStyle(
                        color: Color(0xFF1E1E1E),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Your health data is encrypted and visible only to you.",
                      style: TextStyle(
                        color: Color(0xFF757575),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => context.pop(),
                  child: const Text(
                    "Discard",
                    style: TextStyle(
                      color: Color(0xFF4A4A4A),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Save logi
                    context.pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Lab report updated successfully!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA05E44),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Save Report",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            "Important: This report is for informational purposes only. Always consult with a qualified healthcare professional before making any medical decisions based on these results.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF8C8C8C),
              fontSize: 9,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddParameterBottomSheet() {
    final availableParams = [
      "Blood Sugar",
      "Blood Pressure",
      "Lipid Profile",
      "Thyroid Panel (TSH, T3, T4)",
      "Vitamin D",
      "HbA1c",
      "Complete Blood Count (CBC)",
      "Comprehensive Metabolic Panel (CMP)",
      "Liver Function Panel",
      "Iron Panel",
      "Testosterone (Total, Free)",
      "Vitamin B12",
      "Folate",
      "Magnesium",
      "C-Reactive Protein (CRP)",
      "Cortisol (Morning)",
      "Ferritin",
      "Insulin (Fasting)"
    ];
    
    final paramsList = availableParams.where((p) => !_addedParameters.contains(p)).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            String searchQuery = "";
            return StatefulBuilder(
              builder: (context, setSheetState) {
                final filteredList = paramsList
                    .where((p) => p.toLowerCase().contains(searchQuery.toLowerCase()))
                    .toList();
                
                return Column(
                  children: [
                    const SizedBox(height: 12),
                    Container(
                      width: 48,
                      height: 5,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Add Custom Parameter",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E1E),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: TextField(
                        onChanged: (val) {
                          setSheetState(() {
                            searchQuery = val;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Search lab parameters...",
                          hintStyle: const TextStyle(color: Color(0xFFBDBDBD), fontSize: 16),
                          prefixIcon: const Icon(Icons.search, color: Color(0xFFA05E44)),
                          filled: true,
                          fillColor: const Color(0xFFF9F9F9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: filteredList.isEmpty
                          ? const Center(
                              child: Text(
                                "No matching parameters found.",
                                style: TextStyle(color: Color(0xFF757575)),
                              ),
                            )
                          : ListView.separated(
                              controller: scrollController,
                              itemCount: filteredList.length,
                              separatorBuilder: (context, index) => const Divider(height: 1, indent: 24, endIndent: 24, color: Color(0xFFEEEEEE)),
                              itemBuilder: (context, index) {
                                final param = filteredList[index];
                                return ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                                  title: Text(
                                    param,
                                    style: const TextStyle(
                                      color: Color(0xFF4A4A4A),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  trailing: const Icon(Icons.add_circle, color: Color(0xFFA05E44), size: 28),
                                  onTap: () {
                                    Navigator.pop(context);
                                    setState(() {
                                      _addedParameters.add(param);
                                      
                                      // Initialize dynamic controllers for every field required by this param
                                      _detailedControllers[param] = {};
                                      final fields = _testDetailsMap[param] ?? ["Result Value"];
                                      for (var f in fields) {
                                        _detailedControllers[param]![f] = TextEditingController();
                                      }
                                    });
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
