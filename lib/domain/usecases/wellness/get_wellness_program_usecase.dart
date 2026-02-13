import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/wellness_program.dart';
import '../../repositories/wellness_repository.dart';
import '../usecase.dart';

class GetWellnessProgramUseCase implements UseCase<WellnessProgram, NoParams> {
  final WellnessRepository repository;

  GetWellnessProgramUseCase(this.repository);

  @override
  Future<Either<Failure, WellnessProgram>> call(NoParams params) async {
    return await repository.getWellnessProgram();
  }
}
