import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/goal.dart';
import '../../domain/usecases/usecase.dart';
import 'core_providers.dart';

class GoalListNotifier extends StateNotifier<AsyncValue<List<Goal>>> {
  final Ref _ref;

  GoalListNotifier(this._ref) : super(const AsyncValue.loading());

  Future<void> fetchGoals() async {
    state = const AsyncValue.loading();
    final getGoalsUseCase = _ref.read(getGoalsUseCaseProvider);
    final result = await getGoalsUseCase(const NoParams());

    result.fold(
      (failure) => state = AsyncValue.error(failure.message, StackTrace.current),
      (goals) => state = AsyncValue.data(goals),
    );
  }
}

final goalListProvider = StateNotifierProvider<GoalListNotifier, AsyncValue<List<Goal>>>((ref) {
  return GoalListNotifier(ref);
});
