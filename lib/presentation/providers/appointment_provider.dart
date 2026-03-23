import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/appointment_repository.dart';
import '../../data/repositories/appointment_repository_impl.dart';
import '../../data/models/appointment_model.dart';
import '../../data/models/api_response.dart';
import '../../core/network/dio_client.dart';
import 'core_providers.dart';

final appointmentRepositoryProvider = Provider<AppointmentRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);

  return AppointmentRepositoryImpl(apiClient);
});

final timeSlotsProvider = FutureProvider.family<List<TimeSlot>, String>((ref, date) async {
  final repository = ref.watch(appointmentRepositoryProvider);
  final response = await repository.getTimeSlots(date);
  if (response.success && response.data != null) {
    return response.data!;
  }
  throw Exception(response.message ?? 'Failed to fetch time slots');
});
