import 'package:equatable/equatable.dart';

class Banner extends Equatable {
  final String id;
  final String name;
  final String image;
  final String link;
  final bool isActive;
  final String? targetId;
  final String? targetType;

  const Banner({
    required this.id,
    required this.name,
    required this.image,
    required this.link,
    required this.isActive,
    this.targetId,
    this.targetType,
  });

  @override
  List<Object?> get props => [id, name, image, link, isActive, targetId, targetType];
}

