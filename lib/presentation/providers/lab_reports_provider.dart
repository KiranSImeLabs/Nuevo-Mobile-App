import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/lab_repository.dart';
import '../../data/models/lab_report_model.dart';
import 'core_providers.dart';
import '../../core/network/dio_client.dart';
import '../../data/datasources/remote/api_client.dart';
import '../../data/repositories/lab_repository_impl.dart';

// Provider for LabRepository
final labRepositoryProvider = Provider<LabRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  final apiClient = ApiClient(dioClient: dioClient);
  return LabRepositoryImpl(apiClient: apiClient);
});

// FutureProvider for Lab Reports
final labReportsProvider = FutureProvider<LabReportListData?>((ref) async {
  final repository = ref.watch(labRepositoryProvider);
  final result = await repository.getLabReports();
  
  return result.fold(
    (failure) => throw Exception(failure.message),
    (data) => data,
  );
});
