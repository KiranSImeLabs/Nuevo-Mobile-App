import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/specialist.dart';
import '../../repositories/specialist_repository.dart';

class GetSpecialistDetailsUseCase {
  final SpecialistRepository repository;

  GetSpecialistDetailsUseCase(this.repository);

  Future<Either<Failure, Specialist>> call(String id) async {
    return await repository.getSpecialistDetails(id);
  }
}
