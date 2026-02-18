import '../../repositories/diet_plan_repository.dart';
import '../../../data/models/diet_plan_model.dart';

class GetDietPlanUseCase {
  final DietPlanRepository repository;

  GetDietPlanUseCase({required this.repository});

  Future<DietPlanModel> call() async {
    return await repository.getDietPlan();
  }
}
