import 'package:equatable/equatable.dart';

class Specialist extends Equatable {
  final String id;
  final String fullName;
  final String role;
  final String? profileImage;
  final String? biography;
  final List<String>? specialties;
  final List<String>? qualifications;
  final int? yearsOfExperience;
  final List<String>? languagesSpoken;

  const Specialist({
    required this.id,
    required this.fullName,
    required this.role,
    this.profileImage,
    this.biography,
    this.specialties,
    this.qualifications,
    this.yearsOfExperience,
    this.languagesSpoken,
  });

  @override
  List<Object?> get props => [
        id,
        fullName,
        role,
        profileImage,
        biography,
        specialties,
        qualifications,
        yearsOfExperience,
        languagesSpoken,
      ];
}
