import 'package:equatable/equatable.dart';

class HomeQuickAccessItem extends Equatable {
  final String id;
  final String title;
  final String icon;

  const HomeQuickAccessItem({
    required this.id,
    required this.title,
    required this.icon,
  });

  @override
  List<Object?> get props => [id, title, icon];
}
