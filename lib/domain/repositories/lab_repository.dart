import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../data/models/lab_request_model.dart';

/// Lab Request Repository Interface
abstract class LabRepository {
  /// Create a new lab request
  /// Returns [LabRequestData] on success or [Failure] on error
  Future<Either<Failure, LabRequestData>> createLabRequest(String notes);

  /// Get list of lab requests
  Future<Either<Failure, LabRequestListResponseData>> getLabRequests();

  /// Get lab request details by ID
  Future<Either<Failure, LabRequestData>> getLabRequestById(String id);
}
