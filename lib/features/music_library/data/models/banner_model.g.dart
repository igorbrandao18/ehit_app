// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BannerModel _$BannerModelFromJson(Map<String, dynamic> json) => BannerModel(
      id: json['id'] as String,
      name: json['name'] as String,
      image: json['image'] as String,
      link: json['link'] as String,
      isActive: json['isActive'] as bool,
      targetId: json['targetId'] as String?,
      targetType: json['targetType'] as String?,
    );

Map<String, dynamic> _$BannerModelToJson(BannerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'link': instance.link,
      'isActive': instance.isActive,
      'targetId': instance.targetId,
      'targetType': instance.targetType,
    };
