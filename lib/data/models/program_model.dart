import 'package:json_annotation/json_annotation.dart';

part 'program_model.g.dart';

@JsonSerializable()
class ProgramModel {
  final String id;
  final String title;
  final String? description;
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  final double? price;
  final String? currency;
  final int? durationInWeeks;
  
  const ProgramModel({
    required this.id,
    required this.title,
    this.description,
    this.imageUrl,
    this.price,
    this.currency,
    this.durationInWeeks,
  });
  
  factory ProgramModel.fromJson(Map<String, dynamic> json) =>
      _$ProgramModelFromJson(json);
      
  Map<String, dynamic> toJson() => _$ProgramModelToJson(this);
}
