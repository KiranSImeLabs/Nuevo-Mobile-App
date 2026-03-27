import '../../domain/entities/specialist.dart';

class SpecialistModel extends Specialist {
  const SpecialistModel({
    required super.id,
    required super.fullName,
    required super.role,
    super.profileImage,
    super.biography,
    super.specialties,
    super.qualifications,
    super.yearsOfExperience,
    super.languagesSpoken,
  });

  factory SpecialistModel.fromJson(Map<String, dynamic> json) {
    
    final roleMap = json['role'] as Map<String, dynamic>?;
    print('roleMap: $roleMap');
    return SpecialistModel(
      id: json['id'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      role: roleMap?['name'] as String? ?? '',
      profileImage: json['profileImage'] as String?,
      biography: json['biography'] as String?,

      specialties: (json['specialties'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),

      qualifications: (json['qualifications'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),

      yearsOfExperience: json['yearsOfExperience'] as int?,

      languagesSpoken: (json['languagesSpoken'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
  );
}

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'role': role,
      'profileImage': profileImage,
      'biography': biography,
      'specialties': specialties,
      'qualifications': qualifications,
      'yearsOfExperience': yearsOfExperience,
      'languagesSpoken': languagesSpoken,
    };
  }

  Specialist toEntity() {
    return Specialist(
      id: id,
      fullName: fullName,
      role: role,
      profileImage: profileImage,
      biography: biography,
      specialties: specialties,
      qualifications: qualifications,
      yearsOfExperience: yearsOfExperience,
      languagesSpoken: languagesSpoken,
    );
  }
}
