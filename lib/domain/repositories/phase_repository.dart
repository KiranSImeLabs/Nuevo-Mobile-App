import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/phase.dart';

abstract class PhaseRepository {
  Future<Either<Failure, List<Phase>>> getPhases();
}
