import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/phase.dart';
import '../../domain/usecases/usecase.dart';
import 'core_providers.dart';

class PhaseListNotifier extends StateNotifier<AsyncValue<List<Phase>>> {
  final Ref _ref;

  PhaseListNotifier(this._ref) : super(const AsyncValue.loading());

  Future<void> fetchPhases() async {
    state = const AsyncValue.loading();
    final getPhasesUseCase = _ref.read(getPhasesUseCaseProvider);
    final result = await getPhasesUseCase(const NoParams());

    result.fold(
      (failure) => state = AsyncValue.error(failure.message, StackTrace.current),
      (phases) {
        final sortedPhases = List<Phase>.from(phases)
          ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
        state = AsyncValue.data(sortedPhases);
      },
    );
  }
}

final phaseListProvider = StateNotifierProvider<PhaseListNotifier, AsyncValue<List<Phase>>>((ref) {
  return PhaseListNotifier(ref);
});
