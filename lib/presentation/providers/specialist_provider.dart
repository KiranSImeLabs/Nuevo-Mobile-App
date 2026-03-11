import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/specialist.dart';
import 'core_providers.dart';

// State for the specialist list
class SpecialistListState {
  final AsyncValue<List<Specialist>> specialists;
  
  SpecialistListState({
    this.specialists = const AsyncValue.loading(),
  });
  
  SpecialistListState copyWith({
    AsyncValue<List<Specialist>>? specialists,
  }) {
    return SpecialistListState(
      specialists: specialists ?? this.specialists,
    );
  }
}

class SpecialistListNotifier extends StateNotifier<AsyncValue<List<Specialist>>> {
  final Ref _ref;
  
  SpecialistListNotifier(this._ref) : super(const AsyncValue.loading());
  
  Future<void> fetchSpecialists() async {
    state = const AsyncValue.loading();
    final getMySpecialists = _ref.read(getMySpecialistsUseCaseProvider);
    final result = await getMySpecialists();
    
    result.fold(
      (failure) => state = AsyncValue.error(failure.message, StackTrace.current),
      (specialists) => state = AsyncValue.data(specialists),
    );
  }
}

final specialistListProvider = StateNotifierProvider<SpecialistListNotifier, AsyncValue<List<Specialist>>>((ref) {
  return SpecialistListNotifier(ref);
});

// Provider for a single specialist details
final specialistDetailsProvider = FutureProvider.family<Specialist, String>((ref, id) async {
  final getSpecialistDetails = ref.read(getSpecialistDetailsUseCaseProvider);
  final result = await getSpecialistDetails(id);
  print('result $result');
  return result.fold(
    (failure) => throw failure.message,
    (specialist) => specialist,
  );
});
