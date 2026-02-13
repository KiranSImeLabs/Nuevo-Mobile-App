import '../../../domain/entities/home/home_quick_access_item.dart';

class HomeQuickAccessItemModel extends HomeQuickAccessItem {
  const HomeQuickAccessItemModel({
    required super.id,
    required super.title,
    required super.icon,
  });

  factory HomeQuickAccessItemModel.fromJson(Map<String, dynamic> json) {
    return HomeQuickAccessItemModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      icon: json['icon'] ?? '',
    );
  }
}
