import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/preferences.dart';
import '../../repositories/user_repository.dart';
import '../usecase.dart';

class GetPreferencesUseCase implements UseCase<Preferences, NoParams> {
  final UserRepository repository;

  GetPreferencesUseCase(this.repository);

  @override
  Future<Either<Failure, Preferences>> call(NoParams params) async {
    return await repository.getPreferences();
  }
}
