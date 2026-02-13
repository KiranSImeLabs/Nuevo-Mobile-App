import 'package:equatable/equatable.dart';

class QuickStats extends Equatable {
  final String? nuevoAge;
  final String? nextSession;

  const QuickStats({
    this.nuevoAge,
    this.nextSession,
  });

  @override
  List<Object?> get props => [nuevoAge, nextSession];
}
