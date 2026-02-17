import '../../data/models/diet_plan_model.dart';

abstract class DietPlanRepository {
  Future<DietPlanModel> getDietPlan();
}
