import 'package:equatable/equatable.dart';

class SessionInfo extends Equatable {
  final String time;
  final String date;
  final String label;
  final String bookingId;

  const SessionInfo({
    required this.time,
    required this.date,
    required this.label,
    required this.bookingId,
  });

  @override
  List<Object?> get props => [time, date, label, bookingId];
}

class QuickStats extends Equatable {
  final String? nuevoAge;
  final SessionInfo? nextSession;

  const QuickStats({
    this.nuevoAge,
    this.nextSession,
  });

  @override
  List<Object?> get props => [nuevoAge, nextSession];
}
