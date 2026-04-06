import 'package:dartz/dartz.dart';
import '../entities/questionnaire.dart';
import '../../core/errors/failures.dart';

abstract class QuestionnaireRepository {
  Future<Either<Failure, Questionnaire>> getQuestionnaire(String id);
  
  Future<Either<Failure, void>> submitQuestionnaire(
      String patientTaskId, List<QuestionResponse> responses);
}
