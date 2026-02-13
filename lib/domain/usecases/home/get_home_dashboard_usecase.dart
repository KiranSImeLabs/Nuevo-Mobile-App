import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/home/home_dashboard.dart';
import '../../repositories/home_repository.dart';
import '../usecase.dart';

class GetHomeDashboardUseCase implements UseCase<HomeDashboard, NoParams> {
  final HomeRepository repository;

  GetHomeDashboardUseCase(this.repository);

  @override
  Future<Either<Failure, HomeDashboard>> call(NoParams params) async {
    return await repository.getHomeDashboard();
  }
}
