import '../../domain/entities/phase.dart';

class PhaseModel extends Phase {
  const PhaseModel({
    required super.id,
    required super.name,
    required super.durationWeeks,
    required super.orderIndex,
    required super.programType,
  });

  factory PhaseModel.fromJson(Map<String, dynamic> json) {
    return PhaseModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      durationWeeks: json['durationWeeks'] as int? ?? 0,
      orderIndex: json['orderIndex'] as int? ?? 0,
      programType: json['programType'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'durationWeeks': durationWeeks,
      'orderIndex': orderIndex,
      'programType': programType,
    };
  }

  Phase toEntity() {
    return Phase(
      id: id,
      name: name,
      durationWeeks: durationWeeks,
      orderIndex: orderIndex,
      programType: programType,
    );
  }
}
