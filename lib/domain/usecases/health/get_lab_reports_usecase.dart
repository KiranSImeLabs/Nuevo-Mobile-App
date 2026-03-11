import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../repositories/lab_repository.dart';
import '../../../data/models/lab_report_model.dart';
import '../usecase.dart';

class GetLabReportsUseCase {
  final LabRepository repository;

  GetLabReportsUseCase(this.repository);

  Future<Either<Failure, LabReportListData>> call(NoParams params) async {
    return await repository.getLabReports();
  }
}
