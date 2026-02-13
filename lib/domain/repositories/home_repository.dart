import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/home/home_dashboard.dart';

abstract class HomeRepository {
  Future<Either<Failure, HomeDashboard>> getHomeDashboard();
}
