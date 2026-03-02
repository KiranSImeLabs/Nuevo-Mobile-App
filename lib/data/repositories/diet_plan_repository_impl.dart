import '../../domain/repositories/diet_plan_repository.dart';
import '../../data/datasources/remote/api_client.dart';
import '../../data/models/diet_plan_model.dart';
import '../../data/models/api_response.dart';

class DietPlanRepositoryImpl implements DietPlanRepository {
  final ApiClient apiClient;

  DietPlanRepositoryImpl(this.apiClient);

  @override
  @override
  Future<DietPlanModel?> getDietPlan() async {
    try {
      final response = await apiClient.getDietPlan();
            
      if (response.success && response.data != null) {
         return response.data!;
      }
      return null;
    } catch (e) {
      // If error is 404 or "not found", return null gracefully
      if (e.toString().contains('404') || e.toString().contains('not found')) {
        return null;
      }
      throw Exception('Failed to load diet plan: $e');
    }
  }
}
