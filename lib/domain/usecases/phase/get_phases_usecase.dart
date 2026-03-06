import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/phase.dart';
import '../../repositories/phase_repository.dart';
import '../../usecases/usecase.dart';

class GetPhasesUseCase implements UseCase<List<Phase>, NoParams> {
  final PhaseRepository repository;

  GetPhasesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Phase>>> call(NoParams params) async {
    return await repository.getPhases();
  }
}
