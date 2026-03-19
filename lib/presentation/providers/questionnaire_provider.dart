import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/questionnaire.dart';
import '../../domain/repositories/questionnaire_repository.dart';
// Note: We need to register QuestionnaireRepository in a provider, e.g., questionnaireRepositoryProvider.
// I'll create the repo provider below, assuming we have an apiClientProvider.
import '../../core/network/dio_client.dart';
import '../../data/datasources/remote/api_client.dart';
import '../../data/repositories/questionnaire_repository_impl.dart';

import 'core_providers.dart';

part 'questionnaire_provider.freezed.dart';

// Provides the repository
final questionnaireRepositoryProvider = Provider<QuestionnaireRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return QuestionnaireRepositoryImpl(apiClient: apiClient);
});

@freezed
abstract class QuestionnaireState with _$QuestionnaireState {
  const factory QuestionnaireState({
    @Default(0) int currentIndex,
    @Default({}) Map<String, Set<String>> selectedOptionIds,
    @Default({}) Map<String, String> textAnswers,
    @Default(false) bool isSubmitting,
    String? submitError,
    @Default(false) bool submitSuccess,
  }) = _QuestionnaireState;
}

class QuestionnaireNotifier extends StateNotifier<QuestionnaireState> {
  final QuestionnaireRepository _repository;
  final Questionnaire _questionnaire;

  QuestionnaireNotifier(this._repository, this._questionnaire)
      : super(const QuestionnaireState());

  void toggleOption(String questionId, String optionId, bool isMultiSelect) {
    if (isMultiSelect) {
      final currentSelected = state.selectedOptionIds[questionId] ?? {};
      final newSelected = Set<String>.from(currentSelected);
      if (newSelected.contains(optionId)) {
        newSelected.remove(optionId);
      } else {
        newSelected.add(optionId);
      }
      state = state.copyWith(
        selectedOptionIds: {...state.selectedOptionIds, questionId: newSelected},
      );
    } else {
      // Single selection logic
      state = state.copyWith(
        selectedOptionIds: {...state.selectedOptionIds, questionId: {optionId}},
      );
    }
  }

  void updateTextAnswer(String questionId, String text) {
    state = state.copyWith(
      textAnswers: {...state.textAnswers, questionId: text},
    );
  }

  void nextQuestion() {
    if (state.currentIndex < _questionnaire.questions.length - 1) {
      state = state.copyWith(currentIndex: state.currentIndex + 1);
    }
  }

  void previousQuestion() {
    if (state.currentIndex > 0) {
      state = state.copyWith(currentIndex: state.currentIndex - 1);
    }
  }

  Future<void> submit(String patientTaskId) async {
    state = state.copyWith(isSubmitting: true, submitError: null);
    
    final responses = _questionnaire.questions.map((q) {
      return QuestionResponse(
        questionId: q.id,
        selectedOptionIds: state.selectedOptionIds[q.id]?.toList() ?? [],
        textAnswer: state.textAnswers[q.id],
      );
    }).toList();

    final result = await _repository.submitQuestionnaire(patientTaskId, responses);
    
    result.fold(
      (failure) {
        state = state.copyWith(isSubmitting: false, submitError: failure.message);
      },
      (_) {
        state = state.copyWith(isSubmitting: false, submitSuccess: true);
      },
    );
  }
}

// FutureProvider to fetch the questionnaire
final fetchQuestionnaireProvider = FutureProvider.family<Questionnaire, String>((ref, id) async {
  final repository = ref.read(questionnaireRepositoryProvider);
  final result = await repository.getQuestionnaire(id);
  
  return result.fold(
    (failure) => throw Exception(failure.message),
    (questionnaire) => questionnaire,
  );
});

// StateNotifierProvider to manage answers. It links with the fetched questionnaire
final questionnaireNotifierProvider = StateNotifierProvider.family<QuestionnaireNotifier, QuestionnaireState, Questionnaire>((ref, questionnaire) {
  final repository = ref.read(questionnaireRepositoryProvider);
  return QuestionnaireNotifier(repository, questionnaire);
});
