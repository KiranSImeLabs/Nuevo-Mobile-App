import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/preferences.dart';
import '../../repositories/user_repository.dart';
import '../usecase.dart';

class UpdatePreferencesUseCase implements UseCase<Preferences, Preferences> {
  final UserRepository repository;

  UpdatePreferencesUseCase(this.repository);

  @override
  Future<Either<Failure, Preferences>> call(Preferences params) async {
    return await repository.updatePreferences(params);
  }
}
