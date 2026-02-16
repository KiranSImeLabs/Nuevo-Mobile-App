import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../../data/models/lab_request_model.dart';
import '../../repositories/lab_repository.dart';

class CreateLabRequestUseCase {
  final LabRepository repository;

  CreateLabRequestUseCase({required this.repository});

  Future<Either<Failure, LabRequestData>> call(String notes) async {
    return await repository.createLabRequest(notes);
  }
}
