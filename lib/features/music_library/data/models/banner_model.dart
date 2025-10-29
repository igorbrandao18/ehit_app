import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/banner.dart';

part 'banner_model.g.dart';

@JsonSerializable()
class BannerModel extends Banner {
  const BannerModel({
    required super.id,
    required super.name,
    required super.image,
    required super.link,
    required super.isActive,
    super.targetId,
    super.targetType,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) => _$BannerModelFromJson(json);

  Map<String, dynamic> toJson() => _$BannerModelToJson(this);

  factory BannerModel.fromEntity(Banner banner) {
    return BannerModel(
      id: banner.id,
      name: banner.name,
      image: banner.image,
      link: banner.link,
      isActive: banner.isActive,
      targetId: banner.targetId,
      targetType: banner.targetType,
    );
  }

  Banner toEntity() {
    return Banner(
      id: id,
      name: name,
      image: image,
      link: link,
      isActive: isActive,
      targetId: targetId,
      targetType: targetType,
    );
  }
}

