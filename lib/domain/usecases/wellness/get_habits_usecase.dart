import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/wellness_program.dart';
import '../../repositories/wellness_repository.dart';
import '../usecase.dart';

class GetHabitsUseCase implements UseCase<List<Habit>, NoParams> {
  final WellnessRepository repository;

  GetHabitsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Habit>>> call(NoParams params) async {
    return await repository.getHabits();
  }
}
