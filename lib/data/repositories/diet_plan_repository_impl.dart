import '../../domain/repositories/diet_plan_repository.dart';
import '../../data/datasources/remote/api_client.dart';
import '../../data/models/diet_plan_model.dart';
import '../../data/models/api_response.dart';

class DietPlanRepositoryImpl implements DietPlanRepository {
  final ApiClient apiClient;

  DietPlanRepositoryImpl(this.apiClient);

  @override
  Future<DietPlanModel> getDietPlan() async {
    try {
      final response = await apiClient.getDietPlan();
      
      print('Diet Plan API Raw Response: ${response.data?.toJson()}'); // Debug log
      
      if (response.success && response.data != null) {
         return response.data!;
      } else {
        throw Exception(response.message ?? 'Failed to load diet plan');
      }
    } catch (e) {
      throw Exception('Failed to load diet plan: $e');
    }
  }
}
