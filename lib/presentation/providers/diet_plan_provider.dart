import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/diet_plan_model.dart';
import '../../domain/repositories/diet_plan_repository.dart';
import '../../data/repositories/diet_plan_repository_impl.dart';
import '../../domain/usecases/diet/get_diet_plan_usecase.dart';
import 'core_providers.dart'; 

// Repository Provider
final dietPlanRepositoryProvider = Provider<DietPlanRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return DietPlanRepositoryImpl(apiClient);
});

// Use Case Provider
final getDietPlanUseCaseProvider = Provider<GetDietPlanUseCase>((ref) {
  final repository = ref.watch(dietPlanRepositoryProvider);
  return GetDietPlanUseCase(repository: repository);
});

// Diet Plan State Provider
final dietPlanProvider = FutureProvider<DietPlanModel>((ref) async {
  final getDietPlanUseCase = ref.watch(getDietPlanUseCaseProvider);
  return getDietPlanUseCase();
});
