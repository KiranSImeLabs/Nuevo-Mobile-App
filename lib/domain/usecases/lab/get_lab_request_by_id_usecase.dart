import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../../data/models/lab_request_model.dart';
import '../../repositories/lab_repository.dart';

class GetLabRequestByIdUseCase {
  final LabRepository repository;

  GetLabRequestByIdUseCase({required this.repository});

  Future<Either<Failure, LabRequestData>> call(String id) async {
    return await repository.getLabRequestById(id);
  }
}
