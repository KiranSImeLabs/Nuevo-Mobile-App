// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questionnaire.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Questionnaire _$QuestionnaireFromJson(Map<String, dynamic> json) =>
    _Questionnaire(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      questions: (json['questions'] as List<dynamic>)
          .map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$QuestionnaireToJson(_Questionnaire instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'type': instance.type,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'questions': instance.questions,
    };

_Question _$QuestionFromJson(Map<String, dynamic> json) => _Question(
  id: json['id'] as String,
  questionnaireId: json['questionnaireId'] as String,
  text: json['text'] as String,
  type: json['type'] as String,
  orderIndex: (json['orderIndex'] as num).toInt(),
  isRequired: json['isRequired'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  options: (json['options'] as List<dynamic>)
      .map((e) => Option.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$QuestionToJson(_Question instance) => <String, dynamic>{
  'id': instance.id,
  'questionnaireId': instance.questionnaireId,
  'text': instance.text,
  'type': instance.type,
  'orderIndex': instance.orderIndex,
  'isRequired': instance.isRequired,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'options': instance.options,
};

_Option _$OptionFromJson(Map<String, dynamic> json) => _Option(
  id: json['id'] as String,
  questionId: json['questionId'] as String,
  text: json['text'] as String,
  orderIndex: (json['orderIndex'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$OptionToJson(_Option instance) => <String, dynamic>{
  'id': instance.id,
  'questionId': instance.questionId,
  'text': instance.text,
  'orderIndex': instance.orderIndex,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

_QuestionResponse _$QuestionResponseFromJson(Map<String, dynamic> json) =>
    _QuestionResponse(
      questionId: json['questionId'] as String,
      selectedOptionIds: (json['selectedOptionIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      textAnswer: json['textAnswer'] as String?,
    );

Map<String, dynamic> _$QuestionResponseToJson(_QuestionResponse instance) =>
    <String, dynamic>{
      'questionId': instance.questionId,
      'selectedOptionIds': instance.selectedOptionIds,
      'textAnswer': instance.textAnswer,
    };
