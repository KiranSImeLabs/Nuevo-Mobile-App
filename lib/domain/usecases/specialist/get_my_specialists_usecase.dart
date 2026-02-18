import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/specialist.dart';
import '../../repositories/specialist_repository.dart';

class GetMySpecialistsUseCase {
  final SpecialistRepository repository;

  GetMySpecialistsUseCase(this.repository);

  Future<Either<Failure, List<Specialist>>> call() async {
    return await repository.getMySpecialists();
  }
}
