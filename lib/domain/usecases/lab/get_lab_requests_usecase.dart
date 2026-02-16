import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../../data/models/lab_request_model.dart';
import '../../repositories/lab_repository.dart';

class GetLabRequestsUseCase {
  final LabRepository repository;

  GetLabRequestsUseCase({required this.repository});

  Future<Either<Failure, LabRequestListResponseData>> call() async {
    return await repository.getLabRequests();
  }
}
