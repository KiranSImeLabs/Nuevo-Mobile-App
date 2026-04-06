import 'package:freezed_annotation/freezed_annotation.dart';

part 'questionnaire.freezed.dart';
part 'questionnaire.g.dart';

@freezed
abstract class Questionnaire with _$Questionnaire {
  const factory Questionnaire({
    required String id,
    required String title,
    required String description,
    required String type,
    required DateTime createdAt,
    required DateTime updatedAt,
    required List<Question> questions,
  }) = _Questionnaire;

  factory Questionnaire.fromJson(Map<String, dynamic> json) =>
      _$QuestionnaireFromJson(json);
}

@freezed
abstract class Question with _$Question {
  const factory Question({
    required String id,
    required String questionnaireId,
    required String text,
    required String type,
    required int orderIndex,
    required bool isRequired,
    required DateTime createdAt,
    required DateTime updatedAt,
    required List<Option> options,
  }) = _Question;

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);
}

@freezed
abstract class Option with _$Option {
  const factory Option({
    required String id,
    required String questionId,
    required String text,
    required int orderIndex,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Option;

  factory Option.fromJson(Map<String, dynamic> json) => _$OptionFromJson(json);
}

@freezed
abstract class QuestionResponse with _$QuestionResponse {
  const factory QuestionResponse({
    required String questionId,
    required List<String> selectedOptionIds,
    String? textAnswer,
  }) = _QuestionResponse;

  factory QuestionResponse.fromJson(Map<String, dynamic> json) =>
      _$QuestionResponseFromJson(json);
}
